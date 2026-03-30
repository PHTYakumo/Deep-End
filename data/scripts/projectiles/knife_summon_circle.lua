dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pid = EntityGetClosestWithTag( x, y, "player_unit")
if ( pid ~= nil ) then
	local px, py = EntityGetTransform( pid )

	local angle = 0
	local acomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "angle" )
	if ( acomp ~= nil ) then
		angle = ComponentGetValue2( acomp, "value_int" ) + 23

		for i=1,2 do
			local sx = 0
			local sy = 36 * (-1)^i
			
			sx,sy = vec_rotate( sx, sy, math.rad(angle) )

			local which = math.fmod( angle, 46 )

			if ( which < 23 ) then
				shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife_freeze_time.xml", x, y, sx, sy )
			else
				shoot_projectile( pid, "data/entities/projectiles/deck/summon_knife.xml", x, y, 14*sx, 14*sy )
			end
		end

		ComponentSetValue2( acomp, "value_int", angle )
	end
end