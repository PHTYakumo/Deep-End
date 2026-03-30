dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local opts = { "failed_alchemist", "wizard_tele", "wizard_dark", "wizard_poly", "wizard_homing", "wizard_weaken", "wizard_twitchy", "wizard_neutral", "wizard_hearty" }

for i=1,9 do
	local circle = math.pi * 2
	local inc = circle / 9
	
	local nx = x + math.cos( inc * i ) * 12
	local ny = y + math.sin( inc * i ) * 12 - 24
	local wid = EntityLoad( "data/entities/animals/" .. opts[i] .. ".xml", nx, ny )
	local gcomp = EntityGetFirstComponent( wid, "CharacterPlatformingComponent" )
	
	if ( gcomp ~= nil ) then ComponentSetValue2( gcomp, "pixel_gravity", 2 ) end

	if not EntityHasTag( wid, "no_swap" ) then EntityAddTag( wid, "no_swap" ) end
	if not EntityHasTag( wid, "teleportable_NOT" ) then EntityAddTag( wid, "teleportable_NOT" ) end
	if not EntityHasTag( wid, "touchmagic_immunity" ) then EntityAddTag( wid, "touchmagic_immunity" ) end
	if not EntityHasTag( wid, "polymorphable_NOT" ) then EntityAddTag( wid, "polymorphable_NOT" ) end
	-- if not EntityHasTag( wid, "necrobot_NOT" ) then EntityAddTag( wid, "necrobot_NOT" ) end

	-- local boost = EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml" )
    -- EntityAddChild( wid, boost )

	EntityAddComponent( wid, "LuaComponent", {
		script_damage_about_to_be_received = "data/entities/animals/boss_wizard/orbit/dmg_cap.lua",
		execute_every_n_frame = "-1",
	} )
end

EntityKill( entity_id )