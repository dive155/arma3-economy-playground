// Subsystem initialization
_scriptHandle = execVM "scripts\stats\fatigueSystem.sqf";
waitUntil { scriptDone _scriptHandle };

hungerVarName = "rp_hunger";
//fatigueVarName = "rp_fatigue";
debtPdrVarName = "rp_debtPdr";
debtMoldovaVarName = "rp_debtMoldova";

// fnc_getPlayerFatigue = {
	// player getVariable [fatigueVarName, 0.0];
// };

// fnc_setPlayerFatigue = {
	// params ["_fatigue"];
	// player setVariable [fatigueVarName, _fatigue, true];
// };

fnc_showPlayerStats = {
	_ateToday = player getVariable [hungerVarName, false];
	_ateText = if ( _ateToday) then { (localize "STR_misc_yes") } else { (localize "STR_misc_no") };
	
	_result = format [
		(localize "STR_stats_text_format"),
		_ateText,
		(call fnc_getPlayerFatigue) * 100,
		player getVariable [debtPdrVarName, 100],
		player getVariable [debtMoldovaVarName, 10]
	];
	hint (_result);
};

_checkStatsAction = ["CheckOwnStats", localize "STR_check_stats_action", "", {call fnc_showPlayerStats}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _checkStatsAction] call ace_interact_menu_fnc_addActionToObject;

