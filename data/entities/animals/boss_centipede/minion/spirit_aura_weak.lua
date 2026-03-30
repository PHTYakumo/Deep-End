dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local bid = EntityGetClosestWithTag( x, y, "boss_centipede" )
if bid == nil then return end

local bcomp = EntityGetFirstComponent( bid, "DamageModelComponent" )
if bcomp == nil then return end

local pls = EntityGetInRadiusWithTag( x, y, 80, "player_unit" )
local total = 0

for i,v in ipairs( pls ) do
    EntityInflictDamage( v, 0.02, "NONE", "$damage_centipede", "NONE", 0, 0, bid )
    total = total + 0.4
end

local maxhp = ComponentGetValue2( bcomp, "max_hp" )
local hp = ComponentGetValue2( bcomp, "hp" ) + math.max( total, 0.4 )

hp = math.min( hp, maxhp )
ComponentSetValue2( bcomp, "hp", hp )