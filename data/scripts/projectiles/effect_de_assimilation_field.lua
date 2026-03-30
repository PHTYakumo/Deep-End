dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, sc, cx, cy = EntityGetTransform( entity_id )

local shooter = EntityGetClosestWithTag( x, y, "player_unit")
if shooter == nil or shooter == NULL_ENTITY then return end

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if comps[2] == nil then return end

local executed_times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
local dmg, dcomp = 0, -1

for i,comp in ipairs( comps ) do
    local n = ComponentGetValue2( comp, "name" )
    
    if n == "assimilation_total" then
        dmg = ComponentGetValue2( comp, "value_float" )
        dcomp = comp
		break
    end
end

if dcomp < 0 then return end
local projs = EntityGetInRadiusWithTag( x, y, 30, "projectile" )

if #projs > 0 then for i=1,#projs do local id = projs[i]
	if not EntityHasTag( id, "ultra" )
	and not EntityHasTag( id, "projectile_heal" )
	and not EntityHasTag( id, "projectile_converted" )
	and not EntityHasTag( id, "de_assimilation_field" ) then
		local projcomp = EntityGetFirstComponent( id, "ProjectileComponent" )

		if projcomp ~= nil then
			ComponentSetValue2( projcomp, "on_death_explode", false )
			ComponentSetValue2( projcomp, "on_lifetime_out_explode", false )
			ComponentSetValue2( projcomp, "collide_with_entities", false )
			ComponentSetValue2( projcomp, "collide_with_world", false )
			ComponentSetValue2( projcomp, "lifetime", 999 )

			local pdmg = ComponentGetValue2( projcomp, "damage" ) or 0
			dmg = math.max( dmg, dmg + pdmg )

			pdmg = ComponentObjectGetValue2( projcomp, "config_explosion", "damage" ) or 0
			dmg = math.max( dmg, dmg + pdmg )
		end

		EntityAddComponent( id, "LifetimeComponent", { lifetime = "1", } )
	end
end end

if executed_times % 20 ~= 0 or dmg < 0.1 then
	ComponentSetValue2( dcomp, "value_float", dmg )
	return
else
	ComponentSetValue2( dcomp, "value_float", dmg * 0.25 )
	EntityLoad( "data/entities/particles/poof_red_tiny.xml", x, y )
end

edit_component( shooter, "ControlsComponent", function(mcomp,vars)
	cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
end)

cx = x-cx
cy = y-cy
sc = 0.5 + math.min( dmg * 0.05, 0.75 )
local dist = ( cx^2 + cy^2 )^0.5


local sproj = shoot_projectile( shooter, "data/entities/projectiles/orb_pink_fast.xml", x, y, -cx * 200 / dist, -cy * 200 / dist )
local pcomp = EntityGetFirstComponent( sproj, "ProjectileComponent" )

if pcomp == nil then return end

ComponentSetValue2( pcomp, "damage", dmg )
EntityAddTag( sproj, "projectile_converted" )

EntitySetTransform( sproj, x, y, math.pi*1.5 - math.atan2(cx,cy), sc, sc )
EntityApplyTransform( sproj, x, y, math.pi*1.5 - math.atan2(cx,cy), sc, sc )

EntityAddComponent( sproj, "HomingComponent", 
{
	detect_distance = "60",
	just_rotate_towards_target = "true",
	max_turn_rate = "0.2",
} )