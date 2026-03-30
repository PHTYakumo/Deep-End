dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, r, sx, sy = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), x + y )

local posxrnd = Random( -10, 10 ) * 0.25
local posyrnd = Random( -10, 10 ) * 0.25

local sxrnd = Random( -10, 10 ) * 0.004
local syrnd = Random( -10, 10 ) * 0.004

local angle = 2 * math.pi / 30

EntitySetTransform( entity_id, x + posxrnd, y + posyrnd, r + angle, clamp( sx + sxrnd, 0.88, 1.12 ), clamp( sy + syrnd, 0.88, 1.12 ) )