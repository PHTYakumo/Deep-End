dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( GetUpdatedEntityID() )
	
	SetRandomSeed( GameGetFrameNum(), x + y + entity_id )

	local health = 0
	local no_gold_drop = false
	
	edit_component( entity_id, "DamageModelComponent", function(comp,vars)
		health = ComponentGetValue2( comp, "hp")
	end)

	edit_component_with_tag( entity_id, "VariableStorageComponent", "no_gold_drop", function(comp,vars) no_gold_drop = true end )
	
	if (health > 0.4) and (health - damage < 0.4) then
		local opts = { "slimeshooter", "slimeshooter_weak", "acidshooter", "acidshooter_weak" }
		local mrnd = Random(2,5)

		if not no_gold_drop then
			opts = { "giantshooter", "giantshooter_weak" }
			mrnd = Random(3,4)
		end

		for i=1,mrnd do
			local offsetx = Random(-10,10)
			local offsety = Random(-10,10)
			
			local e = EntityLoad( "data/entities/animals/" .. opts[Random(1,#opts)] .. ".xml", x + offsetx, y + offsety )

			EntityAddChild( e, EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml", x, y ) )

			edit_component( e, "VelocityComponent", function(comp,vars)
				local vel_x = Random(-90,90)
				local vel_y = Random(-150,25)
				ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y )
			end)

			EntityAddComponent( e, "VariableStorageComponent", 
			{ 
				_tags="no_gold_drop",
			} )
		end
	end
end