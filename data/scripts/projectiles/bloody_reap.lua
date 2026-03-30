dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)

if ( root_id ~= nil ) and ( root_id ~= NULL_ENTITY ) and ( not EntityHasTag( root_id, "de_rape_curse" ) ) then
	EntityAddTag( root_id, "de_rape_curse" )

	EntityAddComponent( root_id, "LuaComponent", 
	{ 
		script_death = "data/scripts/projectiles/bloody_reap_death.lua",
		execute_every_n_frame = "-1",
	} )

	local childs = EntityGetAllChildren( root_id )

	if ( childs ~= nil ) and ( not EntityHasTag( root_id, "player_unit" ) ) and ( not EntityHasTag( root_id, "boss" ) ) then
		for i=1,#childs do
			local childcomps = EntityGetComponent( childs[i], "GameEffectComponent" )

			if ( childcomps ~= nil ) then
				for j=1,#childcomps do
					local effect_str = ComponentGetValue2( childcomps[j], "effect" )

					if ( effect_str == "PROTECTION_ALL" ) or ( effect_str == "SAVING_GRACE" ) then
						EntityRemoveComponent( childs[i], childcomps[j] )
					end
				end
			end
		end

		EntityInflictDamage(root_id, 0.12, "DAMAGE_CURSE", "$damage_curse", "NONE", 0, 0, root_id)
	end
end

EntityKill(entity_id)

