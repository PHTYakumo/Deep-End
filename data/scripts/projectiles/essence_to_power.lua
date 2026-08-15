dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )

local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if comp == nil then return end

local who_shot = ComponentGetValue2( comp, "mWhoShot" )
local count = 0.4

local x, y = EntityGetTransform( entity_id )
local radius = 160

local projectiles = EntityGetInRadiusWithTag( x, y, radius, "homing_target" )
local projectiles2 = EntityGetInRadiusWithTag( x, y, radius, "summon_player" )

if #projectiles2 > 0 then for i,v in ipairs( projectiles2 ) do
	table.insert( projectiles, v )
end end

if who_shot ~= nil and comp ~= nil then
	for i,pid in ipairs(projectiles) do
		if pid ~= root_id and pid ~= entity_id and pid ~= who_shot and EntityHasTag( pid, "essence_to_power_target" ) == false then
			local comp2 = EntityGetFirstComponent( pid, "DamageModelComponent" )
			
			if comp2 ~= nil then
				local amount = ComponentGetValue2( comp2, "max_hp" ) or 0.4
				count = count + math.max( 0.4, amount )
				
				EntityAddTag( pid, "essence_to_power_target" )
				EntityAddChild( pid, EntityLoad( "data/entities/misc/essence_to_power_cooldown.xml", x, y ) )
			end
		end
	end
	
	local damage = ComponentGetValue2( comp, "damage" )
	local expdamage = ComponentObjectGetValue2( comp, "config_explosion", "damage" )
	
	damage = damage + math.min( 400, count * 0.1 )
	expdamage = expdamage + math.min( 400, count * 0.1 )
	
	-- print("FINAL: " .. tostring(count))
	
	ComponentSetValue2( comp, "damage", damage )
	ComponentObjectSetValue2( comp, "config_explosion", "damage", expdamage )
	
	local effect_id = EntityLoad("data/entities/particles/tinyspark_blue_large.xml", x, y)
	EntityAddChild( root_id, effect_id )
	
	edit_component( effect_id, "ParticleEmitterComponent", function(comp3,vars)
		local part_min = math.min( math.floor( count * 0.5 ), 100 )
		local part_max = math.min( count + 1, 120 )
		
		ComponentSetValue2( comp3, "count_min", part_min )
		ComponentSetValue2( comp3, "count_max", part_max )
	end)
end