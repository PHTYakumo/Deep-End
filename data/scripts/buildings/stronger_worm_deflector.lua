dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local radius = 300

local targets = EntityGetInRadiusWithTag( x, y, radius, "worm" )
local targets2 = EntityGetInRadiusWithTag( x, y, radius, "lukki" )
local targets3 = EntityGetInRadiusWithTag( x, y, radius, "cell_eater_powder_created" )

if #targets > 0 then for i,v in ipairs( targets ) do
	-- ComponentAddTag( EntityAddComponent( v, "VariableStorageComponent", { name = "worm_smaller_holes", } ), "worm_smaller_holes" )
	
	local cecomp = EntityGetFirstComponent( v, "CellEaterComponent" )
	if cecomp ~= nil then ComponentSetValue2( cecomp, "only_stain", true ) end

	local tx, ty = EntityGetTransform( v )
	tx = tx - x

	edit_component( v, "WormComponent", function(vcomp,vars)
		mTargetVec = tx, 0
		mSpeed = 350
	end )
end end

if #targets2 > 0 then for i,v in ipairs( targets2 ) do
	-- ComponentAddTag( EntityAddComponent( v, "VariableStorageComponent", { name = "worm_smaller_holes", } ), "worm_smaller_holes" )
	
	local cecomp = EntityGetFirstComponent( v, "CellEaterComponent" )
	if cecomp ~= nil then ComponentSetValue2( cecomp, "eat_probability", 5 ) end

	local tx, ty = EntityGetTransform( v )
	tx, ty = tx - x, ty - y

	PhysicsApplyForce( v, tx * 2, ty * 2 )
end end

if #targets3 > 0 then for i,v in ipairs( targets3 ) do
	EntityKill( v )
end end