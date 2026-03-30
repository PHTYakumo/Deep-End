dofile_once("data/scripts/lib/utilities.lua")

-- if script_wait_frames( entity_id, 4 ) then return end
local entity_id = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( entity_id )

local dmgmod = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
if dmgmod == nil then return end

local dmgf = ComponentGetValue2( dmgmod, "mLastDamageFrame" )
if GameGetFrameNum() - dmgf < 5 then shoot_projectile( entity_id, "data/entities/projectiles/deck/de_swarm_wasp.xml", x, y, 0, 0 ) end

