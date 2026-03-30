dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )
SetRandomSeed( GameGetFrameNum(), x + y )

function boost( id )
    local ex,ey = EntityGetTransform( id )
    
    EntityAddChild( id, EntityLoad( "data/entities/misc/effect_damage_plus_small.xml", ex, ey ) )
    EntityAddChild( id, EntityLoad( "data/entities/misc/perks/mana_from_kills_effect.xml", ex, ey ) )
end

if ( entity_id ~= nil ) then
    local is_moving = false
    local px, py, pr, psx, psy = EntityGetTransform( entity_id )

    if( pr > math.pi * 2 ) then
        pr = pr - math.pi * 2
    end

	component_read(EntityGetFirstComponent(entity_id, "ControlsComponent"), { mButtonDownDown = false, mButtonDownUp = false, mButtonDownLeft = false, mButtonDownRight = false, mButtonDownJump = false }, function(controls_comp)
		is_moving = controls_comp.mButtonDownDown or controls_comp.mButtonDownUp or controls_comp.mButtonDownLeft or controls_comp.mButtonDownRight or controls_comp.mButtonDownJump or false
	end)
	
	if ( is_moving ) then
		EntitySetTransform( entity_id, x, y, pr + 0.1, psx, psy)

        px, py, pr, psx, psy = EntityGetTransform( entity_id )

        local opts = { "wizard", "giant", "sheep" , "homunculus", "skullfly", "necromancer_shop", "firemage", "goblin", "monk", "robot", "shotgunner" , "lasershooter", "boss_centipede", "ultimate_killer", "miner", "necromancer", "bigbat", "sniper", "scavenger_leader", "rat" }
        local rnd = Random( 1, #opts )
        local audio = "animals/" .. opts[rnd] .. "/damage/projectile"
        
        GamePlaySound( "data/audio/Desktop/animals.bank", audio, x, y )
        --GamePrint( audio )
    end

    psx = math.cos( GameGetFrameNum() /10 ) * 2

    EntitySetTransform( entity_id, x, y, pr, psx, psy)

    local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
    if( damagemodels ~= nil ) then
        for i,damagemodel in ipairs(damagemodels) do
			local hp = ComponentGetValue2( damagemodel, "hp" )
            local max_hp = ComponentGetValue2( damagemodel, "max_hp" )

            if ( hp > 0.8 ) and ( hp < max_hp*0.75 ) and ( hp < 13 ) and ( Random( 1, 2 ) == 1 ) then
                hp =  math.min( max_hp, hp + Random( 1, 9 ) / Random( 15, 29 ) / 25 )
                
                ComponentSetValue( damagemodel, "hp", hp)
            end
        end
    end

    local eye = Random( 1, 2345 )
    local bomb = math.max( Random( -333, 3 ), 0 )

    local cdis = Random( 64, 192 )
    local crad = Random( 1, 360 ) * 0.0174533

    local cx = x + cdis * math.cos(crad)
    local cy = y + cdis * math.sin(crad)

    if ( eye == 199 ) or ( eye == 399 ) or ( eye == 1999 ) then
        EntityLoad( "data/entities/particles/treble_eye.xml", cx, cy )
        boost( entity_id )
    elseif ( eye == 599 ) then
        EntityLoad( "data/entities/particles/treble_eye.xml", cx, cy+28 )
        EntityLoad( "data/entities/particles/treble_eye.xml", cx, cy )
        EntityLoad( "data/entities/particles/treble_eye.xml", cx, cy-28 )
        boost( entity_id )
    elseif ( eye == 799 ) then
        EntityLoad( "data/entities/particles/treble_eye.xml", cx+33, cy+12 )
        EntityLoad( "data/entities/particles/treble_eye.xml", cx, cy-16 )
        EntityLoad( "data/entities/particles/treble_eye.xml", cx-33, cy+12 )
        boost( entity_id )
    elseif ( eye == 999 ) then
        EntityLoad( "data/entities/particles/treble_eye.xml", cx+33, cy-12 )
        EntityLoad( "data/entities/particles/treble_eye.xml", cx, cy+16 )
        EntityLoad( "data/entities/particles/treble_eye.xml", cx-33, cy-12 )
        boost( entity_id )
    end

    if ( bomb > 0 ) and ( is_moving ) then
        for i=1,bomb do
            local bomb_id = EntityLoad( "data/entities/projectiles/bomb_holy_shit.xml", x-i*sign(cx-x), y+i*sign(cy-y) )
            PhysicsApplyForce( bomb_id, (x-cx)*(-2)^i, (cy-y)*(-2)^i )
        end
    end

    GlobalsSetValue( "TEMPLE_PERK_COUNT", "0" )
end

