dofile_once("data/scripts/lib/utilities.lua")

function damage_received( dmg, msg, source )
	local rdmg, mult = dmg, 0.5
	if dmg <= 0 then return end

	local entity_id = GetUpdatedEntityID()
	if EntityHasTag( entity_id, "necrobot_NOT" ) then mult = 3.5 end

	local root_id = EntityGetRootEntity( entity_id )
	if source == nil or source == NULL_ENTITY then return end

	local comp1 = EntityGetFirstComponent( root_id, "DamageModelComponent" )
	if comp1 == nil then return end

	local maxhp = ComponentGetValue2( comp1, "max_hp" )
	local hp = ComponentGetValue2( comp1, "hp" ) + rdmg * mult

	hp = math.min( hp, maxhp )
	ComponentSetValue2( comp1, "hp", hp )

	local test_pos = EntityGetTransform( source )
	if test_pos == nil or source == entity_id or source == root_id then return end

	local comp2 = EntityGetFirstComponent( source, "DamageModelComponent" )
	if comp2 == nil then return end

	rdmg = ComponentGetValue2( comp2, "max_hp" ) * mult * 0.095 -- 33.25% and 4.75%
	rdmg = math.max( rdmg, 2 )

	if not EntityHasTag( source, "player_unit" ) then return end
	EntityInflictDamage( source, rdmg, "NONE", "$damage_orb_blood", "DISINTEGRATED", 0, 0, entity_id )
end