local existing_minions = EntityGetWithTag( "de_boss_limbs" )
if #existing_minions >= 16 or existing_minions == nil then return end

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/animals/boss_limbs/boss_limbs.xml", pos_x, pos_y )
EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", pos_x, pos_y )

GamePlaySound( "data/audio/Desktop/animals.bank", "animals/boss_centipede/dying", pos_x, pos_y )
GamePrint( tostring(#existing_minions+1) .. "/16" )