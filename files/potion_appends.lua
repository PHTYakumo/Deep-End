dofile_once("data/scripts/lib/utilities.lua")

-- potion_aggressive
-- potion_random_material
-- potion_secret
-- potion_starting
-- potion_super
-- powder_stash

materials_magic = 
{
	{--------useful--------
		material="magic_gas_midas",
		cost=800,
	},
	{
		material="magic_liquid_faster_levitation_and_movement",
		cost=800,
	},
	{
		material="magic_liquid_charm",
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
		material="glass_broken",
		cost=800,
	},
	{
		material="magic_liquid",
		cost=800,
	},
	{--------harmful--------
		material="cursed_liquid",
		cost=800,
	},
	{
		material="Pollen_powder",
		cost=800,
	},
	{
		material="Witch_powder",
		cost=800,
	},
	{
		material="deep_end_laser_eye_potion",
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
		material="blood_worm",
		cost=800,
	},
	{
		material="magic_liquid_protection_all",
		cost=800,
	},
	{
		material="Eucharist_Deep_End",
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
}

potion_sparks=
 {
	{
		material="spark_yellow",
		cost=800,
	},
	{
		material="spark_blue",
		cost=800,
	},
	{
		material="spark_blue_dark",
		cost=800,
	},
	{
		material="spark_red",
		cost=800,
	},
	{
		material="spark_red_bright",
		cost=800,
	},
	{
		material="spark_green",
		cost=800,
	},
	{
		material="spark_green_bright",
		cost=800,
	},
	{
		material="spark_teal",
		cost=800,
	},
}

local function shuffle_potion_list( t )
	assert( t, "shuffle_potion_list() expected a table, got nil" )
	local iterations, j = #t
	local year, month, day = GameGetDateAndTimeLocal()

	SetRandomSeed( month, day + year )
	
	for i = iterations, 2, -1 do
		j = Random(1,i)
		t[i], t[j] = t[j], t[i]
	end
end

shuffle_potion_list( materials_magic ) -- 5 : 5 : 5 : 10
shuffle_potion_list( potion_sparks )

function init( entity_id )
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( y - entity_id, x - entity_id )

	local total_capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000
	if not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then total_capacity = total_capacity * Random( 36, 56 ) * 0.01 end
			
	local scomp = EntityGetFirstComponentIncludingDisabled( entity_id, "MaterialSuckerComponent" )
	if scomp ~= nil then ComponentSetValue2( scomp, "barrel_size", total_capacity ) end

	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
	if dcomp ~= nil then ComponentSetValue2( dcomp, "ui_report_damage", false ) end

	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
	local potion_array, mixes = materials_magic, 1

	if total_capacity > 1250 then EntityAddTag( entity_id, "extra_potion_capacity" ) end
	total_capacity = total_capacity * Random( 100, 120 ) * 0.01

	if components ~= nil then for key,comp_id in pairs(components) do if ComponentGetValue2( comp_id, "name" ) == "potion_material" then
		AddMaterialInventoryMaterial( entity_id, ComponentGetValue2( comp_id, "value_string" ), total_capacity )
		mixes = 0
	end end end

	if mixes < 1 then return end
	local array_rnd = Random( 1, 100 ) -- not 0, 100

	if array_rnd <= 20 and not (y > 2048 and y < 2560 ) then -- fungi layer
		mixes = Random( 2, 7 )
		total_capacity = total_capacity * ( mixes + 3 ) * 0.25
		
		potion_array = potion_sparks
	end
	
	for i=1,mixes do
		local potion_material = random_from_array( potion_array )
		AddMaterialInventoryMaterial( entity_id, potion_material.material, total_capacity + i )
	end
end