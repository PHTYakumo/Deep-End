dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local pcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )

if pcomp == nil then
	EntityKill(entity_id)
	return
end

local who_shot = ComponentGetValue2( pcomp, "mWhoShot")
local dcomp = EntityGetFirstComponent( who_shot, "DamageModelComponent" )

if dcomp == nil or EntityHasTag( who_shot, "wand_ghost" ) then
	EntityKill(entity_id)
	return
end

local x, y = EntityGetTransform( entity_id )
local px, py = EntityGetTransform( who_shot )

component_readwrite( dcomp, { hp = 0, max_hp = 0, }, function(dcomp)
	local enemies_killed = tonumber( StatsGetValue("enemies_killed") )
	local curse_id = EntityGetInRadiusWithTag( px, py, 278, "de_dark_curse" )

	local curse_dmg = dcomp.max_hp - dcomp.hp
	curse_dmg = clamp( curse_dmg * 0.4, 0.04 + enemies_killed * 0.01 * 0.16, 266.6664 )

    if ( #curse_id > 0 ) then
        for i = 1, #curse_id do
			local cx, cy = EntityGetFirstHitboxCenter(curse_id[i])

			if ( EntityHasTag( curse_id[i], "boss" ) ) or ( EntityHasTag( curse_id[i], "miniboss" ) ) or ( EntityHasTag( curse_id[i], "prey" ) ) then
				EntityInflictDamage( curse_id[i], math.min( curse_dmg * 0.4, 2.64), "DAMAGE_CURSE", "$damage_curse", "NONE", 0, 0, curse_id[i] )
			else
				EntityInflictDamage( curse_id[i], curse_dmg, "DAMAGE_CURSE", "$damage_curse", "NONE", 0, 0, who_shot )
			end

			GameCreateSpriteForXFrames( "data/ui_gfx/inventory/icon_danger.png", cx, cy, true, 0, 0, 6, false )

			if ( curse_id[i] == who_shot ) then
				EntityRemoveTag( curse_id[i], "de_dark_curse" )
			else
				GameScreenshake( clamp( curse_dmg * 2.5, 10, 150 ), cx, cy )
				curse_dmg = curse_dmg * 1.2
			end
		end
	end

	if GameGetFrameNum() - tonumber( GlobalsGetValue( "DEEP_END_SOUND_DARK_SWORD_CURSE_LAST_PLAY_FRAME" ) ) > 10 then
		GamePlaySound( "data/audio/Desktop/animals.bank", "animals/failed_alchemist_b_orb/explode", x, y )

		GlobalsSetValue( "DEEP_END_SOUND_DARK_SWORD_CURSE_LAST_PLAY_FRAME", tostring( GameGetFrameNum() ) )
	end
end)

EntityKill(entity_id)
