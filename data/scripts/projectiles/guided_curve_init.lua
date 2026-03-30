dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pid = EntityGetClosestWithTag( x, y, "player_unit" )
local cx, cy = x, y

if pid ~= nil then
	local ccomp = EntityGetFirstComponent( pid, "ControlsComponent" )
	if ccomp ~= nil then cx, cy = ComponentGetValueVector2( ccomp, "mMousePosition" ) end

	local enemies = EntityGetInRadiusWithTag( cx, cy, 45, "enemy" )
	if #enemies > 0 then cx, cy = EntityGetTransform( enemies[#enemies] ) end

	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	SetRandomSeed( entity_id - y, GameGetFrameNum() - x )

	local mt, nt = 0.25 + Random( -100, 100) * 0.0025, 0.75 - Random( -100, 100) * 0.0025
	local mx, my = x * mt + cx * ( 1 - mt ), y * mt + cy * ( 1 - mt )
	local nx, ny = x * nt + cx * ( 1 - nt ), y * nt + cy * ( 1 - nt )

	mx, my = mx + Random( -100, 100) * 0.75, my - Random( -100, 100) * 0.75
	nx, ny = nx - Random( -100, 100) * 0.75, ny + Random( -100, 100) * 0.75

	if Random( -100, 100) > 50 then mx, my = 2 * x - mx, 2 * y - my end
	if Random( -100, 100) > 50 then nx, ny = 2 * cx - nx, 2 * cy - ny end

	if Random( -100, 100) < -50 then
		mx, my = mx + nx, my + ny
		nx, ny = mx - nx, my - ny
		mx, my = mx - nx, my - ny
	end

	if comps ~= nil then for i,comp in ipairs( comps ) do
		local n = ComponentGetValue2( comp, "name" )
		
		if n == "start" then
			ComponentSetValue2( comp, "value_float", x )
			ComponentSetValue2( comp, "value_string", tostring(y) )
		elseif n == "node_1" then
			ComponentSetValue2( comp, "value_float", mx )
			ComponentSetValue2( comp, "value_string", tostring(my) )
		elseif n == "node_2" then
			ComponentSetValue2( comp, "value_float", nx )
			ComponentSetValue2( comp, "value_string", tostring(ny) )
		elseif n == "end" then
			ComponentSetValue2( comp, "value_float", cx )
			ComponentSetValue2( comp, "value_string", tostring(cy) )
		end
	end end

	local scomp = EntityGetFirstComponentIncludingDisabled( entity_id, "SpriteParticleEmitterComponent" )

	if scomp ~= nil then
		local argb = { 0.5, 0.5, 0.5, 1 }

		if EntityHasTag( entity_id, "death_cross" ) then
			argb[4] = Random( -100, 100 ) + Random( -100, 100 ) * 0.005

			for i=1,3 do
				argb[i] = math.cos( argb[4] * math.pi * 0.005 + math.pi * i * 0.333 )
				argb[i] = clamp( argb[i]^2, 0.333, 0.667 ) * 3 - 0.999
			end

			argb[4] = 0.5 + Random( -100, 100 ) * 0.001
		else
			for i=1,3 do argb[i] = 1 - Random(1,100) * 0.0075 end
			argb[4] = 0.75
		end
		local function r_rgb(min) return 1 - Random(1,100) * 0.01 * ( 1 - min ) end

		ComponentSetValue2( scomp, "color", argb[1], argb[2], argb[3], argb[4] )
	end

	local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
	if vcomp ~= nil then ComponentSetValue2( vcomp, "terminal_velocity", 1280 ) end
end
