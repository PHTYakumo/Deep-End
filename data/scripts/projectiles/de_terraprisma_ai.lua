dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, r, sx, sy = EntityGetTransform( entity_id )

-- coeff
local force, countdown = 0.35, 30 
local prey_dist, close_dist = 190, 12

local sword_id, rtcomp, ifcomp
local pattern, prey_dir = false, false

local atk_rnd, dir_rnd = 40, 45
local prey_id, prey_frame = -1, -1

local dmg_mult, wave_phase, angle = 4, 9, 0
local rx, ry, tx, ty = 0, 0, 0, 0

local vcomps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local scomps = EntityGetComponent( entity_id, "SpriteComponent" )
local pcomp = EntityGetFirstComponent( entity_id, "SpriteParticleEmitterComponent" )

-- memories
for i,v in ipairs( vcomps ) do
	if ComponentGetValue2( v, "name" ) == "rotate_root" then
		rtcomp = v

		rx = ComponentGetValue2( v, "value_float" )
		ry = ComponentGetValue2( v, "value_int" )
		pattern = ComponentGetValue2( v, "value_bool" )
		dmg_mult = tonumber( ComponentGetValue2( v, "value_string" ) )
		-- GamePrint( "dmg: " .. tostring(dmg_mult) )
	elseif ComponentGetValue2( v, "name" ) == "prey_info" then
		ifcomp = v

		prey_id = ComponentGetValue2( v, "value_float" )
		prey_frame = ComponentGetValue2( v, "value_int" )
		prey_dir = ComponentGetValue2( v, "value_bool" )
		sword_id = tonumber( ComponentGetValue2( v, "value_string" ) )
	end
end

-- argb
local sprite_color = { GameGetFrameNum() % 333, 0, 0, 0 }

for i=2,4 do																-- periodically: max, max, decrease, min, min, increase
	sprite_color[i] = sprite_color[1] * math.pi * 0.003						-- 1.0	|	____      
	sprite_color[i] = math.cos( sprite_color[i] + math.pi * i / 3 )			-- 0.5  |	    \      /
	sprite_color[i] = clamp( sprite_color[i]^2, 0.333, 0.666 ) * 3 - 0.999	-- 0.0	|	     \____/
end

ComponentSetValue2( pcomp, "color", sprite_color[2], sprite_color[3], sprite_color[4], 0.75 )
for i=1,#scomps do ComponentSetValue2( scomps[i], "alpha", sprite_color[i+1] * 0.75 ) end

-- vel
local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )

-- pl pos
local pl = get_players()[1]
local px, py = EntityGetTransform( pl )

-- cursor pos
local cx,cy = ComponentGetValueVector2( EntityGetFirstComponent( pl, "ControlsComponent" ), "mMousePosition" )
if px == nil or cx == nil then px, py, cx, cy = 0, 0, 0, 0 end

SetRandomSeed( GameGetFrameNum() - entity_id, GameGetFrameNum() - sword_id )
py = py - 4 -- centring

local dx, dy = x - px, y - py
local dist = math.max( get_magnitude( dx, dy ), 1 )

-- GamePrint( "dist: " .. tostring(dist) )
-- too far from the player, tp to your side
if dist > 750 then
	dx = dx / dist
	dy = dy / dist

	x = px + dx * 100
	y = py + dy * 100

	r = -math.atan2( dx, dy )
	ComponentSetValueVector2( vcomp, "mVelocity", dx, dy )

	EntitySetTransform( entity_id, x, y, r, sx, sy )
	EntityApplyTransform( entity_id, x, y, r, sx, sy )

	dmg_mult = math.floor( dmg_mult * 15 + 60 )
	ComponentSetValue2( rtcomp, "value_string", tostring( dmg_mult * 0.04 ) ) -- 6
	-- GamePrint( "tp" )
	return
end

-- inflict dmg
if EntityHasTag( entity_id, "de_terraprisma_ai_disabled" ) then
	prey_id = -1
