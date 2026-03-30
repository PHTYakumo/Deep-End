dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile_once("data/scripts/gun/procedural/gun_procedural_superb.lua")

SetRandomSeed( GameGetFrameNum(), 1437 )

local costrnd_1 = Random( 1, 37 )
local costrnd_2 = Random( 1, 13 )

if ( costrnd_1 <= costrnd_2 ) then
    generate_gun_superb( 200 + costrnd_1, 11, true )
else
    generate_gun( 220 + costrnd_1 + costrnd_2, 11, true )
end