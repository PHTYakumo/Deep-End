dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
if not EntityHasTag( entity_id, "touchmagic_immunity" ) then EntityAddTag( entity_id, "touchmagic_immunity" ) end

if ModSettingGet( "DEEP_END.MEAT_HEAL" ) then
	EntitySetComponentsWithTagEnabled( entity_id, "vacuum", true )
	EntitySetComponentsWithTagEnabled( entity_id, "vacuum_NOT", false )
else
    local x,y = EntityGetTransform( entity_id )
    SetRandomSeed( x + GameGetFrameNum(), y )

    local angle = Random( 0, 99 ) * 0.01
    angle = math.pi * 2 * angle

    local vx = math.cos( angle ) * 90
    local vy = -math.sin( angle ) * 90

    shoot_projectile( entity_id, "data/entities/animals/boss_meat/acidshot_slow.xml", x, y, vx, vy )
end