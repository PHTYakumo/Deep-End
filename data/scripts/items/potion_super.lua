 dofile_once("data/scripts/lib/utilities.lua")

 materials_magic = 
 {
	 {--------useful--------
		 material="magic_liquid_movement_faster",
		 cost=800,
	 },
	 {
		 material="magic_liquid_faster_levitation_and_movement",
		 cost=800,
	 },
	 {
		 material="magic_gas_midas",
		 cost=800,
	 },
	 {
		 material="midas",
		 cost=800,
	 },
	 {
		 material="midas_precursor",
		 cost=800,
	 },
	 {
		 material="magic_liquid_invisibility",
		 cost=800,
	 },
	 {
		 material="purifying_powder",
		 cost=800,
	 },
	 {
		 material="Bouncing_Burst_powder",
		 cost=800,
	 },
	 {
		 material="Cell_Eater_powder",
		 cost=800,
	 },
	 {--------useless--------
		 material="sodium",
		 cost=800,
	 },
	 {
		 material="mammi",
		 cost=800,
	 },
	 {
		 material="fungi_creeping",
		 cost=800,
	 },
	 {
		 material="poo",
		 cost=800,
	 },
	 {
		 material="glass_broken",
		 cost=800,
	 },
	 {
		 material="magic_liquid",
		 cost=800,
	 },
	 {
		 material="grass_holy",
		 cost=800,
	 },
	 {
		 material="deep_end_laser_eye_potion",
		 cost=800,
	 },
	 {--------harmful--------
		 material="cursed_liquid",
		 cost=800,
	 },
	 {
		 material="material_darkness",
		 cost=800,
	 },
	 {
		 material="pus",
		 cost=800,
	 },
	 {
		 material="Firebolt_powder",
		 cost=800,
	 },
	 {
		 material="Pollen_powder",
		 cost=800,
	 },
	 {
		 material="Lightning_Spells_powder",
		 cost=800,
	 },
	 {
		 material="Disc_powder",
		 cost=800,
	 },
	 {
		 material="Witch_powder",
		 cost=800,
	 },
	 {
		 material="deep_end_gravity_potion",
		 cost=800,
	 },
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
		material="deep_end_harden_potion",
		cost=800,
	 },
	 {
		 material="magic_liquid_protection_all",
		 cost=800,
	 },
 }

potions=
 {
	{--------useful--------
		material="magic_liquid_movement_faster",
		cost=800,
	},
	{
		material="magic_liquid_faster_levitation_and_movement",
		cost=800,
	},
	{
		material="magic_gas_midas",
		cost=800,
	},
	{
		material="magic_liquid_invisibility",
		cost=800,
	},
	{
		material="purifying_powder",
		cost=800,
	},
	{--------useless--------
		material="magic_liquid",
		cost=800,
	},
	{
		material="grass_holy",
		cost=800,
	},
	{
		material="deep_end_laser_eye_potion",
		cost=800,
	},
	{--------harmful--------
		material="deep_end_gravity_potion",
		cost=800,
	},
	{--------prowerful--------
		material="mimic_liquid",
		cost=800,
	},
	{
		material="porridge",
		cost=800,
	},
	{
		material="blood_worm",
		cost=800,
	},
	{
		material="magic_liquid_protection_all",
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
shuffle_potion_list( materials_magic )

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	local potion_material = "water_fading"

	SetRandomSeed( x * 3.14159, y - entity_id )

	if EntityHasTag( entity_id, "item_shop" ) then
		potion_material = random_from_array( potions )
	else
		potion_material = random_from_array( materials_magic )
	end

	potion_material = potion_material.material

	local total_capacity = 200
	local comp = EntityGetFirstComponentIncludingDisabled( entity_id, "MaterialSuckerComponent" )	
	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )

	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue2( comp_id, "name" )
			if( var_name == "potion_material") then
				potion_material = ComponentGetValue2( comp_id, "value_string" )
			end
		end
	end

	if ( comp ~= nil ) then
		ComponentSetValue2( comp, "barrel_size", total_capacity )
	end

	AddMaterialInventoryMaterial( entity_id, potion_material, total_capacity )
	EntityAddTag( entity_id, "extra_potion_capacity" )
end