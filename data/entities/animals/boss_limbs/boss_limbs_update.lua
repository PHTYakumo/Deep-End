dofile( "data/scripts/lib/coroutines.lua" )
dofile( "data/scripts/lib/utilities.lua" )

-- enum for changing C++ logic state. keep this in sync with the values in limbboss_system.cpp
MoveAroundNest = 0
FollowPlayer   = 1
Escape         = 2
DontMove       = 3

local details_hidden = false
local is_dead = false
local did_wait = false


-- gather some data we're gonna reuse --------------

local herd_id = get_herd_id( GetUpdatedEntityID() )
local force_coeff_orig = component_get_value_float(  GetUpdatedEntityID(), "PhysicsAIComponent", "force_coeff", 10.0 )

-- animate eyes and skull randomly -----------------

async_loop(function()
	wait(60)
	if details_hidden == false then
		animate_random_detail()
	end
end)


-- do various attack patterns -----------------

function phase0()
	-- init
	set_logic_state( FollowPlayer )
	-- timeline
	boss_wait(200)
	choose_random_phase()
end

function phase1()
	-- init
	set_logic_state( DontMove )
	
	expose_weak_spot()
	spawn_minion()
	circleshot()

	boss_wait(20)

	prepare_chase()
	chase_start()
	homingshot()

	boss_wait(20)

	chase_stop()

	circleshot()

	boss_wait(10)
	
	hide_weak_spot()

	boss_wait(10)

	choose_random_phase()
end

function phase2()
	-- init
	set_logic_state( FollowPlayer )
	
	prepare_chase()
	chase_start()
	spawn_minion()

	boss_wait(30)

	spawn_minion()
	chase_stop()

	boss_wait(10)
	
	choose_random_phase()
end

function phase3()
	-- init
	set_logic_state( FollowPlayer )
	
	prepare_chase()
	chase_start()
	circleshot()

	boss_wait(30)

	homingshot()

	chase_stop()

	boss_wait(10)
	
	choose_random_phase()
end

function phase4()
	-- init
	set_logic_state( DontMove )
	
	expose_weak_spot()
	spawn_minion()
	homingshot()

	boss_wait(20)

	circleshot()

	boss_wait(20)

	homingshot()

	boss_wait(10)
	
	hide_weak_spot()

	boss_wait(10)
	
	choose_random_phase()
end


function choose_random_phase()
	local r = math.random(0,4)
	if     r == 0 then state = phase0
	elseif r == 1 then state = phase1
	elseif r == 2 then state = phase2
	elseif r == 3 then state = phase3
	else               state = phase4
	end
end


-- helpers -----------------

function circleshot()
	set_main_animation( "attack_ranged", "opened" )
	boss_wait(5)

	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local angle  = 0
	local amount = 8
	local space  = math.floor(360 / amount)
	local speed  = 230
	
	for i=1,amount do
		local vel_x = math.cos( math.rad(angle) ) * speed
		local vel_y = math.sin( math.rad(angle) ) * speed
		angle = angle + space

		local orb = shoot_projectile( this, "data/entities/animals/boss_limbs/orb_boss_limbs.xml", pos_x, pos_y, vel_x, vel_y )
	end

	if GameGetFrameNum() - tonumber( GlobalsGetValue( "DEEP_END_SOUND_LIMBS_BOSS_SCREAM_PLAY_FRAME" ) ) > 15 then
		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/necromancer/death", pos_x, pos_y )

		GlobalsSetValue( "DEEP_END_SOUND_LIMBS_BOSS_SCREAM_PLAY_FRAME", tostring( GameGetFrameNum() ) )
	end
end

function homingshot()
	set_main_animation( "attack_ranged", "opened" )
	boss_wait(5)

	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local vel_x = 0
	local vel_y = -30

	shoot_projectile( this, "data/entities/animals/boss_limbs/orb_pink_big.xml", pos_x, pos_y, vel_x, vel_y )
	
	if GameGetFrameNum() - tonumber( GlobalsGetValue( "DEEP_END_SOUND_LIMBS_BOSS_SCREAM_PLAY_FRAME" ) ) > 15 then
		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/necromancer/death", pos_x, pos_y )

		GlobalsSetValue( "DEEP_END_SOUND_LIMBS_BOSS_SCREAM_PLAY_FRAME", tostring( GameGetFrameNum() ) )
	end
end

function spawn_minion()
	-- check that we only have less than N minions
	local existing_minion_count = 0
	local existing_minions = EntityGetWithTag( "slimeshooter_boss_limbs" )
	if ( #existing_minions > 0 ) then
		existing_minion_count = #existing_minions
	end

	if existing_minion_count >= 13 then
		return
	end

	-- spawn
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	EntityLoad( "data/entities/animals/boss_limbs/boss_limbs.xml", pos_x, pos_y )
	EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", pos_x, pos_y )

	GamePlaySound( "data/audio/Desktop/animals.bank", "animals/boss_centipede/dying", pos_x, pos_y )
	GamePrint( tostring(existing_minion_count) .. "/16" )
	
	-- EntityKill( entity_id )
	
	--[[
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	SetRandomSeed( GameGetFrameNum(), x + y )
	
	local slime = EntityLoad( "data/entities/animals/boss_limbs/slimeshooter_boss_limbs.xml", x, y )
	edit_component( slime, "VelocityComponent", function(comp,vars)
		local vel_x = Random(-90,90)
		local vel_y = Random(-150,25)
		ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y )
	end)
	]]--
end

