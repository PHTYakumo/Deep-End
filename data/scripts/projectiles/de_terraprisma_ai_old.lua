dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, r, sx, sy = EntityGetTransform( entity_id )

-- coeff
local force, countdown = 0.35, 50 
local prey_dist, close_dist = 230, 12

local dmg_mult, wave_phase = 4, 15
local tx, ty = 0, 0

local rx, ry, prey_id, prey_frame, prey_dir, sword_id = 0, 0, -1, -1, false, 1
local rtcomp, ifcomp

local vcomps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local scomps = EntityGetComponent( entity_id, "SpriteComponent" )
local pcomp = EntityGetFirstComponent( entity_id, "SpriteParticleEmitterComponent" )

-- memories
for i,v in ipairs( vcomps ) do
	if ComponentGetValue2( v, "name" ) == "rotate_root" then
		rtcomp = v
		rx = ComponentGetValue2( v, "value_float" )
		ry = ComponentGetValue2( v, "value_int" )
		dmg_mult = tonumber( ComponentGetValue2( v, "value_string" ) )
	elseif ComponentGetValue2( v, "name" ) == "prey_info" then
		ifcomp = v
		prey_id = ComponentGetValue2( v, "value_float" )
		prey_frame = ComponentGetValue2( v, "value_int" )
		prey_dir = ComponentGetValue2( v, "value_bool" )
		sword_id = tonumber( ComponentGetValue2( v, "value_string" ) )
	end
end

-- argb
local sprite_color = { GameGetFrameNum() % 200, 0, 0, 0 }

for i=1,3 do
	sprite_color[i+1] = sprite_color[1]
	sprite_color[i+1] = math.cos( sprite_color[i+1] * math.pi * 0.005 + math.pi * i / 3 )
	sprite_color[i+1] = clamp( sprite_color[i+1]^2, 0, 0.75 ) * 1.333
end

sprite_color[1] = dmg_mult * 0.005 + 0.5 -- 0.516 ~ 0.78
sprite_color[5] = sprite_color[1] * 0.25 + 0.6 -- 0.729 ~ 0.795

ComponentSetValue2( pcomp, "color", sprite_color[2], sprite_color[3], sprite_color[4], sprite_color[5] )

for i=1,#scomps do ComponentSetValue2( scomps[i], "alpha", sprite_color[5] * sprite_color[i+1] * 0.75 ) end

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

	ComponentSetValue2( rtcomp, "value_string", "4" )
	-- GamePrint( "tp" )
	return
end

-- inflict dmg
if EntityHasTag( entity_id, "de_terraprisma_ai_disabled" ) then
	prey_id = -1
else
	local enemies = EntityGetInRadiusWithTag( x, y, 20, "enemy" )

	if #enemies > 0 then
		local dmg_amount = dmg_mult * 0.04 - 0.16 -- 0.32 ~ 1.92

		for i=1,#enemies do
			EntityInflictDamage( enemies[i], dmg_amount, "DAMAGE_HOLY", "$TR_PRISMA", "NONE", 0, 0, enemies[i] )
			EntityInflictDamage( enemies[i], 0.16, "DAMAGE_PHYSICS_BODY_DAMAGED", "$TR_PRISMA", "NONE", 0, 0, enemies[i] )
		end

		GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/laser_wraith/create", px, py )
	end

	-- whether ongoing
	if not ( prey_id > 0 and GameGetFrameNum() - prey_frame < countdown
		and EntityGetIsAlive( prey_id ) and EntityHasTag( prey_id, "enemy" ) )
	then
		tx = px * ( 1 - force * 0.5 ) + cx * force * 0.5
		ty = py * ( 1 - force * 0.5 ) + cy * force * 0.5

		prey_id = EntityGetClosestWithTag( tx, ty, "enemy" )
		tx, ty = EntityGetTransform( prey_id )
		
		if tx ~= nil then
			local vel_dir = get_direction( tx, ty, x, y ) + math.pi * ( 0.4 + Random( -10, 10 ) * 0.01 )
			local root_dist = 80 + Random( -10, 10 )

			rx = tx + math.cos( vel_dir ) * root_dist
			ry = ty - math.sin( vel_dir ) * root_dist

			ComponentSetValue2( rtcomp, "value_float", rx )
			ComponentSetValue2( rtcomp, "value_int", math.floor( ry ) )

			ComponentSetValue2( ifcomp, "value_float", prey_id )
			ComponentSetValue2( ifcomp, "value_int", GameGetFrameNum() )
			ComponentSetValue2( ifcomp, "value_bool", not prey_dir )
			-- GamePrint( "new" )
		end
	end
end

-- prey_pos
tx, ty = 0, 0
if prey_id ~= nil and prey_id > 0 then tx, ty = EntityGetFirstHitboxCenter( prey_id ) end

-- too far from the player or the prey, stay behind you
if tx == 0 or get_distance( tx, ty, x, y ) > prey_dist or get_distance( tx, ty, px, py ) > prey_dist then
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

	ComponentSetValue2( rtcomp, "value_string", tostring( math.max( dmg_mult - 0.8, 3.2  ) ) )
	ComponentSetValue2( ifcomp, "value_float", -1 )
	ComponentSetValue2( ifcomp, "value_int", -1 )
	-- GamePrint( "follow" )
	return
end

-- wave towards the target
if prey_dir then wave_phase = -wave_phase end

-- next angle & dist
dist = get_distance( x, y, rx, ry )
dist = dist * ( 1 - force ) + get_distance( tx, ty, rx, ry ) * force

wave_phase = wave_phase / math.max( dist, 1 )
local angle = get_direction( x, y, rx, ry ) + wave_phase

vx = math.cos( angle )
vy = -math.sin( angle )

-- close to the prey
if get_distance( tx, ty, x, y ) < close_dist then
	ComponentSetValue2( rtcomp, "value_string", tostring( math.min( dmg_mult + 0.8, 56  ) ) )
	ComponentSetValue2( ifcomp, "value_int", math.min( GameGetFrameNum() - countdown + close_dist, prey_frame ) )
	-- GamePrint( "dmg: " .. tostring(dmg_mult) )
end

x = rx + vx * dist
y = ry + vy * dist

r = -math.atan2( vx, vy )
ComponentSetValueVector2( vcomp, "mVelocity", vx, vy )

EntitySetTransform( entity_id, x, y, r, sx, sy )
EntityApplyTransform( entity_id, x, y, r, sx, sy )
-- GamePrint( "prey: " .. tostring(prey_id) )