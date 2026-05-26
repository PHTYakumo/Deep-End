dofile_once("data/scripts/lib/utilities.lua")

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local entity_id = GetUpdatedEntityID()
	if damage < 1 and not EntityHasTag( entity_id, "holy_mountain_creature" ) then return damage, math.min( critical_hit_chance, 1000 ) end
	
	local dmgmod = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	if dmgmod == nil then return damage, critical_hit_chance end
	
	local max_hp = ComponentGetValue2( dmgmod, "max_hp" )
	max_hp = math.max( max_hp, 4 )

	if not EntityHasTag( entity_id, "do_not_homing_this" ) then return math.max( ( damage - max_hp ) * 0.1, 0.04 ), 0 end
	if EntityHasTag( entity_id, "destruction_target" ) then return math.min( damage * 0.1, max_hp * 0.4 ), 0 end

	if damage > max_hp * 0.01 and damage < 4000000000 then return max_hp * 0.01, 0 end
	return damage, 0
end

--[[
	Return: 0.1dmg - 0.1maxhp, 0
		data\entities\animals\necromancer_shop.xml
		data\entities\animals\necromancer_super.xml
		data\entities\animals\boss_centipede\minion\*****spirit.xml
		data/entities/animals/parallel/tentacles/parallel_tentacles.xml
		"DEEP_END_OPEN_CHEST_STEEL" and "robot"
	Return: MIN( 0.1dmg, 0.4maxhp ), 0
		data\entities\animals\drone_physics_hell.xml
		data\entities\animals\boss_wizard\spawn_wizard.lua
	Return: 0.01maxhp, 0 ( unless dmg >= 4000000000 )
		data\entities\animals\boss_wizard\orbit\wizard_orb_blood_ex.xml
		data\entities\animals\boss_wizard\orbit\wizard_orb_blood.xml
		data\entities\animals\maggot_tiny\maggot_tiny.xml
]]--
