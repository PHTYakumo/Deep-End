dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/abyss_func.lua" )

local entity_id = GetUpdatedEntityID()

function de_perk_check_and_give( entity )
	if IsPlayer( entity ) or EntityHasTag( entity, "has_de_perk" ) then
		EntityAddTag( entity, "has_de_perk" )

		return 0
	else
		de_enemy_give_perk( entity )
		EntityAddTag( entity, "has_de_perk" )

		return 1
	end
end

if EntityHasTag( entity_id, "enemy" ) then
	de_perk_check_and_give( entity_id )
else
	local x, y = EntityGetTransform( entity_id )
	local targets = EntityGetInRadiusWithTag( x, y, 20, "enemy" )

	if targets[1] ~= nil then
		local vaild_enemy_find = 0

		for i=1,#targets do
			vaild_enemy_find = vaild_enemy_find + de_perk_check_and_give( entity_id )

			if vaild_enemy_find > 7 then
				EntityKill( entity_id )
				break
			end
		end
	else
		local target_id = EntityGetClosestWithTag( x, y, "enemy" ) -- at least find one
		if target_id ~= nil then de_perk_check_and_give( target_id ) end
	end
end
