dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

if entity_id ~= nil then
    local x, y, r, sx, sy = EntityGetTransform( entity_id )
    local damagemodel = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
    
    if damagemodel ~= nil then
        local air = ComponentGetValue2( damagemodel, "air_in_lungs" )

        if air < 1 then
            ComponentSetValue2( damagemodel, "hp", 0.4 ) 
			ComponentSetValue2( damagemodel, "max_hp", 0.4 )
            ComponentSetValue2( damagemodel, "ui_report_damage", true )
        end

        sx = math.cos( GameGetFrameNum() * 0.1 ) * 2
        sy = math.sin( GameGetFrameNum() * 0.05 ) + 1.5
    else
        sx = math.cos( GameGetFrameNum() * 0.01 ) * math.sin( GameGetFrameNum() * 0.02 ) * 0.5 + 0.75
        sy = math.sin( GameGetFrameNum() * 0.01 ) * math.cos( GameGetFrameNum() * 0.02 ) * 0.5 + 0.75
    end

    EntitySetTransform( entity_id, x, y, r, sx, sy)
end

