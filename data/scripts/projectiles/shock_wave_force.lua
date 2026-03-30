dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local distance_full = 69

function calculate_force_at( body_x, body_y, coeff )
	local distance = get_magnitude( y - body_y, x - body_x )
	local direction = -math.atan2( y - body_y, x - body_x )

	local gravity_percent = ( distance_full - distance ) / distance_full
	gravity_percent = coeff * gravity_percent
	
	local fx = math.cos( direction ) * gravity_percent
	local fy = -math.sin( direction ) * gravity_percent

    return fx,fy
end

-- attract projectiles
local entities = EntityGetInRadiusWithTag(x, y, distance_full, "projectile" )

for _,id in ipairs(entities) do	
	local physicscomp = EntityGetFirstComponent( id, "PhysicsBody2Component" ) or EntityGetFirstComponent( id, "PhysicsBodyComponent" )
	
	if physicscomp == nil and not EntityHasTag( id, "black_hole" ) and not EntityHasTag( id, "hittable" ) then
		local px, py = EntityGetTransform( id )
		local velocitycomp = EntityGetFirstComponent( id, "VelocityComponent" )

		if velocitycomp ~= nil then
			local fx, fy = calculate_force_at( px, py, -50 )
			local vel_x, vel_y = ComponentGetValue2( velocitycomp, "mVelocity")
				
			vel_x, vel_y = vel_x + fx, vel_y + fy
			ComponentSetValue2( velocitycomp, "mVelocity", vel_x, vel_y )
		end
	end
end

-- attract hittable entities
entities = EntityGetInRadiusWithTag(x, y, distance_full, "hittable" )

for _,id in ipairs(entities) do	
	local physicscomp = EntityGetFirstComponent( id, "PhysicsBody2Component" ) or EntityGetFirstComponent( id, "PhysicsBodyComponent" )
	local px, py = EntityGetTransform( id )

	if physicscomp == nil and not EntityHasTag( id, "black_hole" ) then
		local velcomp = EntityGetFirstComponent( id, "VelocityComponent" )
		local characomp = EntityGetFirstComponent( id, "CharacterDataComponent" )

		if velcomp ~= nil and characomp ~= nil then
			local fx, fy = calculate_force_at( px, py, -125 )
			local vel_x, vel_y = ComponentGetValue2( velcomp, "mVelocity")
				
			vel_x, vel_y = vel_x + fx, vel_y + fy
			ComponentSetValue2( velcomp, "mVelocity", vel_x, vel_y )

			vel_x, vel_y = ComponentGetValue2( characomp, "mVelocity")
				
			vel_x, vel_y = vel_x + fx, vel_y + fy
			ComponentSetValue2( characomp, "mVelocity", vel_x, vel_y )
		end
	end
end


-- force field for physics bodies
function calculate_force_for_body( entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular )
	local fx, fy = calculate_force_at( body_x, body_y, -200 )

	fx = fx * 0.2 * body_mass
	fy = fy * 0.2 * body_mass

    return body_x, body_y, fx, fy, 0 -- forcePosX, forcePosY, forceX, forceY, forceAngular
end

local size = distance_full * 0.5
PhysicsApplyForceOnArea( calculate_force_for_body, entity_id, x-size, y-size, x+size, y+size )

