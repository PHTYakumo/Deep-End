dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local entities = EntityGetInRadiusWithTag( x, y, 128, "hittable" )
local boss_id = EntityGetWithTag( "deep_end_boss_spirit" )
local player = EntityGetInRadiusWithTag( x, y, 35900 * 0.5, "player_unit" )
local sseed = EntityGetInRadiusWithTag( x, y, 1024, "seed_b" )

for i,v in ipairs( entities ) do
	local comp = EntityGetFirstComponent( v, "DamageModelComponent" )
	
	if ( comp ~= nil ) and ( EntityHasTag( v, "islandspirit" ) == false ) then
		local hp = ComponentGetValue2( comp, "hp" )
		if ( hp > 0.04 ) then
			hp = hp * 0.6
		end
		ComponentSetValue2( comp, "hp", hp )

		local curse_list = { "effect_confusion_once", "neutralized_once", "effect_blindness_once" }
		for j=1,#curse_list do EntityAddChild( v, EntityLoad( "data/entities/misc/" .. curse_list[j] .. ".xml" ) ) end
	end
	
	local tx,ty = EntityGetTransform( v )
	EntityLoad( "data/entities/particles/blue_glow.xml", tx, ty )
end

entities = EntityGetInRadiusWithTag( x, y, 512, "islandspirit" )

if ( #boss_id > 0 ) and ( #player > 0 ) and ( #sseed == 0 ) then	
	local the_deer = boss_id[1]

	for i,v in ipairs( player ) do
		local px,py = EntityGetTransform( v )
		
		shoot_projectile( the_deer, "data/entities/projectiles/orb_swapper.xml", px, py , 0, 0 )
		EntityAddChild( the_deer, EntityLoad( "data/entities/misc/effect_regeneration_boss_shorter.xml", x, y ) )
		
		-- local rx,ry = EntityGetTransform( the_deer )

		-- shoot_projectile( the_deer, "data/entities/animals/boss_spirit/summon_lance.xml", rx, ry, px-rx, py-ry )

		px,py = EntityGetTransform( boss_id[1] )

		for i,v in ipairs( entities ) do
			local ex,ey = EntityGetTransform( v )
	
			SetRandomSeed( ey, ex )
			EntityLoad( "data/entities/particles/blue_glow.xml", ex, ey )
	
			local orb_list = { "hearty", "poly", "weaken" }
			local ornd = Random( 1, #orb_list )

			local vx = ( x-ex ) * 13
			local vy = ( y-ey ) * 13
			
			shoot_projectile( entity_id, "data/entities/animals/boss_spirit/orb_rnd/homing/orb_" .. orb_list[ornd] .. ".xml", ex, ey, vx, vy )
		end
	end
end