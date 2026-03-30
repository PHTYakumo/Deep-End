dofile_once("data/scripts/lib/utilities.lua")

potions = 
{	
	{--------prowerful--------
		material="mimic_liquid",
		cost=800,
	},
	{
		material="porridge",
		cost=800,
	},
	{
		material="Eucharist_Deep_End",
		cost=800,
	},
	{
		material="blood_worm",
		cost=800,
	},
	{
		material="Vigour_powder",
		cost=800,
	},
	{
		material="magic_gas_hp_regeneration",
		cost=800,
	},
	{
		material="magic_liquid_hp_regeneration",
		cost=800,
	},
	{
		material="magic_liquid_hp_regeneration_unstable",
		cost=800,
	},
	{
		material="magic_liquid_protection_all",
		cost=800,
	},
	{--------???--------
		material="physics_throw_material_part2",
		cost=800,
	},
	{
		material="item_box2d",
		cost=800,
	},
	{
		material="trailer_text",
		cost=800,
	},
	{
		material="fire_blue",
		cost=800,
	},
}

local function shuffle_potion_list( t )
	assert( t, "shuffle_potion_list() expected a table, got nil" )
	local iterations = #t
	local j
	local year, month, day = GameGetDateAndTimeLocal()

	SetRandomSeed( month, day + year )
	
	for i = iterations, 2, -1 do
		j = Random(1,i)
		t[i], t[j] = t[j], t[i]
	end
end

shuffle_potion_list( potions )

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	local year, month, day = GameGetDateAndTimeLocal()
	local potion_material = "water"

	SetRandomSeed( y - entity_id + year, x * math.pi - month * day )
	
	potion_material = random_from_array( potions )
	potion_material = potion_material.material
	
	local total_capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000
	if not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then total_capacity = total_capacity * Random( 40, 60 ) * 0.01 end

	local scomp = EntityGetFirstComponentIncludingDisabled( entity_id, "MaterialSuckerComponent" )
	if scomp ~= nil then ComponentSetValue2( scomp, "barrel_size", total_capacity ) end

	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
	if dcomp ~= nil then ComponentSetValue2( dcomp, "ui_report_damage", false ) end
	
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if total_capacity > 1750 then EntityAddTag( entity_id, "extra_potion_capacity" ) end
	
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )

	if components ~= nil then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if ( var_name == "potion_material") then
				potion_material = ComponentGetValue2( comp_id, "value_string" )
			end
		end
	end

	AddMaterialInventoryMaterial( entity_id, potion_material, total_capacity * Random( 100, 120 ) * 0.01 )
end