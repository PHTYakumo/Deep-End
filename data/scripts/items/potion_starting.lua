dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/items/init_potion.lua")
-- NOTE( Petri ): 
-- There is a mods/nightmare potion.lua which overwrites this one.


function potion_a_materials()
	local r_value = Random( 1, 1000 )

	if r_value <= 20 then return "glue" end												-- 2%
	if r_value <= 40 then return "purifying_powder" end									-- 2%
	if r_value <= 60 then return "plasma_fading" end									-- 2%
	if r_value <= 80 then return "vomit" end											-- 2%
	if r_value <= 110 then return "urine" end											-- 3%
	if r_value <= 150 then return "molut" end											-- 4%
	if r_value <= 750 then return "milk" end											-- 60%
	if r_value <= 825 then return "radioactive_liquid" end								-- 7.5%
	if r_value <= 900 then return "magic_liquid_invisibility" end						-- 7.5%
	if r_value <= 912 then return "magic_liquid_faster_levitation_and_movement" end		-- 1.2%
	if r_value <= 924 then return "magic_liquid_movement_faster" end					-- 1.2%
	if r_value <= 936 then return "meat_fast" end										-- 1.2%
	if r_value <= 948 then return "Eucharist_Deep_End" end								-- 1.2%
	if r_value <= 960 then return "mimic_liquid" end									-- 1.2%
	if r_value <= 972 then return "blood_worm" end										-- 1.2%
	if r_value <= 984 then return "gold" end											-- 1.2%
	if r_value <= 996 then return "gold_molten" end										-- 1.2%
	if r_value <= 999 then return "Vigour_powder" end									-- 0.3%
	if r_value <= 1000 then return "monster_powder_test" end							-- 0.1%
end


function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y ) -- so that all the potions will be the same in every position with the same seed

	local potion_material = "water"
	local year,month,day = GameGetDateAndTimeLocal()

	local n_of_deaths = tonumber( StatsGlobalGetValue("death_count") )
	if n_of_deaths >= 1 then potion_material = potion_a_materials() end

	local dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
	if dcomp ~= nil then ComponentSetValue2( dcomp, "ui_report_damage", false ) end
	
	if ( month == 4 and day == 1 ) or ( month == 9 and day == 9 ) then potion_material = "physics_throw_material_part2" end
	init_potion( entity_id, potion_material )
end