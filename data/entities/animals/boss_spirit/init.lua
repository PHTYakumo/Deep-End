dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local anger = tonumber( GlobalsGetValue( "HELPLESS_KILLS", "1" ) ) or 1
local boss_hp = math.ceil( clamp( anger^3/7 + anger^2/5 + anger/3, 20 , 100000000 ) / 25 )
local comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )

print("KILLED ANIMALS: " .. tostring( anger ) )

if ( comp ~= nil ) then
	ComponentSetValue2( comp, "max_hp", boss_hp )
	ComponentSetValue2( comp, "hp", boss_hp )
end

local wispnum = math.ceil( clamp( anger / 10 + 2, 6, 33 ) )

if ( wispnum > 0 ) then
	for i=1,wispnum do
		SetRandomSeed( GameGetFrameNum(), entity_id + i )

		local angle = Random( 1, 360 )
		local dx = math.cos( math.rad(angle) ) * Random( 1, 24 )
    	local dy = math.sin( math.rad(angle) ) * Random( 1, 24 )
		
		EntityAddChild( entity_id, EntityLoad( "data/entities/animals/boss_spirit/wisp.xml", x+dx, y+dy ) )
	end
end

EntityAddChild( entity_id, EntityLoad( "data/entities/misc/effect_berserk_once.xml" ) )