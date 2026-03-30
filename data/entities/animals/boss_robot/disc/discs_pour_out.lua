dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x + GameGetFrameNum(), y + entity_id )

for i=1,Random(1,3) do
    local angle = Random(1,100) * 0.02 * math.pi
    local vel = Random(1,100) * 4 + 600
    shoot_projectile( entity_id, "data/entities/animals/boss_robot/disc/disc_pour_out.xml", x, y, math.cos(angle) * vel, math.sin(angle) * vel )
end

--[[

local projectiles = EntityGetInRadiusWithTag( x, y, 200, "projectile" )

if #projectiles > 0 then
	for i,projectile_id in ipairs( projectiles ) do
		if not EntityHasTag( projectile_id, "disc_bullet_big" ) then
			local px, py = EntityGetTransform( projectile_id )
			local vx, vy = 0,0
			
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
			
			if projectilecomponents ~= nil then for j,comp_id in ipairs( projectilecomponents ) do
				ComponentSetValue2( comp_id, "on_death_explode", false )
				ComponentSetValue2( comp_id, "on_lifetime_out_explode", false )
            end end
			
			if velocitycomponents ~= nil  then
				edit_component( projectile_id, "VelocityComponent", function(comp,vars)
					vx,vy = ComponentGetValueVector2( comp, "mVelocity", vx, vy)
				end)
			end

            shoot_projectile_from_projectile( projectile_id, "data/entities/animals/boss_robot/disc/disc_pour_out.xml", px, py, vx * 3, vy * 3 )
			EntityKill( projectile_id )
		end
	end
end

]]--
