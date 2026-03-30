dofile_once("data/scripts/lib/utilities.lua")

function recycle()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local recycle = 0
	local radius = 18

	if EntityGetRootEntity(entity_id) ~= entity_id then -- must in your inventory
		local cards = EntityGetInRadiusWithTag( x, y, radius, "card_action" )
		local wands = EntityGetInRadiusWithTag( x, y, radius, "wand" )

		for i,card in ipairs( cards ) do
			local comps = EntityGetFirstComponent( card, "ItemCostComponent" )

			if comps == nil and EntityGetRootEntity(card) == card then -- not items from shop or inventory
				recycle = recycle + 2

				EntityKill( card )
			end
		end

		for i,wand in ipairs( wands ) do
			local comps = EntityGetFirstComponent( wand, "ItemCostComponent" )

			if comps == nil and EntityGetRootEntity(wand) == wand then
				recycle = recycle + 15
				recycled = true

				EntityKill( wand )
			end
		end

		if recycle > 14 then 
			GamePrint( "$recycle_2" ) 
		elseif recycle > 0 then 
			GamePrint( "$recycle_1" )
		end

		local pid = EntityGetClosestWithTag( x, y, "player_unit")

		if pid ~= nil then
			local moneycomp = EntityGetFirstComponent( pid, "WalletComponent" )
			local money = ComponentGetValue2( moneycomp, "money" )

			money = money + recycle * 10
			ComponentSetValue2( moneycomp, "money", money )
		end

		local px, py = EntityGetTransform( pid )

		if recycle > 66 then 
			GamePrint( "$recycle_3" )

			EntityLoad("data/entities/projectiles/deck/fireblast.xml", px, py)
			EntityKill( entity_id )
		end
	else
		local victims = EntityGetInRadiusWithTag( x, y, radius * 3, "enemy")

		for i,victim in ipairs( victims ) do EntityAddRandomStains( victim, CellFactory_GetType("poo"), 666 ) end
	end
end

function damage_received()
	recycle()
end

function kick()
	recycle()
end