dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local pm_money_amount = 0
local pm_hp_amount = 0

if ( comps ~= nil ) then
	for i,comp in ipairs( comps ) do
		local n = ComponentGetValue2( comp, "name" )

		if ( n == "pm_money_amount" ) then
			pm_money_amount = ComponentGetValue2( comp, "value_float" )
		elseif ( n == "pm_hp_amount" ) then
			pm_hp_amount = ComponentGetValue2( comp, "value_float" )
		end
	end
end

local pid = EntityGetClosestWithTag( x, y, "player_unit")

if ( pid == nil ) then return end

local moneycomp = EntityGetFirstComponent( pid, "WalletComponent" )

if ( moneycomp ~= nil ) and ( pm_money_amount > 0 ) then
	local money = ComponentGetValue2( moneycomp, "money" )

	money = money + pm_money_amount
	ComponentSetValue2( moneycomp, "money", money )

	-- GamePlaySound( "data/audio/Desktop/player.bank", "player/pick_gold_sand", x, y )
end

local damagemodels = EntityGetComponent( pid, "DamageModelComponent" )

if ( damagemodels ~= nil ) and ( pm_hp_amount > 0 ) then
	for i,damagemodel in ipairs(damagemodels) do
		local max_hp = ComponentGetValue2( damagemodel, "max_hp" )
		local hp = ComponentGetValue2( damagemodel, "hp" )
		
		hp = math.min( hp + pm_hp_amount, max_hp )
		ComponentSetValue2( damagemodel, "hp", hp)
	end

	x, y = EntityGetTransform( pid )

	GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/create", x, y )
end