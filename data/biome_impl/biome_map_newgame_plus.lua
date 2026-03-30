-- constants (color format is ARGB)
dofile_once("data/scripts/lib/utilities.lua")

BIOME_MAP_WIDTH = 64
BIOME_MAP_HEIGHT = 100

function clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function shuffleTable( t )
	assert( t, "shuffleTable() expected a table, got nil" )
	local iterations = #t
	local j
	
	for i = iterations, 2, -1 do
		j = Random(1,i)
		t[i], t[j] = t[j], t[i]
	end
end

function paint_biome_area( x, y, w, h, biome_color, buffer )
	local extra_width = Random( 0, buffer )
	x = x - extra_width
	w = w + extra_width + Random( 0, buffer )

	for iy=y,y+h-1 do
		for ix=x,x+w-1 do
			BiomeMapSetPixel( ix, iy, biome_color )
		end
	end
end

function paint_biome_area_split( x, y, w, h, biome_color1, biome_color2, buffer )

	local extra_width = Random( 0, buffer )
	x = x - extra_width
	w = w + extra_width + Random( 0, buffer )
	
	local cutoff_point = Random( y + 1, y+h - 2 )

	for ix=x,x+w-1 do
		for iy=y,y+h-1 do
			if( iy < cutoff_point ) then
				BiomeMapSetPixel( ix, iy, biome_color1 )
			else
				BiomeMapSetPixel( ix, iy, biome_color2 )
			end
		end

		cutoff_point = cutoff_point + Random( -1, 1 )
		cutoff_point = clamp( cutoff_point, y + 1, y+h-2 )
	end
end

function paint_replace_color( pos_x, pos_y, new_biome_color )
	local color_to_replace = BiomeMapGetPixel( pos_x, pos_y )

	for y=0,BIOME_MAP_HEIGHT-1 do
		for x=0,BIOME_MAP_WIDTH-1 do
			if( BiomeMapGetPixel( x, y ) == color_to_replace ) then
				BiomeMapSetPixel( x, y, new_biome_color )
			end
		end
	end
end

function paint_cave( x, y, dir, biome_color, length )

	for i=1,length do

		BiomeMapSetPixel( x, y, biome_color )

		if( i < 5 or Random( 0, 100 ) < 75 ) then
			x = x + dir
		else
			x = x - dir
		end

		if ( x < 2 ) then x = 2 end
		if ( x > 42 ) then x = 42 end
		if ( x > 27 ) and ( x < 33 ) then x = 27 end
		if ( x > 33 ) and ( x < 39 ) then x = 39 end

		BiomeMapSetPixel( x, y, biome_color )

		if( i > 3 ) then
			if( Random( 0, 100 ) < 65 ) then
				y = y + 1
			else
				y = y - 1
			end
		end
		
		if( y < 17 ) then y = 17 end
		if( y > 88 ) then y = 88 end

		if( i > 6 ) then
			if( Random( 0, 100 ) < 35 ) then BiomeMapSetPixel( x - 1, y, biome_color ) end
			if( Random( 0, 100 ) < 35 ) then BiomeMapSetPixel( x + 1, y, biome_color ) end
			if( Random( 0, 100 ) < 35 ) then BiomeMapSetPixel( x, y - 1, biome_color ) end
			if( Random( 0, 100 ) < 35 ) then BiomeMapSetPixel( x, y + 1, biome_color ) end
		end

	end

end

-------------------------------------------------

local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )

BiomeMapSetSize( BIOME_MAP_WIDTH, BIOME_MAP_HEIGHT )

if newgame_n == 0 then
	BiomeMapLoadImage( 0, 0, "data/biome_impl/biome_map_newgame_zero.png" )
elseif newgame_n > 0 then
	BiomeMapLoadImage( 0, 0, "data/biome_impl/biome_map_newgame_plus.png" )
elseif newgame_n < 0 then
	BiomeMapLoadImage( 0, 0, "data/biome_impl/biome_map_newgame_minus.png" )
end

newgame_n = math.abs( newgame_n )

SetRandomSeed( 4573 + newgame_n, 4621 + newgame_n )

newgame_n = math.min( math.floor( 720 / newgame_n ) + 1, Random( 1 , 25 ) )

----


local biome_coalmines = 0xFF4E5267
local biome_collapsedmines = 0xFF726186
local biome_fungicave = 0xFFE861F0
local biome_excavationsite = 0xFF124445
local biome_snowcaves = 0xFF1775D5
local biome_hiisibase = 0xFF0046FF
local biome_jungle_1 = 0xFFA08400
local biome_jungle_2 = 0xFF808000
local biome_vault = 0xFF008000
local biome_sandcaves = 0xFFE1CD32
local biome_snowvault = 0xFF0080A8
local biome_wandcave = 0xFF006C42
local biome_crypt = 0xFF786C42