else
	local enemies = EntityGetInRadiusWithTag( x, y, 20, "enemy" )

	if #enemies > 0 then
		local dmg_amount = math.max( dmg_mult, 6 ) * 0.01 - 0.06 + sword_id * 0.1 -- 0.1 ~ 0.6
		local dmg_amount_2 = Random( -10, 10 )^2 * 0.004 -- 0.0 ~ 0.4
		
		for i=1,#enemies do
			if EntityHasTag( enemies[i], "de_ghosty_enemy" ) and Random( -10, 10 ) == 0 then
				EntityKill( enemies[i] )
			elseif EntityHasTag( enemies[i], "boss" ) then
				EntityInflictDamage( enemies[i], dmg_amount + dmg_amount_2, "DAMAGE_HOLY", "$TR_PRISMA", "NONE", 0, 0, enemies[i] )
			else
				EntityInflictDamage( enemies[i], dmg_amount, "DAMAGE_HOLY", "$TR_PRISMA", "NONE", 0, 0, enemies[i] )
				EntityInflictDamage( enemies[i], dmg_amount_2, "DAMAGE_PHYSICS_BODY_DAMAGED", "$TR_PRISMA", "NONE", 0, 0, enemies[i] )
			end
		end

		GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/laser_wraith/create", px, py )
	end

	-- whether ongoing
	if prey_id < 1 or GameGetFrameNum() - prey_frame >= countdown or
	not ( EntityGetIsAlive( prey_id ) and EntityHasTag( prey_id, "enemy" ) )
	then
		atk_rnd = ( atk_rnd - 50 ) * 0.2 -- probability
		dir_rnd = ( dir_rnd - 50 ) * 0.2

		tx = px * 0.9 + cx * 0.1
		ty = py * 0.9 + cy * 0.1

		local new_id = EntityGetClosestWithTag( tx, ty, "enemy" )
		tx, ty = EntityGetTransform( new_id )
		
		if tx ~= nil then
			local vel_dir = Random( -10, 10 )
			local root_dist = close_dist * 4 + Random( -10, 10 ) * 1.5

			if prey_id ~= new_id then
				prey_dir = not prey_dir
				vel_dir = get_direction( x, y, tx, ty ) + vel_dir * force * 0.01
				-- GamePrint( "new" )
			elseif pattern then
				local pl_dir = get_direction( px, py, tx, ty )
				local tar_dir = get_direction( rx, ry, tx, ty )

				angle = math.abs( pl_dir - tar_dir )
				vel_dir = sign( vel_dir ) * 15
				
				if angle > 0.7 and angle < ( math.pi * 2 - 0.7 ) then -- deflect the angle until it approaches the player
					if prey_dir then vel_dir = math.pi * 10
					else vel_dir = -math.pi * 10 end
				elseif Random( -10, 10 ) < dir_rnd then -- reverse the direction of rotation
					vel_dir = vel_dir * 0.5
					prey_dir = not prey_dir
				end

				vel_dir = vel_dir + Random( -10, 10 )
				vel_dir = tar_dir + vel_dir * force * 0.01
				-- GamePrint( "go on" )
			else
				vel_dir = get_direction( x, y, tx, ty ) + sign( vel_dir ) * 0.05
			end

			-- attack pattern: ellipse or stab
			if pattern and Random( -10, 10 ) < atk_rnd then pattern = false
			else pattern = true end

			rx = tx + math.cos( vel_dir ) * root_dist
			ry = ty - math.sin( vel_dir ) * root_dist
			
			ComponentSetValue2( rtcomp, "value_bool", pattern )
			ComponentSetValue2( rtcomp, "value_float", rx )
			ComponentSetValue2( rtcomp, "value_int", math.floor( ry ) )
			
			ComponentSetValue2( ifcomp, "value_float", new_id )
			ComponentSetValue2( ifcomp, "value_int", GameGetFrameNum() )
			ComponentSetValue2( ifcomp, "value_bool", prey_dir )

			prey_id = new_id
		else
			prey_id = -1
		end
	end
