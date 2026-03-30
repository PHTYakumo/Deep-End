dofile_once( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )

function de_enemy_give_wand( target, wand_level )
	if target ~= nil and target ~= NULL_ENTITY then
		local x, y = EntityGetTransform( target )
		SetRandomSeed( target + x, GameGetFrameNum() + y )

		-- must be able to use wands
		local worm = EntityGetComponent( target, "WormAIComponent" )
		local dragon = EntityGetComponent( target, "BossDragonComponent" )
		local ghost = EntityGetComponent( target, "GhostComponent" )
		local lukki = EntityGetComponent( target, "LimbBossComponent" )
		local npccomp = EntityGetComponent( target, "ItemPickUpperComponent" )
		
		if ( worm == nil and dragon == nil and ghost == nil and lukki == nil and npccomp ~= nil
			and not ( EntityHasTag( target, "wand_ghost" ) or EntityHasTag( target, "boss" ) ) )
			or EntityHasTag( target, "de_mimic" ) then
			
			local comps = EntityGetComponent( target, "CameraBoundComponent" )
			if comps ~= nil then for i,camerabound in ipairs(comps) do
				EntitySetComponentIsEnabled( target, camerabound, false )	
			end end

			local wand_level_str = "1"
			if wand_level < 9 then wand_level_str = "0" .. tostring( wand_level )
			else wand_level_str = tostring( wand_level ) end

			local wid = EntityLoad( "data/entities/items/wand_level_" .. wand_level_str .. ".xml", x, y)
			EntityAddTag( wid, "abyss_wand" )

			local icomp = EntityGetFirstComponent( wid, "ItemComponent" )
			ComponentSetValue( icomp, "is_frozen", "true" )
			ComponentSetValue( icomp, "is_all_spells_book", "true" )
		end
	end
end

function de_enemy_give_perk( target )
	if target ~= nil and target ~= NULL_ENTITY then
		local x, y = EntityGetTransform( target )

		SetRandomSeed( x + y, target + GameGetFrameNum() )

		local worm = EntityGetComponent( target, "WormAIComponent" )
		local dragon = EntityGetComponent( target, "BossDragonComponent" )
		local ghost = EntityGetComponent( target, "GhostComponent" )
		local lukki = EntityGetComponent( target, "LimbBossComponent" )

		if worm == nil and dragon == nil and ghost == nil and lukki == nil 
			and ( not EntityHasTag( target, "boss" ) ) and ( not EntityHasTag( target, "holy_mountain_creature" ) ) then
			if #DEEP_END_VAILD_PERKS > 0 then
				local result = DEEP_END_VAILD_PERKS[Random( 1, #DEEP_END_VAILD_PERKS )]
				give_perk_to_enemy( perk_list[result], target, 0 )
			end
		end
	end
end