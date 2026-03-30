dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/gun/gun_enums.lua" )
dofile_once( "data/scripts/gun/gun_actions.lua" )
dofile_once( "data/scripts/game_helpers.lua" )

-------------------------------------------------------------------------------

function make_random_ammo_card( x, y )
	-- this does NOT call SetRandomSeed() on purpouse. 
	-- SetRandomSeed( x, y )

	local item = ""
	local valid = false

	while valid == false do
		local itemno = Random(1,#actions)
		local thisitem = actions[itemno]
		item = string.lower(thisitem.id)
		
		if thisitem.type == ACTION_TYPE_PROJECTILE or thisitem.type == ACTION_TYPE_STATIC_PROJECTILE or thisitem.type == ACTION_TYPE_MATERIAL or thisitem.type == ACTION_TYPE_PASSIVE then
			-- always true
			valid = true

			if thisitem.id == "DE_RESET_ALL" or thisitem.id == "DE_ULTIMATE" then valid = false end
		else
			valid = false
		end
	end


	if ( string.len(item) > 0 ) then
		local card_entity = CreateItemActionEntity( item, x, y )
		return card_entity
	else
		print( "No valid action entity found!" )
	end
end

-------------------------------------------------------------------------------

function drop_random_reward( x, y, entity_id, rand_x, rand_y, set_rnd_  )
	local set_rnd = false 
	if( set_rnd_ ~= nil ) then set_rnd = set_rnd_ end

	if( set_rnd ) then
		SetRandomSeed( GameGetFrameNum(), x + y + entity_id )
	end
	
	local good_item_dropped = true
	
	-- using deferred loading of entities, since loading some of them (e.g. potion.xml) will call SetRandomSeed(...)
	-- if position is not given (in entities table), will load the entity to rand_x, rand_y and then move it to chest position
	-- reason for this is that then the SetRandomSeed() of those entities will be deterministic 
	-- but for some reason it cannot be done to random_card.xml, since I'm guessing
	local entities = {}
	
	local rnd = Random(1,101)

	if ( rnd <= 67 ) then
		table.insert( entities, { "data/entities/items/pickup/spell_refresh.xml" } )
	end

	local amount = Random(3,6)
	local angle = math.pi * 0.5

	local chosen = tonumber(ModSettingGet( "DEEP_END.MAP_TYPE" ))
	if ( chosen >= 3 ) then amount = Random(4,6) end

	if ( amount % 2 == 1 ) then
		angle = angle * (-1)^Random(2,7)
	else
		angle = angle * 0.25 * Random(-2,2)
	end

	for i=1,amount do
		local sangle = angle + math.pi * 2 * i / amount
		local ex = x + math.cos(sangle) * ( 9 + 2 * amount )
		local ey = y + math.sin(sangle) * ( 9 + 2 * amount )

		local eid = make_random_ammo_card( ex, ey )
		
		EntitySetTransform( eid, ex, ey, 0.06, 0.9, 0.9 )
		EntityApplyTransform( eid, ex, ey, 0.06, 0.9, 0.9 )
	end

	for i,entity in ipairs(entities) do
		local eid = 0 

		if( entity[2] ~= nil and entity[3] ~= nil ) then 
			eid = EntityLoad( entity[1], entity[2], entity[3] ) 
		else
			eid = EntityLoad( entity[1], rand_x, rand_y )
			EntityApplyTransform( eid, x + Random(-10,10), y - 6 + Random(-7,7)  )
		end

		local item_comp = EntityGetFirstComponent( eid, "ItemComponent" )

		-- auto_pickup e.g. gold should have a delay in the next_frame_pickable, since they get gobbled up too fast by the player to see
		if item_comp ~= nil then
			if( ComponentGetValue2( item_comp, "auto_pickup") ) then
				ComponentSetValue2( item_comp, "next_frame_pickable", GameGetFrameNum() + 30 )	
			end
		end
	end


	return good_item_dropped
end

function on_open( entity_item )
	local x, y = EntityGetTransform( entity_item )
	local rand_x = x
	local rand_y = y

	-- PositionSeedComponent
	local position_comp = EntityGetFirstComponent( entity_item, "PositionSeedComponent" )
	if( position_comp ) then
		rand_x = ComponentGetValue2( position_comp, "pos_x")
		rand_y = ComponentGetValue2( position_comp, "pos_y")
	end

	-- NOTE( Petri ): x and y are also used in spawn_heart function, which then limits this
	-- to 0.3 - 0.7 range... thus we'll mix the rand_x, rand_y
	rand_x = rand_x + 509.7
	rand_y = rand_y + 683.1

	SetRandomSeed( rand_x, rand_y )

	-- money
	-- card
	-- potion
	-- wand
	-- bunch of spiders
	-- bomb
	local good_item_dropped = drop_random_reward( x, y, entity_item, rand_x, rand_y, false )
	
	if good_item_dropped then
		EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)
	else
		EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
	end
end

function item_pickup( entity_item, entity_who_picked, name )
	GamePrintImportant( "$log_chest", "" )
	-- GameTriggerMusicCue( "item" )

	--if (remove_entity == false) then
	--	EntityLoad( "data/entities/misc/chest_random_dummy.xml", x, y )
	--end

	on_open( entity_item )
	
	EntityKill( entity_item )
end

function physics_body_modified( is_destroyed )
	-- GamePrint( "A chest was broken open" )
	-- GameTriggerMusicCue( "item" )
	local entity_item = GetUpdatedEntityID()
	
	on_open( entity_item )

	edit_component( entity_item, "ItemComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_item, comp, false )
	end)
	
	EntityKill( entity_item )
end