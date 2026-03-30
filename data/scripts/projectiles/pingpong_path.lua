dofile_once( "data/scripts/lib/utilities.lua" )

local exec_wait_min, exec_wait_max, min_vel = 4, 50, 60
local entity_id = GetUpdatedEntityID()

local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if velocity_comp == nil then return end

local vx,vy = ComponentGetValueVector2( velocity_comp, "mVelocity" )
local vel = get_magnitude( vx, vy )

local lua_comps = EntityGetComponent( entity_id, "LuaComponent", "pingpong_path" )
if lua_comps == nil then return end

-- disable once velocity is too low
if vel < min_vel then
	for i=1,#lua_comps do EntitySetComponentIsEnabled( entity_id, lua_comps[i], false ) end
	-- return
end

-- set execute pace based on velocity: faster projectiles bounce more frequently
local exec_wait = map( vel, min_vel, 600, exec_wait_max, exec_wait_min )
exec_wait = clamp( exec_wait, exec_wait_min, exec_wait_max )
exec_wait = math.floor( exec_wait )

for i=1,#lua_comps do ComponentSetValue( lua_comps[i], "execute_every_n_frame", exec_wait ) end

-- bounce
vx, vy = -vx, -vy
ComponentSetValueVector2( velocity_comp, "mVelocity", vx, vy)
