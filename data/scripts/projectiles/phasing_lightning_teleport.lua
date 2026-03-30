dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent")
if velocity_comp == nil then return end

local tx,ty = ComponentGetValueVector2( velocity_comp, "mVelocity")
local dir, distance = -math.atan2( ty, tx ), 10

x = x + math.cos( dir ) * distance
y = y - math.sin( dir ) * distance

tx = x + math.cos( dir ) * distance * 10
ty = y - math.sin( dir ) * distance * 10

local success,ex,ey = RaytracePlatforms( x, y, tx, ty )
if success == false then ex, ey = tx, ty end

EntitySetTransform( entity_id, ex, ey )
EntityApplyTransform( entity_id, ex, ey )

local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if pcomp == nil then return end

local shooter = ComponentGetValue2( pcomp, "mWhoShot" )
if shooter == nil or shooter == NULL_ENTITY or EntityHasTag( shooter, "wand_ghost" ) then return end

EntitySetTransform( shooter, ex, ey )
EntityApplyTransform( shooter, ex, ey )
