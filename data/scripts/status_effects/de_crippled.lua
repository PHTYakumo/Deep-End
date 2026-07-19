dofile_once("data/scripts/lib/utilities.lua")

local dmgd_frame = tonumber( GlobalsGetValue( "DEEP_END_PLAYER_LAST_DAMAGED_FRAME", "-1" ) ) + 1
if dmgd_frame <= 0 or dmgd_frame ~= GameGetFrameNum() then return end

local entity_id, hp_lim = EntityGetParent(GetUpdatedEntityID()), 0.04
local coeff = 0.035 -- hp -> 0, for 10 times, max_hp = 70.02823% init_max_hp

local dmgmod = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
if dmgmod == nil then return end

local max_hp = math.max( ComponentGetValue2( dmgmod, "max_hp" ), hp_lim )
local hp = math.min( ComponentGetValue2( dmgmod, "hp" ), max_hp )

if hp < 0 then ComponentSetValue2( dmgmod, "hp", hp_lim ) end
ComponentSetValue2( dmgmod, "max_hp", clamp( max_hp * ( 1 - coeff ) + hp * coeff, hp_lim, max_hp ) )

ComponentSetValue2( dmgmod, "mLastMaxHpChangeFrame", dmgd_frame )
ComponentSetValue2( dmgmod, "mLastDamageFrame", dmgd_frame )
