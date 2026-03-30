dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")

local function Free()
	local p = EntityGetWithTag( "player_unit" )

	if ( #p > 0 ) then
		for i=1,#p do
			local pl = p[i]
			local px,py,pr,psx,psy = EntityGetTransform( pl )

			EntitySetTransform( pl, px, py, pr, psx, math.abs(psy) )

			local gcomp = EntityGetFirstComponent( pl, "CharacterPlatformingComponent" )
	
			if ( gcomp ~= nil ) then
				ComponentSetValue2( gcomp, "pixel_gravity", math.abs(ComponentGetValue2( gcomp, "pixel_gravity" )) )
			end

			if not EntityHasTag( pl, "glue_NOT" ) then EntityAddTag( pl, "glue_NOT" ) end
			if not EntityHasTag( pl, "no_swap" ) then EntityAddTag( pl, "no_swap" ) end

			EntityAddComponent( pl, "LuaComponent", 
			{ 
				script_source_file="data/scripts/perks/defeat_boss_robot.lua",
				execute_every_n_frame="10",
			} )

			local damagemodels = EntityGetComponent( pl, "DamageModelComponent" )
			
			if ( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					ComponentSetValue2( damagemodel, "materials_damage", false )
				end
			end
		end
	end
end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local summon = EntityGetInRadiusWithTag( x, y, 256, "de_robot_boss_create" )
	if #summon > 0 then for i=1,#summon do EntityKill(summon[i]) end end

	AddFlagPersistent( "miniboss_robot" )
	
	if EntityHasTag( entity_id, "holy_mountain_creature" ) then
		EntityConvertToMaterial( entity_id, "fire" )
		return
	end

	EntityLoad("data/entities/animals/boss_robot/explosion/explosion_giga_long.xml", x, y)
	CreateItemActionEntity( "DE_ORDER", 3817, 12110 )
	
	if math.abs( x ) > 20000 then Free() end
end