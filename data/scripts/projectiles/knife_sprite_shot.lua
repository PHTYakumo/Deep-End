dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	if not EntityHasTag( GetUpdatedEntityID(), "card_action_lua_enabled" )
	or EntityHasTag( entity_id, "projectile_knife" )
	or EntityHasTag( entity_id, "projectile_heal" )
	or EntityHasTag( entity_id, "ultra" ) then return end
	
	local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if pcomp == nil then return end

	ComponentSetValue2( pcomp, "friendly_fire", false )
	ComponentSetValue2( pcomp, "velocity_sets_rotation", true )

	local acomps = EntityGetComponentIncludingDisabled( entity_id, "AreaDamageComponent" )
	local bcomps = EntityGetComponent( entity_id, "BlackHoleComponent" )
	local ccomp = EntityGetFirstComponent( entity_id, "CellEaterComponent" )
	local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
	local gcomp = EntityGetFirstComponent( entity_id, "GameAreaEffectComponent" )
	local lcomps = EntityGetComponentIncludingDisabled( entity_id, "LaserEmitterComponent" )
	local scomps = EntityGetComponent( entity_id, "SpriteComponent" )

	if acomps ~= nil then for i=1,#acomps do
		local d_tag = ComponentGetValue2( acomps[i], "entities_with_tag" )

		if d_tag == "mortal" or d_tag == "human" or d_tag == "hittable" or d_tag == "prey" or d_tag == "player_unit" then
			ComponentSetValue2( acomps[i], "entities_with_tag", "homing_target" )
		end
	end end

	if bcomps ~= nil then for i=1,#bcomps do
		ComponentSetValue2( bcomps[i], "damage_amount", 0 )
	end end

	if lcomps ~= nil then for i=1,#lcomps do
		ComponentObjectSetValue2( lcomps[i], "laser", "damage_to_entities", 0 )
	end end

	if acomps ~= nil or bcomps ~= nil or ccomp ~= nil or dcomp ~= nil or gcomp ~= nil or lcomps ~= nil or scomps == nil then return end
	for i=1,#scomps do EntitySetComponentIsEnabled( entity_id, scomps[i], false ) end
	
	EntityAddComponent( entity_id, "SpriteComponent", 
	{ 
    	alpha="0.5",
    	image_file="data/projectiles_gfx/summon_knife.xml",
    	next_rect_animation="",
   		rect_animation="",
	} )

	EntityAddComponent( entity_id, "SpriteComponent", 
	{ 
    	alpha="0.5",
    	image_file="data/projectiles_gfx/summon_knife_freeze_time.xml",
    	next_rect_animation="",
   		rect_animation="",
	} )
end