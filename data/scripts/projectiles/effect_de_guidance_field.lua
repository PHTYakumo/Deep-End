dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if pcomp == nil then return end

local shooter = ComponentGetValue2( pcomp, "mWhoShot" )
if shooter == nil or shooter == NULL_ENTITY then return end

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
local orbs = EntityGetInRadiusWithTag( x, y, 30, "projectile_converted" )

if #orbs > 0 then for i=1,#orbs do local id = orbs[i]
	if not EntityHasTag( id, "ultra" ) and not EntityHasTag( id, "de_guidance_field" ) then
		local px, py = EntityGetTransform( id )

		local velcomp = EntityGetFirstComponent( id, "VelocityComponent" )
		local varcomp = EntityGetFirstComponent( id, "VariableStorageComponent", "guide_angle" )

		if velcomp ~= nil and varcomp ~= nil then
			local angle = ComponentGetValue2( varcomp, "value_float" )
			local iangle = tonumber( ComponentGetValue2( varcomp, "value_string" ) )

			if angle - iangle > 3.14 then
				EntityAddComponent( id, "HomingComponent", 
				{
					detect_distance="34",
					homing_targeting_coeff="480",
					homing_velocity_multiplier="0.83",
				} )

				ComponentSetValue2( velcomp, "mVelocity", math.cos(angle) * 875, math.sin(angle) * 875 )
			else
				local dist = math.min( ( (x-px)^2 + (y-py)^2 )^0.5, 27 )
				if dist < 27 then dist = dist + 0.5 end

				EntitySetTransform( id, x - math.cos(angle) * dist, y - math.sin(angle) * dist )
				EntityApplyTransform( id, x - math.cos(angle) * dist, y - math.sin(angle) * dist )

				ComponentSetValue2( velcomp, "mVelocity", math.sin(angle) * 25, math.cos(angle) * 25 )
				ComponentSetValue2( varcomp, "value_float", angle + 0.05236 )
			end
		end
	end
end end

if executed_times % 3 ~= 1 then return end
local projs = EntityGetInRadiusWithTag( x, y, 28, "projectile" )

if #projs > 0 then for i=1,#projs do local id = projs[i]
	if not EntityHasTag( id, "projectile_converted" ) and not EntityHasTag( id, "de_guidance_field" ) then
		local px, py = EntityGetTransform( id )
		local angle = math.atan2( y-py, x-px )

		local velcomp = EntityGetFirstComponent( id, "VelocityComponent" )
		local projcomp = EntityGetFirstComponent( id, "ProjectileComponent" )

		if velcomp ~= nil and projcomp ~= nil then
			ComponentSetValue2( velcomp, "mVelocity", math.sin(angle) * 25, math.cos(angle) * 25 )

			ComponentSetValue2( projcomp, "lifetime", ComponentGetValue2( projcomp, "lifetime" ) + 45 )
			ComponentSetValue2( projcomp, "collide_with_world", false )
			ComponentSetValue2( projcomp, "mWhoShot", shooter )
			ComponentSetValue2( projcomp, "mShooterHerdId", get_herd_id(shooter) )
			
			if EntityHasTag( shooter, "player_unit" ) then ComponentSetValue2( projcomp, "dont_collide_with_tag", "player_unit" ) end
		end

		EntityAddTag( id, "projectile_converted" )
		EntitySetTransform( id, x - math.cos(angle) * 20, y - math.sin(angle) * 20 )
		EntityApplyTransform( id, x - math.cos(angle) * 20, y - math.sin(angle) * 20 )

		EntityAddComponent( id, "VariableStorageComponent", 
		{
			_tags="guide_angle",
			name="guide_angle",
			value_float=tostring(angle),
			value_string=tostring(angle),
		} )
	end
end end

-- local buff = EntityLoad( "data/entities/misc/--.xml", px, py )
-- EntityAddChild( id, buff )