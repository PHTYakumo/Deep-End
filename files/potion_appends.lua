dofile_once("data/scripts/lib/utilities.lua")

-- potion_aggressive
-- potion_random_material
-- potion_secret
-- potion_starting
-- potion_super
-- powder_stash

materials_magic_old = 
{
	{
		material="alcohol",
		cost=500,
	},
	{
		material="magic_liquid_unstable_teleportation",
		cost=600,
	},
	{
		material="magic_liquid_polymorph",
		cost=0,
	},
	{
		material="magic_liquid_random_polymorph",
		cost=400,
	},
	{
		material="magic_liquid_berserk",
		cost=700,
	},
	{
		material="magic_liquid_invisibility",
		cost=900,
	},
	{
		material="material_confusion",
		cost=200,
	},
	{
		material="magic_liquid_movement_faster",
		cost=1000,
	},
	{
		material="magic_liquid_faster_levitation",
		cost=100,
	},
	{
		material="magic_liquid_worm_attractor",
		cost=300,
	},
	{
		material="magic_liquid_mana_regeneration",
		cost=800,
	},
}

materials_magic = 
{
	{--------useful--------
		material="magic_gas_midas",
		cost=700,
	},
	{
		material="magic_liquid_faster_levitation_and_movement",
		cost=600,
	},
	{
		material="magic_liquid_charm",
		cost=650,
	},
	{
		material="Bouncing_Burst_powder",
		cost=550,
	},
	{
		material="Cell_Eater_powder",
		cost=750,
	},
	{--------useless--------
		material="sodium",
		cost=500,
	},
	{
		material="mammi",
		cost=450,
	},
	{
		material="fungi_creeping",
		cost=400,
	},
	{
		material="glass_broken",
		cost=300,
	},
	{
		material="magic_liquid",
		cost=350,
	},
	{--------harmful--------
		material="cursed_liquid",
		cost=50,
	},
	{
		material="Pollen_powder",
		cost=200,
	},
	{
		material="Witch_powder",
		cost=100,
	},
	{
		material="deep_end_laser_eye_potion",
		cost=250,
	},
	{
		material="deep_end_gravity_potion",
		cost=150,
	},
	{--------prowerful--------
		material="mimic_liquid",
		cost=800,
	},
	{
		material="porridge",
		cost=900,
	},
	{
		material="blood_worm",
		cost=850,
	},
	{
		material="magic_liquid_protection_all",
		cost=900,
	},
	{
		material="Eucharist_Deep_End",
		cost=1000,
	},
	{
		material="Vigour_powder",
		cost=950,
	},
	{
		material="magic_gas_hp_regeneration",
		cost=950,
	},
	{
		material="magic_liquid_hp_regeneration",
		cost=950,
	},
	{
		material="magic_liquid_hp_regeneration_unstable",
		cost=950,
	},
	{
		material="deep_end_harden_potion",
		cost=1000,
	},
}

potion_sparks=
 {
	{
		material="spark_yellow",
		cost=0,
	},
	{
		material="spark_blue",
		cost=0,
	},
	{
		material="spark_blue_dark",
		cost=0,
	},
	{
		material="spark_red",
		cost=0,
	},
	{
		material="spark_red_bright",
		cost=0,
	},
	{
		material="spark_green",
		cost=0,
	},
	{
		material="spark_green_bright",
		cost=0,
	},
	{
		material="spark_teal",
		cost=0,
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

shuffle_potion_list( materials_magic_old )
shuffle_potion_list( materials_magic ) -- 5 : 5 : 5 : 10, average cost = 610
shuffle_potion_list( potion_sparks )

function init( entity_id )
	SetRandomSeed( 256, 257 )
	local prnd, set_capacity, potion_material = Random( 1, 10 ), 500, nil

	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( y - entity_id, x - entity_id )

	local total_capacity = math.max( tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000, 1 )
	if not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then set_capacity = total_capacity * Random( 36, 56 ) * 0.01 end
			
	local scomp = EntityGetFirstComponentIncludingDisabled( entity_id, "MaterialSuckerComponent" )
	if scomp ~= nil then ComponentSetValue2( scomp, "barrel_size", set_capacity ) end

	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
	if dcomp ~= nil then ComponentSetValue2( dcomp, "ui_report_damage", false ) end

	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
	local potion_array, mixes = materials_magic, 1

	if math.abs(x) > 14285 and Random( 1, 100 ) > 50 then potion_array = materials_magic_old end
	if y < -1437 and Random( 1, 100 ) <= 50 then potion_array = materials_magic_old end

	if set_capacity > 1250 then EntityAddTag( entity_id, "extra_potion_capacity" ) end
	set_capacity = set_capacity * Random( 100, 120 ) * 0.01

	if components ~= nil then for key,comp_id in pairs(components) do if ComponentGetValue2( comp_id, "name" ) == "potion_material" then
		AddMaterialInventoryMaterial( entity_id, ComponentGetValue2( comp_id, "value_string" ), set_capacity )
		mixes = 0
	end end end

	if mixes < 1 then return end
	local array_rnd = Random( 0, 100 ) -- not 1, 100

	local ppoint = tonumber( GlobalsGetValue( "DEEP_END_POTION_POINT" ) or 0 )
	local pnum = math.max( tonumber( GlobalsGetValue( "DEEP_END_POTION_NUM" ) or 0 ), 1 )

	if array_rnd < ( ppoint / pnum ) * 0.2 - 40 and pnum > 40 then
		mixes = Random( 2, 7 )
		set_capacity = set_capacity * ( mixes + 3 ) * 0.25
		
		potion_array = potion_sparks
	end

	pnum = pnum + 1

	if pnum > prnd and pnum < prnd + #materials_magic + 1 then
		potion_material = materials_magic[ pnum - prnd ]
		-- GamePrint( potion_material.material .. "->" .. tostring( pnum - prnd ) )

		AddMaterialInventoryMaterial( entity_id, potion_material.material, set_capacity )
		ppoint = ppoint + potion_material.cost * set_capacity / total_capacity
	else
		for i=1,mixes do
			potion_material = random_from_array( potion_array )
			-- GamePrint( potion_material.material )

			AddMaterialInventoryMaterial( entity_id, potion_material.material, set_capacity + i )
			ppoint = ppoint + potion_material.cost * set_capacity / total_capacity
		end
	end

	GlobalsSetValue( "DEEP_END_POTION_POINT", tostring( ppoint ) )
	GlobalsSetValue( "DEEP_END_POTION_NUM", tostring( pnum ) )
	-- GamePrint( GlobalsGetValue( "DEEP_END_POTION_POINT" ) .. ", " .. GlobalsGetValue( "DEEP_END_POTION_NUM" ) )
end