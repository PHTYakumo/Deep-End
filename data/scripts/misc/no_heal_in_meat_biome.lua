function biome_entered( new_biome_name, old_biome_name )
	if new_biome_name == "$biome_meat" and GlobalsGetValue( "BOSS_MEAT_DEAD", "0" ) == "0" and not ModSettingGet( "DEEP_END.MEAT_HEAL" ) then
		EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "effect_no_heal_in_meat_biome", true )
	else
		EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "effect_no_heal_in_meat_biome", false )
	end
end