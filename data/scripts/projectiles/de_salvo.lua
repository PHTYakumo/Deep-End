dofile_once("data/scripts/lib/utilities.lua")

local entity_id, offset, proj_file = GetUpdatedEntityID(), 1, ""
local x, y, r, sx, sy = EntityGetTransform( entity_id )

if entity_id ~= nil and r ~= nil then
	local cid = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent", "de_salvo" )

	if cid == nil then
		local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

		if comps ~= nil then for i,comp in ipairs( comps ) do if ComponentGetValue2( comp, "name" ) == "projectile_file" then
			proj_file = ComponentGetValue2( comp, "value_string" ) or ""
			break
		end end end

		EntityAddComponent( entity_id, "VariableStorageComponent", 
		{
			_tags="de_salvo",
			name = "de_salvo",
			value_int = "1",
			value_string = proj_file,
		} )
	else
		proj_file = ComponentGetValue2( cid, "value_string" )
		offset = ComponentGetValue2( cid, "value_int" ) + 1

		ComponentSetValue2( cid, "value_int", offset )
	end

	if #proj_file < 4 then return end

	offset = ( offset % 11 ) * 4
	local vx, vy = GameGetVelocityCompVelocity( entity_id )

	local vel = math.max( ( vx^2 + vy^2 )^0.5, 0.04 )
	local dx, dy = vy * offset / vel, vx * offset / vel

	local pid = shoot_projectile_from_projectile( entity_id, proj_file, x, y, vx, vy )

	EntitySetTransform( pid, x + dx, y - dy, r, sx, sy )
	EntityApplyTransform( pid, x + dx, y - dy, r, sx, sy )

	pid = shoot_projectile_from_projectile( entity_id, proj_file, x, y, vx, vy )

	EntitySetTransform( pid, x - dx, y + dy, r, sx, sy )
	EntityApplyTransform( pid, x - dx, y + dy, r, sx, sy )
end