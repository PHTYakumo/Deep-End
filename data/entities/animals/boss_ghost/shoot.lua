dofile_once( "data/scripts/lib/utilities.lua" )

local this = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( this )

local angle = GameGetFrameNum() / 2
local branches = 6
local space = math.floor( 360 / branches )
local speed = 160
local range = 325

for i=1,branches do
	local vel_x = math.cos( math.rad(angle) ) * speed
	local vel_y = math.sin( math.rad(angle) ) * speed
	local dir_x = math.cos( math.rad(angle) ) * range
	local dir_y = math.sin( math.rad(angle) ) * range

	shoot_projectile( this, "data/entities/animals/boss_ghost/orb_circleshot.xml", pos_x - dir_x, pos_y - dir_y, vel_x, vel_y )
	angle = angle + space
end

angle = angle + space / 2
speed = 40

for i=1,branches do
	SetRandomSeed( GameGetFrameNum(), this * i )

	if ( Random( 1, 7 ) == 1 ) then
		local vel_x = math.cos( math.rad(angle) ) * speed
		local vel_y = math.sin( math.rad(angle) ) * speed
		
		if ( Random( 1, 13 ) == 1 ) then
			shoot_projectile( this, "data/entities/animals/boss_ghost/dotshot_stronger.xml", pos_x, pos_y, vel_x, vel_y ) 
		else
			shoot_projectile( this, "data/entities/animals/boss_ghost/dotshot_strong.xml", pos_x, pos_y, vel_x, vel_y )
		end
	end
	angle = angle + space
end