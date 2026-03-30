dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local parent_id = EntityGetParent(entity_id)

local root_id = EntityGetRootEntity(entity_id)
local x, y = EntityGetTransform(root_id)

local satellites = EntityGetAllChildren( parent_id, "de_shield_satellite" )
local number = 1

for i=1,#satellites do
    if entity_id == satellites[i] then
        number = i
        break
    end
end

local ox = x
local oy = y - 4

local circle = math.pi * 2
local speed = 0.05

if number > 30 then
    local radius = 15
    local amount = 6

    local inc = circle / amount
    local dir = inc * ( number ) + GameGetFrameNum() * speed

    ox = ox + radius * math.cos( dir )
    oy = oy + radius * math.sin( dir )
elseif number > 18 then
    local radius = 30
    local amount = 12

    local inc = circle / amount
    local dir = inc * ( number ) + GameGetFrameNum() * speed

    ox = ox + radius * math.cos( dir )
    oy = oy + radius * math.sin( dir )
else
    local radius = clamp( #satellites * 15 / 6, 15, 45 )
    local amount = clamp( #satellites, 1, 18 )

    local inc = circle / amount
    local dir = inc * ( number ) + GameGetFrameNum() * speed

    ox = ox + radius * math.cos( dir )
    oy = oy + radius * math.sin( dir )
end

EntitySetTransform( entity_id, ox, oy )
EntityApplyTransform( entity_id, ox, oy )