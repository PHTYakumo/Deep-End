dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform( entity_id )

    if x == nil or entity_id == nil or not EntityGetIsAlive( entity_id ) or damage < 0.075 then return end
   
    local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
    SetRandomSeed( GameGetFrameNum(), entity_id + damage )

    if dcomp == nil or Random( 1, 100 ) > 10 then return end

    local blood_multiplier = ComponentGetValue2( dcomp, "blood_multiplier" ) - Random( 1, 100 ) * 0.1
    ComponentSetValue2( dcomp, "blood_multiplier", math.max( blood_multiplier, 0.0005 ) )

	EntityAddChild( entity_id, EntityLoad( "data/entities/misc/effect_confusion_malfunction.xml", x, y ) )
end
