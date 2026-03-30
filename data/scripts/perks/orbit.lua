dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local orbit_comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "perk_orbit_pickup_count" )
local orbit_pickup_count = 1
				
if ( orbit_comp ~= nil ) then
	orbit_pickup_count = ComponentGetValue2( orbit_comp, "value_int" )
end

-- GamePrint(tostring(orbit_pickup_count))

local orbit_radius = 10 + 3 * orbit_pickup_count
local projectiles = EntityGetInRadiusWithTag( x, y, orbit_radius, "projectile" )

for i,projectile_id in ipairs(projectiles) do	
	local px, py = EntityGetTransform( projectile_id )
	local vel_x, vel_y = 0,0
	local who_shot = 0
	
	edit_component( projectile_id, "VelocityComponent", function(comp,vars)
		vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
		
		--ComponentSetValueVector2( comp, "mVelocity", 0, 0 )
	end)
	
	edit_component( projectile_id, "ProjectileComponent", function(comp,vars)
		who_shot = ComponentGetValue2( comp, "mWhoShot" ) 
	end)
	
	-- print( tostring( who_shot ) .. ", " .. tostring( entity_id ) )
	
	if ( who_shot ~= entity_id ) then
		local spd = math.sqrt( vel_y ^ 2 + vel_x ^ 2 )
		
		if ( spd < 1000 ) then
			SetRandomSeed( px + y + GameGetFrameNum(), py + x + GameGetFrameNum() )
			local luck = Random( 1, orbit_radius )
			
			if ( luck > 9 ) then
				local dir = 0 - math.atan2( vel_y, vel_x )
				local dir2 = 0 - math.atan2( py - y, px - x )
				
				local mirror = dir + math.pi * 0.5
				local final = mirror + ( mirror - dir2 )
				
				px = x + math.cos( final ) * ( orbit_radius + 1 ) * 2
				py = y - math.sin( final ) * ( orbit_radius + 1 ) * 2
				
				EntitySetTransform( projectile_id, px, py )
			end
		end
	end
end