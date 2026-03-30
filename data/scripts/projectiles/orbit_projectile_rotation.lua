dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projspeed = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "orbit_projectile_speed" )
local orbits = EntityGetAllChildren( entity_id )

if ( projspeed ~= nil ) and ( orbits ~= nil ) then
	local speed = ComponentGetValue2( projspeed, "value_float" ) * 1.2
	local dist = 20
	local id = 0
	
	for i,v in ipairs( orbits ) do
		if EntityHasTag( v, "orbit_projectile" ) then
			if EntityHasTag( v, "orbit_laser" ) or EntityHasTag( v, "disc_bullet_big" ) then dist = 6 end
			if EntityHasTag( v, "thunder" ) or EntityHasTag( v, "black_hole" ) then dist = 28 end

			local rid = math.floor( id * 0.25 )
			local angle = math.pi * 0.5 * id + GameGetFrameNum() * speed + math.pi * 0.22 * rid
			local rot = - math.pi * 0.5 - angle
			
			local px = math.cos( angle ) * math.min( dist + rid, 60 )
			local py = math.sin( angle ) * math.min( dist + rid, 60 )
			
			EntitySetTransform( v, x + px, y - py, rot )
			EntityApplyTransform( v, x + px, y - py, rot )

			local velcomp = EntityGetFirstComponent( v, "VelocityComponent" )
			if velcomp ~= nil then ComponentSetValueVector2( velcomp, "mVelocity", py, px ) end
			
			id = id + 1
		end
	end
end