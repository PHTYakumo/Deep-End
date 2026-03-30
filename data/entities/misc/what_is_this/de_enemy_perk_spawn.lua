dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/abyss_func.lua" )

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

if EntityHasTag( entity_id, "enemy" ) then
	if ( not IsPlayer(entity_id) ) and ( not EntityHasTag(entity_id, "has_de_perk") ) then
		de_enemy_give_perk(entity_id)

		EntityAddTag(entity_id, "has_de_perk")
	end
else
	local targets = EntityGetInRadiusWithTag( x, y, 20, "enemy" )
	local vaild_enemy_find = 0

	if targets[1] ~= nil then
		for i=1,#targets do
			if ( not IsPlayer(targets[i]) ) and ( not EntityHasTag(targets[i], "has_de_perk") ) then
				de_enemy_give_perk(targets[i])

				EntityAddTag(targets[i], "has_de_perk")

				vaild_enemy_find = vaild_enemy_find + 1

				if vaild_enemy_find > 7 then
					EntityKill(entity_id)
					break
				end
			end
		end
	else
		local target_id = EntityGetClosestWithTag( x, y, "enemy") -- at least find one

		if target_id == nil then return end

		if ( not IsPlayer(target_id) ) and ( not EntityHasTag(target_id, "has_de_perk") ) then
			de_enemy_give_perk(target_id)

			EntityAddTag(target_id, "has_de_perk")
		end
	end
end
