dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )

if not EntityHasTag( entity_id, "de_plankter_wand" ) then
	local scomp = EntityGetFirstComponent( entity_id, "SpriteComponent" )
	if scomp == nil then return end

	local salpha = ComponentGetValue2( scomp, "alpha" )
	ComponentSetValue2( scomp, "alpha", clamp( salpha - 0.04, 0, 1 ) )

	if ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" ) <= 25 then
		local x, y = EntityGetTransform( entity_id )
		EntitySetTransform( entity_id, x, y - 1 + salpha * 0.5 )
	else
		EntityKill(entity_id)
	end

	return
end

local bcomp = EntityGetFirstComponent( entity_id, "VariableStorageComponent" )
if bcomp == nil then return end

if not EntityHasTag( root_id, "player_unit" ) then
	ComponentSetValue2( bcomp, "value_int", 0 )
	return
end

SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
local x, y = EntityGetTransform( root_id )
y = y - 8

local tx = x + sign( Random(-8,8) ) * ( Random(-8,8) + 13)
local ty = y + sign( Random(-8,8) ) * ( Random(-8,8) + 13)

local success,sx,sy = RaytracePlatforms( x, y, tx, ty )

if success == false then
	sx = tx
	sy = ty
end

edit_component( root_id, "ControlsComponent", function(mcomp,vars) tx, ty = ComponentGetValueVector2( mcomp, "mMousePosition") end )

local times = ComponentGetValue2( bcomp, "value_int" )
ComponentSetValue2( bcomp, "value_int", 0 )

if times > 0 then
	local dist = get_magnitude( tx - sx, ty - sy )
	if dist < 8 then dist = 8 end

	tx = ( tx - sx ) * 8 / dist
	ty = ( ty - sy ) * 8 / dist

	EntitySetTransform( EntityLoad( "data/entities/projectiles/deck/plankter_wand_fx.xml", sx, sy ), sx, sy, math.pi * 0.5 - math.atan2( tx, ty ) )

	sx = sx + tx
	sy = sy + ty

	tx = tx * 96
	ty = ty * 96

	for i=1,times do
		shoot_projectile( root_id, "data/entities/projectiles/deck/light_bullet_plankter.xml", sx, sy, tx + Random(-8,8), ty + Random(-8,8) )
	end
end