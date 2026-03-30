 dofile_once("data/scripts/lib/utilities.lua")

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x - entity_id, y - entity_id )

	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
	if dcomp ~= nil then ComponentSetValue2( dcomp, "ui_report_damage", false ) end
	
	local materials = nil -- local potion = random_from_array( potions )

	if Random( 0, 100 ) <= 75 then
		materials = CellFactory_GetAllLiquids( false )
	else
		materials = CellFactory_GetAllSands( false )
	end

	local potion_material = random_from_array( materials )

	if potion_material == "deep_end_creepy_liquid" or potion_material == "creepy_liquid"
	or potion_material == "deep_end_magic_acid" or potion_material == "monster_powder_test"
	or potion_material == "just_death" then
		potion_material = random_from_array( materials )
	end

	if potion_material == "deep_end_creepy_liquid" then potion_material = "deep_end_hush" end

	AddMaterialInventoryMaterial( entity_id, potion_material, 1000 + Random( 0, 100 ) * 10 )
	-- AddMaterialInventoryMaterial( entity_id, potion.material, 1000 )
end