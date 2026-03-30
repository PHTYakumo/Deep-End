 dofile_once("data/scripts/lib/utilities.lua")

-- NOTE( Petri ): 
-- There is a mods/nightmare potion.lua which overwrites this one.

materials_standard = 
{
	{
		material="salt",
		cost=200,
	},
	{
		material="gunpowder",
		cost=200,
	},
	{
		material="fungisoil",
		cost=200,
	},
}

materials_magic = 
{
	{
		material="copper",
		cost=500,
	},
	{
		material="silver",
		cost=500,
	},
	{
		material="gold",
		cost=500,
	},
	{
		material="brass",
		cost=500,
	},
	{
		material="bone",
		cost=800,
	},
	{
		material="purifying_powder",
		cost=800,
	},
	{
		material="fungi",
		cost=800,
	},
}

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y ) -- so that all the potions will be the same in every position with the same seed

	local potion_material = "sand"
	local total_capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000

	if Random( 0, 100 ) <= 20  then
		-- 0.05% chance of magic_liquid_
		potion_material = random_from_array( materials_magic )
		potion_material = potion_material.material
	else
		potion_material = random_from_array( materials_standard )
		potion_material = potion_material.material
	end

	local scomp = EntityGetFirstComponentIncludingDisabled( entity_id, "MaterialSuckerComponent" )
	if scomp ~= nil then ComponentSetValue2( scomp, "barrel_size", total_capacity ) end

	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
	if dcomp ~= nil then ComponentSetValue2( dcomp, "ui_report_damage", false ) end
	
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if total_capacity > 1750 then EntityAddTag( entity_id, "extra_potion_capacity" ) end

	AddMaterialInventoryMaterial( entity_id, potion_material, total_capacity )
end