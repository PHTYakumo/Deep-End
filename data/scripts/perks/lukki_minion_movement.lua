dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local px, py = x, y
local owner_id = 0

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local targets = EntityGetInRadiusWithTag( x, y, 5, "projectile_player" )
local targets2 = EntityGetInRadiusWithTag( x, y, 35, "enemy" )
local target = 0
local memorycomp
local swaying = true
local rclick = false
local follow_force = 1.5

if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local name = ComponentGetValue2( v, "name" )
		
		if ( name == "memory" ) then
			memorycomp = v
			target = ComponentGetValue2( v, "value_int" )
			local test = EntityGetTransform( target )
			
			if ( test == nil ) then
				target = 0
			end
		elseif ( name == "owner_id" ) then
			owner_id = ComponentGetValue2( v, "value_int" )
			-- px,py = EntityGetTransform( owner_id )
			edit_component( owner_id, "ControlsComponent", function(mcomp,vars) -- follow your cursor!
				px,py = ComponentGetValueVector2( mcomp, "mMousePosition")
			end)

			component_read(EntityGetFirstComponent( owner_id, "ControlsComponent"), { mButtonDownRightClick = false }, function(controls_comp)
				rclick = controls_comp.mButtonDownRightClick or false
			end)
			
			if ( px == nil ) or ( py == nil ) then
				px,py = x,y
				follow_force = 0
			end

			local mx,my = EntityGetTransform( owner_id )
			if ( mx ~= nil ) or ( my ~= nil ) then
				targets = EntityGetInRadiusWithTag( mx, my, 45, "projectile_player" )
			end
		end
	end
end

local cvx, cvy = 0, 0
local physcomp = EntityGetFirstComponent( entity_id, "PhysicsBodyComponent" )
if ( physcomp ~= nil ) then
	cvx,cvy = PhysicsGetComponentVelocity( entity_id, physcomp )
end

if ( #targets > 0 ) and ( #targets2 == 0 ) and ( target == 0 ) then
	local who = math.floor( #targets / 2 - 0.2 ) + 1
	
	target = targets[who]
	follow_force = 0.4
	
	if ( memorycomp ~= nil ) then
		ComponentSetValue2( memorycomp, "value_int", target )
	end
end

if ( rclick ) then
	px,py = EntityGetTransform( owner_id )
	targets2 = EntityGetInRadiusWithTag( px, py, 250, "enemy" ) -- track the enemy farther away

	if ( #targets2 > 0 ) then
		local who = math.floor( #targets2 / 2 - 0.2 ) + 1

		target = targets2[who]
		follow_force = 1.8
		swaying = false
	end
else
	if ( #targets2 > 0 ) then
		local who = math.floor( #targets2 / 2 - 0.2 ) + 1
		
		target = targets2[who]
		follow_force = 2.7
		swaying = false
	end
end

if ( target ~= 0 ) and ( not EntityHasTag( target, "do_not_homing_this" ) ) and ( not EntityHasTag( target, "boss_ghost_helper" ) ) then
	local test = EntityGetTransform( target )
	
	if ( test ~= nil ) then
		px, py = EntityGetFirstHitboxCenter( target )
	end
end

if swaying then
	local arc = GameGetFrameNum() * 0.01 + entity_id
	local length = 12

	px = px + math.cos( arc ) * length + math.sin( 0 - arc ) * length
	py = py - math.sin( arc ) * length - math.cos( 0 - arc ) * length
end

local dist = math.min( get_distance( x, y, px, py ), 32 ) + 24
local dir = get_direction( x, y, px, py ) 

if ( dist < 36 ) then -- wrap around target 
	dir = dir + ( dist - 18 ) / 16
end

local vel_x = 0 - (math.cos( dir ) * dist)
local vel_y = 0 + (math.sin( dir ) * dist)

if ( ( x > px ) and ( cvx > 0 ) ) or ( ( x < px ) and ( cvx < 0 ) ) then
	vel_x = vel_x * 4
end

if ( ( y > py ) and ( cvy > 0 ) ) or ( ( y < py ) and ( cvy < 0 ) ) then
	vel_y = vel_y * 4
end

dist = ( x - px )^2 + ( y - py )^2

if ( swaying ) and ( dist < 1600 ) then
	local spd = 10
	vel_x = math.cos( GameGetFrameNum()/21 ) * spd
	vel_y = math.sin( GameGetFrameNum()/21 ) * spd
end

PhysicsApplyForce( entity_id, vel_x * follow_force, vel_y * follow_force )

if ( owner_id ~= 0 ) then
	x, y = EntityGetTransform( entity_id )
	local ox, oy = EntityGetTransform( owner_id )
	dist = ( x - ox )^2 + ( y - oy )^2
	
	if ( dist > 160000 ) then
		EntityLoad( "data/entities/particles/teleportation_source.xml", x, y )
		EntityLoad( "data/entities/particles/teleportation_target.xml", ox, oy )

		EntitySetTransform( entity_id, ox, oy )
		EntityApplyTransform( entity_id, ox, oy )

		targets2 = EntityGetInRadiusWithTag( ox, oy, 60, "enemy" ) or 0

		if ( #targets2 > 0 ) then
			ComponentSetValue2( memorycomp, "value_int", targets2[1] )
		else
			ComponentSetValue2( memorycomp, "value_int", 0 )
		end
	end
end