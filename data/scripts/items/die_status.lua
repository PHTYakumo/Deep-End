dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

function bullet_circle( which, count, speed )
	local how_many = count or 4
	local angle_inc = ( 2 * 3.14159 ) / how_many

	local theta = rot + Random( 1, 90 ) * 0.011111 * math.pi
	local length = speed or 200

	local name = which or "buckshot"

	for i=1,how_many do
		local vel_x = math.cos( theta ) * length
		local vel_y = 0 - math.sin( theta ) * length

		shoot_projectile( entity_id, "data/entities/projectiles/" .. name .. ".xml", pos_x + math.cos( theta ) * 12, pos_y - math.sin( theta ) * 12, vel_x, vel_y )
		theta = theta + angle_inc
	end
end

local status, rstorage = 0, 0
local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )

if variablestorages ~= nil then
	for j,storage_id in ipairs(variablestorages) do if ComponentGetValue2( storage_id, "name" ) == "rolling" then
		status = ComponentGetValue2( storage_id, "value_int" )
		rstorage = storage_id
	end end
	
	if status > 0 then
		status = status + 1
		
		if status >= 20 then
			local players = EntityGetInRadiusWithTag( pos_x, pos_y, 200, "player_unit" )
			if #players <= 0 then return end

			local result, special = Random( 1, 6 ), Random( 1, 1000 )
			status = 0
			
			local textprint = "$item_die_"
			local anim = "default"
			
			if special ~= 666 then
				GamePrint( textprint .. tostring( result ) )
				anim = "rolled_" .. tostring( result )
				
				if result == 1 then
					bullet_circle( "tentacler_melee_portal", 1, 750 )
				elseif result == 2 then
					bullet_circle( "propane_tank_green", 2, 625 )
				elseif result == 3 then
					bullet_circle( "bomb_holy_shit", 3, 500 )
				elseif result == 4 then
					bullet_circle( "deck/crazy_sausage", 4, 375 )
				elseif result == 5 then
					bullet_circle( "orb_shine_mysterious", 5, 250 )
				elseif result == 6 then
					bullet_circle( "thunderball_line", 6, 125 )
				end
			else
				if result < 3 then
					textprint = textprint .. "bad"
					anim = "rolled_bad"
					shoot_projectile( entity_id, "data/entities/animals/boss_wizard/newsun.xml", pos_x + 125, pos_y - 25, -120, 24 )
					shoot_projectile( entity_id, "data/entities/animals/boss_wizard/newsun_dark.xml", pos_x- 125, pos_y + 52, 120, -24 )
				else
					textprint = textprint .. "good"
					anim = "rolled_good"
					shoot_projectile( entity_id, "data/entities/misc/chest_rain_rainbow.xml", pos_x, pos_y, 0, 0 )
				end
				
				GamePrint( textprint )
			end
			
			edit_component2( entity_id, "SpriteComponent", function(comp,vars)
				ComponentSetValue2( comp, "rect_animation", anim )
			end)
		end
	end
	
	ComponentSetValue2( rstorage, "value_int", status )
end