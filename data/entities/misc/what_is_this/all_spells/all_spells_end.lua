dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local proj = EntityGetInRadiusWithTag( x, y, 512, "all_spells_proj" )
if #proj > 0 then for i=1,#proj do EntityKill(proj[i]) end end

EntityLoad("data/entities/misc/what_is_this/all_spells/all_spells_end_effect.xml", x, y)
EntityLoad( "data/entities/items/pickup/chest_random_super.xml", x, y-32 )
EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", x, y-32 )

EntityKill(entity_id)

