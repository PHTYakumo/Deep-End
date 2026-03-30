dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local frame_picked = ComponentGetValue2( EntityGetFirstComponentIncludingDisabled( entity_id, "ItemComponent" ), "mFramePickedUp" )

if GameGetFrameNum() < 10 or GameGetFrameNum() - frame_picked ~= 1 then return end

local swords = EntityGetWithTag( "de_terraprisma" )
if swords[1] == nil then return end

if EntityHasTag( entity_id, "de_terraprisma_ai_disabled" ) then
	for i=1,#swords do if EntityHasTag( swords[i], "de_terraprisma_ai_disabled" ) then
		EntityRemoveTag( swords[i], "de_terraprisma_ai_disabled" )		-- ai-off -> ai-on
	end end

	EntityRemoveTag( entity_id, "de_terraprisma_ai_disabled" )
	GamePrint( GameTextGetTranslatedOrNot("$TR_PRISMA") .. "(" .. tostring(#swords) .. "): " .. GameTextGetTranslatedOrNot("$option_on") )
else
	for i=1,#swords do if not EntityHasTag( swords[i], "de_terraprisma_ai_disabled" ) then
		EntityAddTag( swords[i], "de_terraprisma_ai_disabled" )			-- ai-on -> ai-off
	end end

	EntityAddTag( entity_id, "de_terraprisma_ai_disabled" )
	GamePrint( GameTextGetTranslatedOrNot("$TR_PRISMA") .. "(" .. tostring(#swords) .. "): " .. GameTextGetTranslatedOrNot("$option_off") )
end