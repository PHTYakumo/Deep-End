dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum()+x, entity_id+y )

local laser_types = { "spark_red_bright", "spark_yellow", "spark_green", "spark_teal", "spark_electric", "spark_purple_bright", "material_rainbow"}
local laser_type = CellFactory_GetType( laser_types[Random( 1, #laser_types )] )

local laseremitter = EntityGetFirstComponentIncludingDisabled( entity_id, "LaserEmitterComponent" )
if( laseremitter ~= nil ) then
	ComponentObjectSetValue( laseremitter, "laser", "beam_particle_type", tostring(laser_type) )
end