if( newgame_n % 2 == 0 ) then

	biome_coalmines = 0xFF3D3E37 
	biome_collapsedmines = 0xFF3D3E37
	biome_fungicave = 0xFF3D3E3B
	biome_excavationsite = 0xFF3D3E38
	biome_snowcaves = 0xFF3D3E39
	biome_hiisibase = 0xFF3D3E3A
	biome_jungle_1 = 0xFF3D3E3C
	biome_jungle_2 = 0xFF3D3E3C
	biome_vault = 0xFF3D3E3D
	biome_crypt = 0xFF3D3E3E
end

-- randomized biomes
-- continue work from here,
-- some of the backgrounds need to be raised upwards
if( newgame_n % 3 == 0 ) then
	-- basic biomes
	all_biomes = { 
		0xFFD56517,
		0xFF1775D5,
		0xFFE861F0,
		0xFF375C00,
		0xFF008000,
		0xFF0046FF,
		0xFFA08400,
		0xFFF6CFAD,
		0xFF008000,
		0xFF726186,
		0xFF0080A8,
		0xFF006C42,
		0xFF786C42,
	}

	shuffleTable( all_biomes )

	assert( #all_biomes >= 10 )

	biome_coalmines = 		all_biomes[1]
	biome_collapsedmines = 	all_biomes[2]
	biome_fungicave =		all_biomes[3]
	biome_excavationsite = 	all_biomes[4]
	biome_snowcaves = 		all_biomes[5]
	biome_hiisibase = 		all_biomes[6]
	biome_jungle_1 = 		all_biomes[7]
	biome_jungle_2 = 		all_biomes[8]
	biome_vault = 			all_biomes[9]
	biome_crypt = 			all_biomes[10]

end

local do_walls = false
if( newgame_n % 5 == 0 ) then
	do_walls = true
end

-- hell = 0xFF3D3E3F

if( Random( 0, 100 ) < 35 ) then
	biome_coalmines, biome_collapsedmines = biome_collapsedmines, biome_coalmines
end

if( Random( 0, 100 ) < 35 ) then
	biome_fungicave, biome_excavationsite = biome_excavationsite, biome_fungicave
end

if( Random( 0, 100 ) < 35 ) then
	biome_snowcaves, biome_hiisibase = biome_hiisibase, biome_snowcaves
end

if( Random( 0, 100 ) < 35 ) then
	biome_jungle_1, biome_jungle_2 = biome_jungle_2, biome_jungle_1
end

if( Random( 0, 100 ) < 35 ) then
	biome_sandcaves, biome_fungicave = biome_fungicave, biome_sandcaves
end

if( Random( 0, 100 ) < 35 ) then
	biome_wandcave, biome_sandcaves = biome_sandcaves, biome_wandcave
end
-- caves
if( Random( 0, 100 ) < 65 ) then paint_cave( 19, 29, -1, biome_fungicave, Random( 4, 50 ) ) end
if( Random( 0, 100 ) < 65 ) then paint_cave( 50, 29, 1, biome_fungicave, Random( 4, 50 ) ) end

if( Random( 0, 100 ) < 65 ) then paint_cave( 19, 34, -1, biome_fungicave, Random( 4, 50 ) ) end
if( Random( 0, 100 ) < 65 ) then paint_cave( 50, 34, 1, biome_fungicave, Random( 4, 50 ) ) end

if( Random( 0, 100 ) < 65 ) then paint_cave( 19, 44, -1, biome_wandcave, Random( 5, 50 ) ) end
if( Random( 0, 100 ) < 65 ) then paint_cave( 50, 44, 1, biome_wandcave, Random( 5, 50 ) ) end
if( Random( 0, 100 ) < 65 ) then paint_cave( 19, 50, -1, biome_wandcave, Random( 5, 50 ) ) end
if( Random( 0, 100 ) < 65 ) then paint_cave( 50, 50, 1, biome_wandcave, Random( 5, 50 ) ) end

if( Random( 0, 100 ) < 65 ) then paint_cave( 19, 56, -1, biome_sandcaves, Random( 5, 50 ) ) end
if( Random( 0, 100 ) < 65 ) then paint_cave( 50, 56, 1, biome_sandcaves, Random( 5, 50 ) ) end
if( Random( 0, 100 ) < 65 ) then paint_cave( 19, 62, -1, biome_sandcaves, Random( 5, 50 ) ) end
if( Random( 0, 100 ) < 65 ) then paint_cave( 50, 62, 1, biome_sandcaves, Random( 5, 50 ) ) end

-- biome 1 
paint_biome_area( 50, 29, 3, 2,  biome_coalmines, 0 )
paint_biome_area( 19, 34, 4, 1,  biome_collapsedmines, 1 )

-- biome 2
paint_biome_area( 19, 44, 4, 2,  biome_excavationsite, 2 )

-- biome 3
paint_biome_area_split( 19, 50, 7, 6,  biome_snowcaves, biome_hiisibase, 3 )

-- biome 4
paint_biome_area_split( 19, 56, 7, 4,  biome_jungle_1, biome_jungle_2, 4 )
paint_biome_area_split( 19, 62, 7, 5,  biome_jungle_2, biome_vault, 4 )

-- biome crypt
paint_biome_area( 29, 68, 11, 3,  biome_crypt, 0 )

-- paint walls
if( do_walls ) then
	local wall_left = Random( 2, 6 )
	local wall_right = Random( 1, 4 )

	paint_biome_area( 23, 15, wall_left, 25,  0xFF3D3D3D, 0 )
	paint_biome_area( 33 + (4 - wall_right), 16, wall_right, 22,  0xFF3D3D3D, 0 )
end


-- orb rooms
local orb_1 = 0xFFFFD105
local orb_2 = 0xFFFFD106
local orb_3 = 0xFFFFD107

-- pyramid at 51,11
local orb_pyramid = 0xFFC88F5F
BiomeMapSetPixel( 51, 51, orb_pyramid )
orb_list[1] = {51,51}

-- floating island
local orb_floating_island = 0xFFC08082
BiomeMapSetPixel( 36, 36, orb_floating_island )
orb_list[2] = {36,36}

local x = 0
local y = 0
-- vault 2 
local orb_vault2 = 0xFFFFD102
x = Random( 0, 10 ) + 5
y = Random( 0, 10 ) + 40
BiomeMapSetPixel( x, y, orb_vault2 )
orb_list[3] = {x,y}

-- inside pyramid
local orb_inside_pyramid = 0xFFFFD104
x = Random( 0, 20 ) + 30
y = Random( 0, 20 ) + 50
BiomeMapSetPixel( x, y, orb_inside_pyramid )
orb_list[4] = {x,y}

-- hell
local orb_hell = 0xFFFFD108
x = Random( 0, 30 ) + 10
y = Random( 0, 30 ) + 20
if( newgame_n == 3 or newgame_n >= 25 ) then y = 47 end
BiomeMapSetPixel( x, y, orb_hell )
orb_list[5] = {x,y}

-- snowcave bottom
local orb_snowcave_bottom = 0xFFFFD109
x = Random( 0, 40 ) + 5
y = Random( 0, 40 ) + 30
BiomeMapSetPixel( x, y, orb_snowcave_bottom )
orb_list[6] = {x,y}

-- desert bottom
local orb_desert_bottom = 0xFFFFD110
x = Random( 0, 50 ) + 5
y = Random( 0, 30 ) + 40
BiomeMapSetPixel( x, y, orb_desert_bottom )
orb_list[7] = {x,y}


-- TODO (nuke)
local orb_room_nuke = 0xFFFFD103
x = Random( 0, 50 ) + 5
y = Random( 10, 40 ) + 10
BiomeMapSetPixel( x, y, orb_room_nuke )
orb_list[8] = {x,y}

x = Random( 0, 50 ) + 5
y = Random( 15, 50 ) + 10
BiomeMapSetPixel( x, y, orb_1 )
orb_list[9] = {x,y}

x = Random( 0, 50 ) + 5
y = Random( 20, 60 ) + 10
BiomeMapSetPixel( x, y, orb_2 )
orb_list[10] = {x,y}

x = Random( 0, 50 ) + 5
y = Random( 25, 70 )
BiomeMapSetPixel( x, y, orb_3 )
orb_list[11] = {x,y}

for i,v in pairs(orb_list) do
	local x2 = v[1] - 32
	local y2 = v[2] - 14
	
	v[1] = x2
	v[2] = y2
end

-- dragon cave
if newgame_n < 0 then
	local color_dragon_cave = 0xFF364D24

	BiomeMapSetPixel( 44, 41, color_dragon_cave )
end

local world_state_entity = GameGetWorldStateEntity()
local comp = EntityGetComponent( world_state_entity, "WorldStateComponent" )

if ( comp ~= nil ) then
	orb_map_update()
end

-- biome 5
-- crypt

--[[
for y=0,h-1 do
	for x=0,w-1 do

		if y > 19 then
			BiomeMapSetPixel( x, y, snowcave )
		elseif y > 16 then
			BiomeMapSetPixel( x, y, excavation_site )
		elseif y > 14 then
			BiomeMapSetPixel( x, y, coalmine )
		else
			BiomeMapSetPixel( x, y, hills )
		end

	end
end
]]--