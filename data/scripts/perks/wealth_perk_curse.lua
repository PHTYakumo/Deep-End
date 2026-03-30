dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

local killed = -66
local kills = 0
local kill_ = StatsGetValue("enemies_killed")
local kill = tonumber(kill_)

if comps == nil then
	EntityAddComponent( entity_id, "VariableStorageComponent", 
	{ 
		name="enemy_killed_init",
		value_int=kill_,
	} )

	EntityAddComponent( entity_id, "VariableStorageComponent", 
	{ 
		name="enemy_killed_last",
		value_int=kill_,
	} )
else
	for i,comp in ipairs( comps ) do
		local n = ComponentGetValue2( comp, "name" )

		if ( n == "enemy_killed_init" ) then
			killed = ComponentGetValue2( comp, "value_int" )
		elseif ( n == "enemy_killed_last" ) then
			kills = ComponentGetValue2( comp, "value_int" )

			ComponentSetValue2( comp, "value_int", kill )
		end
	end
end

if killed == nil or killed < 0 then return end

killed = tonumber( kill_ ) - killed

if kill > kills and killed < 66 then GamePrint( GameTextGetTranslatedOrNot("$perk_curse_kill_count") .. tostring(66-killed) ) end

if killed >= 66 then
	GamePrintImportant("$perk_curse_kill_completed","")

	EntityKill(entity_id)
end