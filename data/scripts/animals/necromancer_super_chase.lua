dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

if EntityHasTag( entity_id, "de_peace_with_god" ) and not EntityHasTag( entity_id, "boss" ) then return end

local fish = EntityGetInRadiusWithTag( x, y, 60, "super_fish" )

if #fish ~= 0 then for i=1,#fish do EntityKill( fish[i] ) end end

local target = EntityGetClosestWithTag( x, y, "player_unit" )

local function set_fly_speed(spd)
	if spd >= 0 then
		component_write( EntityGetFirstComponent( entity_id, "CharacterPlatformingComponent" ), { fly_speed_mult = spd, fly_velocity_x = spd*2 } )
	else
		component_write( EntityGetFirstComponent( entity_id, "CharacterPlatformingComponent" ), { fly_speed_mult = 0, fly_velocity_x = 40 } )
	end
end

if not target or target == 0 then
	if EntityHasTag( entity_id, "boss" ) then
		set_fly_speed(-1)
	else
		set_fly_speed(40)
	end

	return
end

local vx, vy = EntityGetTransform( target )
vx, vy = vec_sub( vx, vy, x, y )
local dist = get_magnitude( vx, vy )

if dist < 64 or dist > 2048 then
	if EntityHasTag( entity_id, "boss" ) then
		set_fly_speed(-1)
	else
		set_fly_speed(40)
	end
	
	return
end

-- move directly towards player
set_fly_speed(0)

local speed = dist * 0.002
speed = clamp( speed, 0.5, 1.25 )

if EntityGetFirstComponent( entity_id, "PhysicsBodyComponent" ) ~= nil then speed = speed * 4 end

vx, vy = vec_normalize( vx, vy )
vx, vy = vec_mult( vx, vy, speed )

x, y = vec_add( x, y, vx, vy )
EntitySetTransform( entity_id, x, y )
EntityApplyTransform( entity_id, x, y )

