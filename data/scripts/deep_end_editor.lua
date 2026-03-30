dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/de_input.lua")

local do_edit = de_key_judge( ModSettingGet( "DEEP_END.QOL_KEY_1" ), -9999 )
do_edit = do_edit or de_key_judge( ModSettingGet( "DEEP_END.QOL_KEY_2" ), -9999 )
do_edit = do_edit and not ( InputIsMouseButtonDown(1) or InputIsMouseButtonDown(2) )

if do_edit then EntitySetComponentsWithTagEnabled( GetUpdatedEntityID(), "deep_end_qol_script", true ) end