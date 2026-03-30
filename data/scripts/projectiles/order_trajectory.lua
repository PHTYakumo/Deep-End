dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local parent_id = EntityGetParent( entity_id )
local target_id = entity_id

if parent_id ~= NULL_ENTITY then target_id = parent_id end
local pid = EntityGetClosestWithTag( x, y, "player_unit") -- not shooter

if pid ~= nil then
	local px, py, rot, psx, psy = EntityGetTransform( pid )
	local cx, cy = px, py

	local ctrl_comp = EntityGetFirstComponent( pid, "ControlsComponent" )
	if ctrl_comp ~= nil then cx,cy = ComponentGetValueVector2( ctrl_comp, "mMousePosition") end

	if target_id ~= NULL_ENTITY then
		local projectile_comp = EntityGetFirstComponent( target_id, "ProjectileComponent" )
		local velocity_comp = EntityGetFirstComponent( target_id, "VelocityComponent" )
		
		if projectile_comp == nil or velocity_comp == nil then return end
		SetRandomSeed( GameGetFrameNum() + entity_id, pid )

		ComponentSetValue2( projectile_comp, "collide_with_world", false )
		ComponentSetValue2( projectile_comp, "explosion_dont_damage_shooter", true )

		ComponentSetValue2( velocity_comp, "air_friction", -6 )
		ComponentSetValue2( velocity_comp, "gravity_y", 0 )
		ComponentSetValue2( velocity_comp, "terminal_velocity", 1437 )

		local vx, vy = ComponentGetValueVector2( velocity_comp, "mVelocity" )
		local speed = get_magnitude( vx, vy )

		local vel = Random( 0, clamp( speed, 100, 1000 ) ) * 0.03 + 2
		rot = Random( -256, 1000 ) * 0.005
		
		vx, vy = sign( vx ), sign( psy * vy )
		psx, psy = ( math.cos( rot ) + 1 ) * vel, ( math.sin( rot ) + 1 ) * vel

		px = px - ( psx + Random( 12, 18 ) ) * vx
		py = py - ( psy + Random( 24, 36 ) ) * vy

		EntitySetTransform( target_id, px, py )
		EntityApplyTransform( target_id, px, py )

		rot = Random( -256, 1000 ) * 0.005
		vx, vy = cx - px + math.cos( rot ) * 4, cy - py + math.sin( rot ) * 4

		vel = math.max( get_magnitude( vx, vy ), 0.1 )
		vx, vy = vx * speed / vel, vy * speed / vel

		ComponentSetValueVector2( velocity_comp, "mVelocity", vx, vy )
	end
end