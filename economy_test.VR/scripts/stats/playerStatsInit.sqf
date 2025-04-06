// Subsystem initialization
_scriptHandle = execVM "scripts\stats\fatigueSystem.sqf";
waitUntil { scriptDone _scriptHandle };

debtPdrVarName = "rp_debtPdr";
debtMoldovaVarName = "rp_debtMoldova";

fnc_showPlayerStats = {
	_result = format [
		(localize "STR_stats_text_format"),
		[player] call fnc_getDaysSinceLastMeal,
		[player] call fnc_getPlayerFatigue,
		[player] call fnc_getFatigueCapacity,
		player getVariable [debtPdrVarName, 100],
		player getVariable [debtMoldovaVarName, 10]
	];
	hint (_result);
};

_checkStatsAction = ["CheckOwnStats", localize "STR_check_stats_action", "", {call fnc_showPlayerStats}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _checkStatsAction] call ace_interact_menu_fnc_addActionToObject;

_scriptHandle = execVM "scripts\stats\permissionsSystem.sqf";
_scriptHandle = execVM "scripts\stats\hungerSystem.sqf";