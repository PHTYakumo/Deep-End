dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local player = EntityGetInRadiusWithTag( x, y, 9, "player_unit" )
if ( #player > 0 ) then
	local pid = player[1]
	if ( pid ~= nil ) and ( pid ~= NULL_ENTITY ) then
		-- EntityInflictDamage( pid, 0.08, "DAMAGE_OVEREATING", "$dcrazy_sausage", "DISINTEGRATED", 0, 0, pid )
		EntityIngestMaterial( pid, CellFactory_GetType( "meat" ), 300 )
		EntityIngestMaterial( pid, CellFactory_GetType( "porridge" ), 50 )

		GamePrint( "$effect_crazy_sausage" )
		-- GlobalsSetValue( "fungal_shift_last_frame", "-30000" )
		EntityKill( entity_id )
	end
end

