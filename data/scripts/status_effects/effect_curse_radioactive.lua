dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if GameHasFlagRun( "greed_curse" ) and GameHasFlagRun( "greed_curse_gone" ) == false then
	EntityLoad( "data/entities/misc/convert_radioactive_with_delay.xml", x, y )
end

local et = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if et % 4 ~= 3 then return end

local pid = EntityGetRootEntity( entity_id )
local moneycomp = EntityGetFirstComponent( pid, "WalletComponent" )

if moneycomp ~= nil then
	local money = ComponentGetValue2( moneycomp, "money" )
	ComponentSetValue2( moneycomp, "money", math.min( money * 2, 10000000 ) )
end