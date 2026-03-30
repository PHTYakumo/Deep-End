dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id  = GetUpdatedEntityID()
local shooter = EntityGetRootEntity( entity_id )

if ( shooter ~= nil ) and ( shooter ~= NULL_ENTITY ) and ( not EntityHasTag( shooter, "prey" ) ) then  
    local x, y = EntityGetTransform( entity_id )
    local players = EntityGetInRadiusWithTag( x, y, 14, "prey" )

    if players ~= nil then
        x, y = EntityGetTransform( shooter )

        for i=1,#players do
            local px,py = EntityGetTransform( players[i] )
            local dir = -math.atan2( y - py, x - px )
        
            local vel_x = math.cos( dir ) * 600
            local vel_y = -math.sin( dir ) * 600
            
            edit_component( players[i], "VelocityComponent", function(vcomp,vars)
                ComponentSetValueVector2( vcomp, "mVelocity", vel_x, vel_y )
            end)
            
            edit_component( players[i], "CharacterDataComponent", function(ccomp,vars)
                ComponentSetValueVector2( ccomp, "mVelocity", vel_x, vel_y )
            end)

            EntityInflictDamage( players[i], 0.00001, "DAMAGE_MELEE", "$dSword", "BLOOD_EXPLOSION", 0, 0, shooter )
        end
    end
end