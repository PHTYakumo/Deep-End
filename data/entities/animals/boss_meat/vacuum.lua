dofile_once("data/scripts/lib/utilities.lua")

local distance_full = 256

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )

function calculate_force_at(body_x, body_y)
	local distance = math.sqrt( ( x - body_x ) ^ 2 + ( y - body_y ) ^ 2 )
	local direction = 0 - math.atan2( ( y - body_y ), ( x - body_x ) )

	local gravity_percent = ( distance_full - distance ) / distance_full
	local gravity_coeff = 130
	if ModSettingGet( "DEEP_END.MEAT_HEAL" ) then gravity_coeff = 610 end
	
	local fx = -math.cos( direction ) * ( gravity_coeff * gravity_percent )
	local fy = math.sin( direction ) * ( gravity_coeff * gravity_percent )

    return fx,fy
end

-- attract projectiles
local entities = EntityGetInRadiusWithTag( x, y, distance_full, "projectile" )

for _,id in ipairs(entities) do	
	local physicscomp = EntityGetFirstComponent(id, "PhysicsBody2Component" ) or EntityGetFirstComponent( id, "PhysicsBodyComponent" )

	if physicscomp == nil then
		local px, py = EntityGetTransform( id )
		local velocitycomp = EntityGetFirstComponent( id, "VelocityComponent" )

		if ( velocitycomp ~= nil ) then
			local fx, fy = calculate_force_at(px, py)

			edit_component( id, "VelocityComponent", function(comp,vars)
				local vel_x,vel_y = ComponentGetValue2( comp, "mVelocity" )
				
				vel_x = vel_x + fx
				vel_y = vel_y + fy

				ComponentSetValue2( comp, "mVelocity", vel_x, vel_y )
			end)
		end
	end
end

-- force field for physics bodies
function calculate_force_for_body( entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular )
	local fx, fy = calculate_force_at(body_x, body_y)
	SetRandomSeed( GameGetFrameNum(), entity )

	local angular = math.sqrt( fx^2 + fy^2 )
	local angle = Random(-100,100) * math.pi * 0.01

	fx = angular * math.cos(angle) * 0.2 * body_mass
	fy = angular * math.sin(angle) * 0.2 * body_mass

	return body_x,body_y,fx,fy,angle -- forcePosX,forcePosY,forceX,forceY,forceAngular
end

local size = distance_full * 0.5
PhysicsApplyForceOnArea( calculate_force_for_body, entity_id, x-size, y-size, x+size, y+size )

if ModSettingGet( "DEEP_END.MEAT_HEAL" ) and ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" ) % 6 == 1 then
	shoot_projectile( entity_id, "data/entities/animals/boss_meat/acidshot_slow.xml", x, y, 0, 0 )
end


