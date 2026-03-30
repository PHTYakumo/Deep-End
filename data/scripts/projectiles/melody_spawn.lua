dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pid = EntityGetClosestWithTag( x, y, "player_unit" )
local cx, cy = x, y

if pid ~= nil then
	local px, py = EntityGetTransform( pid )
	local mcomp = EntityGetFirstComponent( pid, "ControlsComponent" )

	if mcomp ~= nil then cx, cy = ComponentGetValueVector2( mcomp, "mMousePosition" ) end
	local dx, dy = cx - px, cy - py

	--[[

	math.abs(dx) in range:
	[0,40)			kantele_a
	[40,80)			kantele_d
	[80,120)		kantele_dis
	[120,160)		kantele_e
	[160,)			kantele_g
	[0,25)			ocarina_a
	[25,50)			ocarina_b
	[50,75)			ocarina_c
	[75,100)		ocarina_d
	[100,125)		ocarina_e
	[125,150)		ocarina_f
	[150,175)		ocarina_gsharp
	[175,)			ocarina_a2

	]]--

	--[[ play notes ]]--

	local kantele = { "a", "d", "dis", "e", "g",  }
	local ocarina = { "a", "b", "c", "d", "e", "f", "gsharp", "a2",  }
	local rclick = false

	component_read( ccomp, { mButtonDownRightClick = false }, function(controls_comp)
        rclick = controls_comp.mButtonDownRightClick or false
    end )

	if rclick then
		local oid = math.min( math.floor( math.abs(dx) / 25 ) + 1, 8 )
		GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/ocarina/" .. ocarina[oid] .. "/create", x, y )
	else
		local kid = math.min( math.floor( math.abs(dx) / 40 ) + 1, 5 )
		GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/kantele/" .. kantele[kid] .. "/create", x, y )
	end

	--[[ spawn stars ]]--

	for i=1,2 do
		local angle = math.pi * 2 / 3 * (-1)^i
		local sx = math.cos( angle ) * dx - math.sin( angle ) * dy 
		local sy = math.sin( angle ) * dx + math.cos( angle ) * dy

		local eid = shoot_projectile( pid, "data/entities/projectiles/deck/melody_star.xml", x, y, sx, sy )
		local comps = EntityGetComponent( eid, "VariableStorageComponent" )

		if comps ~= nil then for i,comp in ipairs( comps ) do
			if ComponentGetValue2( comp, "name" ) == "cx" then ComponentSetValue2( comp, "value_float", cx )
			elseif ComponentGetValue2( comp, "name" ) == "cy" then ComponentSetValue2( comp, "value_float", cy ) end
		end end
	end
end

EntityKill( entity_id )