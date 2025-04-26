// Subsystem initialization
_scriptHandle = execVM "scripts\stats\fatigueSystem.sqf";
waitUntil { scriptDone _scriptHandle };

fnc_showPlayerStats = {
	private _debts = player getVariable ["rp_debts", []];
	private _pdrDebt = 0;
	private _moldovaDebt = 0;

	{
		switch (_x select 0) do {
			case "PDR": { _pdrDebt = _x select 1 };
			case "Moldova": { _moldovaDebt = _x select 1 };
		};
	} forEach _debts;

	private _result = format [
		(localize "STR_stats_text_format"),
		[player] call fnc_getDaysSinceLastMeal,
		[player] call fnc_getPlayerFatigue,
		[player] call fnc_getFatigueCapacity,
		_pdrDebt,
		_moldovaDebt
	];

	hint _result;
};

_checkStatsAction = ["CheckOwnStats", localize "STR_check_stats_action", "", {call fnc_showPlayerStats}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "RpSelfRoot"], _checkStatsAction] call ace_interact_menu_fnc_addActionToObject;

_scriptHandle = execVM "scripts\stats\permissionsSystem.sqf";
_scriptHandle = execVM "scripts\stats\hungerSystem.sqf";
_scriptHandle = execVM "scripts\stats\debtJournal.sqf";