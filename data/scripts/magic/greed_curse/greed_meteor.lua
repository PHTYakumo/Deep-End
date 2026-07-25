dofile_once( "data/scripts/lib/utilities.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
local golds = EntityGetInRadiusWithTag( x, y, 40, "gold_nugget" )

if #golds > 0 then
	local gold_scale, money = "50", 50

	for i=1,#golds do
		local components = EntityGetComponent( golds[i], "VariableStorageComponent" )
		
		if components ~= nil then for key,comp_id in pairs(components) do if ComponentGetValue( comp_id, "name" ) == "gold_value" then
			local value = ComponentGetValueInt( comp_id, "value_int" ) or 10

			if value < 25000 then
				money = money + value
				EntityKill( golds[i] )
			end

			break
		end end end
	end

	if money >= 500 then money = money * 1.5 end
	money = money * 2 -- 50, 200, 500, 1650, 5100, 15450, 46500

	if money > 20000 then
		gold_scale = "200000"
	elseif money > 3000 then
		gold_scale = "10000"
	elseif money > 500 then
		gold_scale = "1000"
		elseif money > 200 then
		gold_scale = "200"
	end

	local eid = EntityLoad( "data/entities/items/pickup/bloodmoney_" .. gold_scale .. ".xml", x, y )
	local components = EntityGetComponent( eid, "VariableStorageComponent" )
		
	if components ~= nil then for key,comp_id in pairs(components) do 
		if ComponentGetValue( comp_id, "name" ) == "gold_value" then
			ComponentSetValue2( comp_id, "value_int", math.ceil( money - 0.5 ) )
		elseif ComponentGetValue( comp_id, "name" ) == "hp_value" then
			ComponentSetValue2( comp_id, "value_int", money * 0.02 )
		end
	end end
else
	local circle, how_many = math.pi * 2, 5
	local dir = circle / how_many

	for i=0,how_many-1 do
		local ox, oy = x + math.cos(i*dir) * 5, y - math.sin(i*dir) * 5
		EntityLoad( "data/entities/items/pickup/bloodmoney_10.xml", ox, oy )
	end
end