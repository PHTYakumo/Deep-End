dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local max_cd = 4
local cd = max_cd
local cdcomp
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )

if comps ~= nil then
	for i,comp in ipairs(comps) do
		local n = ComponentGetValue2( comp, "name" )

		if n == "cd" then
			cd = ComponentGetValue2( comp, "value_int" )
			cdcomp = comp
			break
		end
	end
end

function f_pos( entity_name, id, total, pos_x, pos_y, cursor_x, from_x, from_y, offset )
	local intervals = math.floor( ( total+3 ) * 0.5 ) * 2
	local sp = math.pi / intervals
	local order = id
	if id > ( total * 0.5 + 0.5 ) then order = order + 1 end

	local ag = sp * order
	local rg = 30
	local facing = 1
	if pos_x > cursor_x then facing = -1 end

	local trans_x = pos_x - ( math.cos(ag) * rg + offset ) * facing
	local trans_y = pos_y - math.sin(ag) * rg * 1.3

	EntitySetTransform( entity_name, trans_x, trans_y )
	EntityApplyTransform( entity_name, trans_x, trans_y )

	return trans_x,trans_y
end

local pid = EntityGetClosestWithTag( x, y, "player_unit" )

if pid ~= nil then
	local px, py = EntityGetTransform( pid )
	py = py + 4

	EntitySetTransform( entity_id, px, py-8 ) -- set root's pos
	EntityApplyTransform( entity_id, px, py-8 )

	local rclick = false
	local cx = px
	local cy = py
	local ax = 0
	local ay = 1

	component_read(EntityGetFirstComponent(pid, "ControlsComponent"), { mButtonDownRightClick = false }, function(controls_comp)
		rclick = controls_comp.mButtonDownRightClick or false
	end)

	edit_component( pid, "ControlsComponent", function(mcomp,vars)
		cx,cy = ComponentGetValueVector2( mcomp, "mMousePosition")
	end)

	edit_component( pid, "ControlsComponent", function(comp,vars)
		ax,ay = ComponentGetValueVector2( comp, "mAimingVector")
	end)

	local summon_swords = EntityGetWithTag( "summon_sword" )
	local summon_sword_phantoms = EntityGetWithTag( "summon_sword_phantom" )

	if #summon_sword_phantoms > #summon_swords then -- let #summon_sword_phantoms <= #summon_swords
		EntityKill( summon_sword_phantoms[#summon_sword_phantoms] )
	end

	if #summon_swords > 0 then
		for i=1,#summon_swords do -- follow you
			local ox, oy = EntityGetTransform( summon_swords[i] )

			f_pos( summon_swords[i], i, #summon_swords, px, py, cx, ox, oy, 0 )

			edit_component( summon_swords[i], "VelocityComponent", function(comp,vars)
				ComponentSetValueVector2( comp, "mVelocity", ax, ay )
			end)

			ox, oy = EntityGetTransform( summon_sword_phantoms[i] )

			f_pos( summon_sword_phantoms[i], i, #summon_swords, px, py, cx, ox, oy, 0.5 )

			edit_component( summon_sword_phantoms[i], "VelocityComponent", function(comp,vars)
				ComponentSetValueVector2( comp, "mVelocity", ax, ay )
			end)
		end

		if #summon_swords > 18 then -- circle shoot
			local angle = 0
			local branches = math.min( #summon_swords, 72 )
			local space = math.floor( 360 / branches )
			local speed = 100
			local range = 150
			
			for i=1,branches do
				local vx = -math.cos( math.rad(angle) ) * speed
				local vy = -math.sin( math.rad(angle) ) * speed
				local dx = math.cos( math.rad(angle) ) * range
				local dy = math.sin( math.rad(angle) ) * range

				local sid = shoot_projectile( pid, "data/entities/projectiles/deck/summon_sword_shoot_powerful.xml", cx + dx, cy + dy, vx, vy )
				
				EntityAddComponent( sid, "LifetimeComponent", 
				{
					lifetime = "21",
				} )

				angle = angle + space
			end

			for i=1,#summon_swords do
				EntityKill( summon_swords[i] )
			end

			for i=1,#summon_sword_phantoms do
				EntityKill( summon_sword_phantoms[i] )
			end

			GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser/launch", px, py-66 )
			GameScreenshake( 75, px, py )
			-- 	EntityKill( entity_id )
		elseif rclick and cd == 0 then
			if EntityHasTag( entity_id, "death_cross" ) then -- use fewer tags, but is it necessary ?
				cd = max_cd * 10
				EntityRemoveTag( entity_id, "death_cross" )
			else
				cd = max_cd * 10
				EntityAddTag( entity_id, "death_cross" )
			end
		elseif EntityHasTag( entity_id, "death_cross" ) and cd == 0 then -- aiming shoot
			cd = max_cd

			SetRandomSeed( GameGetFrameNum() + #summon_swords, x + cy )
			local shoot_id = Random( 1, #summon_swords )

			local ox, oy = EntityGetTransform( summon_swords[shoot_id] )
			local tar_x = ( cx - ox ) * 1.6
			local tar_y = ( cy - oy ) * 1.6

			shoot_projectile( pid, "data/entities/projectiles/deck/summon_sword_shoot.xml", ox, oy, tar_x, tar_y )

			GameScreenshake( 20, px, py )
			EntityKill( summon_swords[shoot_id] )
			EntityKill( summon_sword_phantoms[shoot_id] )
		end

		if not rclick and cd > max_cd then cd = max_cd end

		cd = math.max( cd-1, 0 )
        ComponentSetValue2( cdcomp, "value_int", cd )
	elseif rclick and EntityHasTag( entity_id, "death_cross" ) then
		EntityRemoveTag( entity_id, "death_cross" )
	end
end
