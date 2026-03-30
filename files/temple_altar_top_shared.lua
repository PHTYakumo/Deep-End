function spawn_altar_top(x, y, is_solid)
	SetRandomSeed( x, y )
	local randomtop = Random( 1, 100 )
	local file_visual = "data/biome_impl/temple/altar_top_visual.png"
	
	LoadBackgroundSprite( "data/biome_impl/temple/wall_background.png", x-1, y - 30, 35 )

	if ( y > 37500 ) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_boss_arena.png", file_visual, x, y-40, "", true )
	elseif ( y > 3000 ) then
		if (randomtop <= 4) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_water.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 8) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_blood.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 12) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_oil.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 16) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_radioactive.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 20) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_lava.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 24) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_poo.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 28) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_honey.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 32) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_diamond.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 36) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_gold.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 40) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_darkness.png", file_visual, x, y-40, "", true )
		else
			LoadPixelScene( "data/biome_impl/temple/altar_top.png", file_visual, x, y-40, "", true )
		end
	else
		LoadPixelScene( "data/biome_impl/temple/altar_top.png", file_visual, x, y-40, "", true )
	end	

	if is_solid then LoadPixelScene( "data/biome_impl/temple/solid.png", "", x, y-40+300, "", true ) end
end

function spawn_altar_top_deep_end(x, y, is_solid)
	SetRandomSeed( GameGetFrameNum(), x - y )
	local randomtop = Random( 1, 100 )
	local file_visual = "data/biome_impl/temple/altar_top_visual.png"
	
	LoadBackgroundSprite( "data/biome_impl/temple/wall_background.png", x-1, y - 30, 35 )

	if ( y > 37500 ) then
		LoadPixelScene( "data/biome_impl/temple/altar_top_boss_arena.png", file_visual, x, y-40, "", true )
	elseif ( y > 3000 ) then
		if (randomtop <= 4) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_water.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 8) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_blood.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 12) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_oil.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 16) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_radioactive.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 20) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_lava.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 24) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_poo.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 28) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_honey.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 32) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_diamond.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 36) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_gold.png", file_visual, x, y-40, "", true )
		elseif (randomtop <= 40) then
			LoadPixelScene( "data/biome_impl/temple/altar_top_darkness.png", file_visual, x, y-40, "", true )
		else
			LoadPixelScene( "data/biome_impl/temple/altar_top.png", file_visual, x, y-40, "", true )
		end
	else
		LoadPixelScene( "data/biome_impl/temple/altar_top.png", file_visual, x, y-40, "", true )
	end	

	if is_solid then LoadPixelScene( "data/biome_impl/temple/solid.png", "", x, y-40+300, "", true ) end
end