end

-- prey_pos
tx, ty = 0, 0
if prey_id ~= nil and prey_id > 0 then tx, ty = EntityGetFirstHitboxCenter( prey_id ) end

-- too far from the player or the prey, stay behind you
if tx == 0 or tx == nil or get_distance( tx, ty, x, y ) > prey_dist or get_distance( tx, ty, px, py ) > prey_dist then
	local breath_phase = GameGetFrameNum() - sword_id * math.pi * 9.52

	local bx = px - sign( cx - px ) * ( 11 + sword_id ) + math.cos( breath_phase * 0.03 ) * 0.8
	local by = py + math.sin( breath_phase * 0.03 ) * 0.8

	bx = x * ( 1 - force ) + bx * force
	by = y * ( 1 - force ) + by * force

	local mx = sign( px - cx ) * ( 0.4 + math.cos( breath_phase * 0.024 ) * 0.06 )
	local my = 1

	mx = vx * ( 1 - force ) + mx * force
	my = vy * ( 1 - force ) + my * force

	r = -math.atan2( mx, my )
	ComponentSetValueVector2( vcomp, "mVelocity", mx, my )

	EntitySetTransform( entity_id, bx, by, r, sx, sy )
	EntityApplyTransform( entity_id, bx, by, r, sx, sy )

	ComponentSetValue2( rtcomp, "value_string", tostring( math.max( dmg_mult - 0.4, 3.2  ) ) )
	ComponentSetValue2( ifcomp, "value_float", -1 )
	ComponentSetValue2( ifcomp, "value_int", -1 )
	-- GamePrint( "follow" )
	return
end

-- next angle & dist
if pattern then -- ellipse
	local scale = math.abs( get_direction( x, y, rx, ry ) - get_direction( tx, ty, rx, ry ) ) / math.pi

	scale = 1 - math.min( 2 - scale, scale ) -- angle size, 1 represents opposite
	scale = math.abs( scale - 0.5 )^2 * 2 + 0.5 -- 1 represents opposite or overlap

	dist = get_distance( tx, ty, rx, ry ) * scale
	dist = get_distance( x, y, rx, ry ) * ( 1 -  scale ) + dist * scale

	-- wave towards the target
	if prey_dir then wave_phase = -wave_phase end
	wave_phase = wave_phase / math.max( dist, 1 )

	angle = get_direction( x, y, rx, ry ) + wave_phase
else -- stab
	local pl_dir = -math.atan2( vy, vx )
	local tar_dir = get_direction( tx, ty, rx, ry )

	angle = math.abs( pl_dir - tar_dir )
	dist = get_distance( x, y, rx, ry ) * force
	
	if angle > 0.6 and angle < ( math.pi * 2 - 0.6 ) then -- deflect the angle until it approaches the prey
		if prey_dir then angle = pl_dir + 0.5
		else angle = pl_dir - 0.5 end
	else
		angle = tar_dir
		dist = get_distance( x, y, rx, ry ) * 1.01 + wave_phase
	end
end

vx = math.cos( angle )
vy = -math.sin( angle )

x = rx + vx * dist
y = ry + vy * dist

r = -math.atan2( vx, vy )
ComponentSetValueVector2( vcomp, "mVelocity", vx, vy )

EntitySetTransform( entity_id, x, y, r, sx, sy )
EntityApplyTransform( entity_id, x, y, r, sx, sy )

-- GamePrint( "prey: " .. tostring(prey_id) )
-- close to the prey
if get_distance( tx, ty, x, y ) < close_dist then
	ComponentSetValue2( rtcomp, "value_string", tostring( math.min( dmg_mult + 0.4, 56  ) ) )
	ComponentSetValue2( ifcomp, "value_int", math.min( GameGetFrameNum() - countdown + close_dist, prey_frame ) )
end