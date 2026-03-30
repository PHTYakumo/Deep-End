dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)

if EntityHasTag( root_id, "curse_NOT" ) then
	EntityKill( entity_id )
	return
end

local dmgcomp = EntityGetFirstComponent(root_id, "DamageModelComponent" )
local health_rt = 0.024
local sin = 1.08

if ( dmgcomp ~= nil ) then
	component_readwrite( dmgcomp, { hp = 0, max_hp = 0 }, function(comp)
		if ( comp.hp >= 0 ) and ( comp.max_hp > 0 ) then
			sin = math.max( math.min( comp.hp - health_rt, comp.max_hp * health_rt ), sin )
		end
		
		ComponentSetValue2( dmgcomp, "hp", comp.hp - sin )
		EntityInflictDamage( root_id, sin, "DAMAGE_HEALING", "$I_NEED_MORE_POWER", "NONE", 0, 0, root_id )
	end)

	-- GamePrint(tostring(sin))
end

EntityKill( entity_id )