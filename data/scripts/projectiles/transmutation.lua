dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

EntitySetComponentsWithTagEnabled( entity_id, "transmutation", true )

local convertcomponents = EntityGetComponent( entity_id, "MagicConvertMaterialComponent" )

SetRandomSeed( pos_x + 436, pos_y - 3252 )
local material_options = 
	{ 
		"oil", "lava", "acid", 
		"radioactive_liquid", "slime","alcohol",
		"snow", "blood_worm", "blood_fungi", 
		"material_rainbow", "magic_liquid_faster_levitation_and_movement", "molut", 
		"diamond", "brass", "silver" 
	}
local material_options_rare = 
	{ 
		"cursed_liquid", "pus", "material_darkness", 
		"poo", "mammi", "urine", 
		"magic_liquid", "mimic_liquid"
	}
local rare = false

local rnd = Random( 1, 100 )

if ( rnd > 98 ) then
	rare = true
end

local material_string = "water"

if (rare == false) then
	rnd = Random( 1, #material_options )
	material = material_options[rnd]
else
	rnd = Random( 1, #material_options_rare )
	material = material_options_rare[rnd]
end
	
material = CellFactory_GetType( material )

if ( convertcomponents ~= nil ) then
	for key,comp_id in pairs(convertcomponents) do 
		local mat_name = ComponentGetValue2( comp_id, "from_material" )
		--local smoke_id = CellFactory_GetType( "smoke" )
		
		if (material == mat_name) then
			--ComponentSetValue( comp_id, "to_material", smoke_id )
		else
			ComponentSetValue( comp_id, "to_material", material )
		end
	end
end

edit_component( entity_id, "LuaComponent", function(comp,vars)
	EntitySetComponentIsEnabled( entity_id, comp, false )
end)