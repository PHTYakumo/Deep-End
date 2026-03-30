dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local pid = EntityGetClosestWithTag( x, y, "player_unit" )

if pid ~= nil then
	local px, py = EntityGetTransform( pid )

	EntitySetTransform( entity_id, px, py )
	EntityApplyTransform( entity_id, px, py )

	local cx = x
	local cy = y
	local ax = 0
	local ay = 1

	edit_component( pid, "ControlsComponent", function(mcomp,vars)
		cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
	end)

	edit_component( pid, "ControlsComponent", function(comp,vars)
		ax,ay = ComponentGetValueVector2( comp, "mAimingVector")
	end)

	local dx = ax * 750 + ( cx - px ) / 3
	local dy = ay * 750 + ( cy - py ) / 3

	shoot_projectile( pid, "data/entities/projectiles/deck/summon_sword.xml", px, py - 15, dx, dy )
	shoot_projectile( pid, "data/entities/projectiles/deck/summon_sword_phantom.xml", px, py - 15, dx, dy )

	local summon_sword_roots = EntityGetWithTag( "summon_sword_root" )
	if #summon_sword_roots > 1 then
		for i=1,#summon_sword_roots-1 do
			if EntityHasTag( summon_sword_roots[i], "death_cross" ) and not EntityHasTag( entity_id, "death_cross" ) then EntityAddTag( entity_id, "death_cross" ) end

			EntityKill( summon_sword_roots[i] )
		end
	end
end

EntityRemoveTag( entity_id, "projectile" )
