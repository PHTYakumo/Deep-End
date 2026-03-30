dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if ( vcomp ~= nil ) and ( pcomp ~= nil ) then
	local vx,vy = ComponentGetValueVector2( vcomp, "mVelocity")
	local shooter = ComponentGetValue2( pcomp, "mWhoShot" )

	if ( shooter ~= nil ) and ( shooter ~= NULL_ENTITY ) then
		SetRandomSeed( vx, y )
		
		local frnd = Random( 1, 4 )

		for i=1,16 do
			local px = x + Random( -4, 4 ) * Random( 1, 4 )
			local py = y + Random( -4, 4 ) * Random( 1, 4 )

			if ( i <= frnd ) then
				shoot_projectile( shooter, "data/entities/projectiles/deck/summon_knife_freeze_time.xml", px, py, 7*vx, 7*vy )
			else
				shoot_projectile( shooter, "data/entities/projectiles/deck/summon_knife.xml", px, py, 7*vx, 7*vy )
			end
		end
	end
end

EntityKill( entity_id )