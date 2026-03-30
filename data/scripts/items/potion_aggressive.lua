 dofile_once("data/scripts/lib/utilities.lua")

potions = 
{
	{
		material="Lightning_Spells_powder",
		cell=500,
		cost=200,
	},
	{
		material="Disc_powder",
		cell=500,
		cost=200,
	},
	{
		material="liquid_fire",
		cell=750,
		cost=200,
	},
	{
		material="blood_cold_vapour",
		cell=750,
		cost=200,
	},
	{
		material="poison",
		cell=1000,
		cost=200,
	},
	{
		material="pus",
		cell=1000,
		cost=200,
	},
}


function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x + GameGetFrameNum(), y + entity_id )

	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
	if dcomp ~= nil then ComponentSetValue2( dcomp, "ui_report_damage", false ) end

	local potion = random_from_array( potions )
	AddMaterialInventoryMaterial( entity_id, potion.material, potion.cell )
end
