dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local orbs = { "orb_weaken", "orb_poly", "orb_hearty" }
local angle_inc = math.rad( 360 / #orbs )
local theta = math.rad(6)
local length = 6

for i=1,#orbs do
	local new_x = pos_x + math.cos( theta ) * length
	local new_y = pos_y + math.sin( theta ) * length

	local eid = shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_spirit/orb_rnd/" .. orbs[i] .. ".xml", new_x, new_y, 0, 0 )

	local comp = EntityGetFirstComponent( eid, "VariableStorageComponent", "theta" )
	if ( comp ~= nil ) then
		ComponentSetValue2( comp, "value_float", theta )
	end
	
	EntityAddChild( entity_id, eid )

	theta = theta + angle_inc
end