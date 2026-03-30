dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)

local comp = EntityGetFirstComponent( root_id, "SpriteStainsComponent" )
local compa = EntityGetFirstComponent( root_id, "PhysicsBodyComponent" )
local compb = EntityGetFirstComponent( root_id, "PhysicsShapeComponent" )
local compc = EntityGetFirstComponent( root_id, "SimplePhysicsComponent" )

if comp == nil or compa ~= nil or compb ~= nil or compc ~= nil then return end

local remove_frames = 20

if root_id ~= nil and root_id ~= NULL_ENTITY and ( EntityHasTag( root_id, "enemy" ) or EntityHasTag( root_id, "prey" ) ) and ( not EntityHasTag( root_id, "boss" ) ) then
	EntityRemoveStainStatusEffect( root_id, "RADIOACTIVE", remove_frames )
	EntityRemoveStainStatusEffect( root_id, "WET", remove_frames )
	EntityRemoveStainStatusEffect( root_id, "BLOODY", remove_frames )
	EntityRemoveStainStatusEffect( root_id, "SLIMY", remove_frames )
	EntityRemoveStainStatusEffect( root_id, "JARATE", remove_frames )
	-- GamePrint("On fire!")
end

EntityKill(entity_id)