function get_idle_animation_name()
	return "stand"
end

function prepare_chase()
	set_main_animation( "charge", get_idle_animation_name() )
	boss_wait(20)
end

function chase_start()
	local physics_ai = EntityGetFirstComponent( GetUpdatedEntityID(), "PhysicsAIComponent" )
	ComponentSetValue2( physics_ai, "force_coeff", force_coeff_orig * 5.0 )
	
	local celleater = EntityGetFirstComponent( GetUpdatedEntityID(), "CellEaterComponent" )
	ComponentSetValue2( celleater, "eat_probability", 100 )
end

function chase_stop()
	local physics_ai = EntityGetFirstComponent( GetUpdatedEntityID(), "PhysicsAIComponent" )
	ComponentSetValue2( physics_ai, "force_coeff", force_coeff_orig )
	
	local celleater = EntityGetFirstComponent( GetUpdatedEntityID(), "CellEaterComponent" )
	ComponentSetValue2( celleater, "eat_probability",0 )
end
	
function expose_weak_spot()
	set_main_animation( "open", "opened" )
	set_details_hidden( true )
	boss_wait(5)
	set_hitboxes_weak( true )
	boss_wait(10)
end

function hide_weak_spot()
	set_main_animation( "close", get_idle_animation_name() )
	boss_wait(5)
	set_hitboxes_weak( false )
	boss_wait(10)
	set_details_hidden( false )
end


function set_hitboxes_weak( weak_spot_exposed )
	EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "hitbox_weak_spot", weak_spot_exposed )
	EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "hitbox_default",   weak_spot_exposed == false )
end

function set_main_animation( current_name, next_name )
	local sprite = EntityGetFirstComponent( GetUpdatedEntityID(), "SpriteComponent" )
	if ( sprite ~= nil ) then
		animate_sprite( sprite, current_name, next_name )
	end
end


function animate_random_detail()
	local which = math.random(1, 3)
	for_comps( "SpriteComponent", function(i,sprite)
		if i == which + 1 then
		animate_sprite_simple( sprite, "animate", "stand" )
		end
	end)
end

function set_details_hidden( is_hidden )
	if is_hidden then
		set_detail_animation( "invisible" )
	else
		set_detail_animation( "stand" )
	end
	details_hidden = is_hidden
end

function set_detail_animation( current_name )
	for_comps( "SpriteComponent", function(i,sprite)
		if i > 1 then
			ComponentSetValue2( sprite, "rect_animation", current_name )
		end
	end)
end


function animate_sprite( sprite, current_name, next_name )
	GamePlayAnimation( GetUpdatedEntityID(), current_name, 0, next_name, 0 )
	--ComponentSetValue2( sprite, "rect_animation", current_name )
	--ComponentSetValue2( sprite, "next_rect_animation", next_name )
end

function animate_sprite_simple( sprite, current_name, next_name )
	ComponentSetValue2( sprite, "rect_animation", current_name )
	ComponentSetValue2( sprite, "next_rect_animation", next_name )
end

function set_logic_state( state )
	local comp = EntityGetFirstComponent( GetUpdatedEntityID(), "LimbBossComponent" )
	if( comp ~= nil ) then
		ComponentSetValue2( comp, "state", state )
	end
end


function check_death()
	local comp = EntityGetFirstComponent( GetUpdatedEntityID(), "DamageModelComponent" )
	if( comp ~= nil ) then
		--ComponentSetValue2( comp, "hp", "-0.1" ) -- DEBUG: kill immediately
		local hp = ComponentGetValueFloat( comp, "hp" )
		if ( hp <= 0.0 ) then

			-- disable the attack limb
			local children = EntityGetAllChildren( GetUpdatedEntityID() )
			for i,child in ipairs( children ) do
				if EntityGetName( child ) == "limb_attacker" then
					EntityKill( child )
				end
			end

			-- run death sequence
			set_hitboxes_weak( false )
			set_details_hidden( true )
			set_logic_state( DontMove )
			set_main_animation( "death1", "death2" )
			
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )

			local rand = function() return Random( -10, 10 ) end

			for i = 1,40 do
				local x,y = EntityGetTransform( GetUpdatedEntityID() )
			    GameScreenshake( i * 1, x, y )
				GameCreateParticle( "slime_green",            x + rand(), y + rand(), 10, i * 5.5, i * 5.5, true, false )
				if i > 20 then
					GameCreateParticle( "gunpowder_unstable", x + rand(), y + rand(), 3,  40.0,    40.0,    true, false )
				end
				wait( 3 )
			end

			-- kill
			comp = EntityGetFirstComponent( GetUpdatedEntityID(), "DamageModelComponent" )
			if( comp ~= nil ) then
				ComponentSetValue2( comp, "kill_now", true )
			end
			
			StatsLogPlayerKill( GetUpdatedEntityID() )
			is_dead = true
			AddFlagPersistent( "miniboss_limbs" )

			return
		end
	end
end

function boss_wait( frames )
	check_death()
	wait( frames )
	check_death()
	did_wait = true
end


-- init --------------------------------------------

set_hitboxes_weak( false )
set_main_animation( get_idle_animation_name(), get_idle_animation_name() )
set_details_hidden( false )


-- run phase state machine -----------------

state = phase0

async_loop(function()

	-- alive
	if is_dead then
		wait(60 * 10)
	else
		did_wait = false
		state()
		if did_wait == false then -- ensure the coroutine doesn't get stuck in an infinite loop if the states never wait
		    wait(1)
		end
	end

end)
