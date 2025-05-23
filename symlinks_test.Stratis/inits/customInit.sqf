_scriptHandle = execVM "hud\initLongTextDialog.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initJournalPresenters.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initVideoPlayers.sqf";
waitUntil { scriptDone _scriptHandle };

// if (hasInterface) then {
	// rp_root_self_action = ["RpSelfRoot",localize "STR_rp_root_self_action","",{nil},{true}] call ace_interact_menu_fnc_createAction;
	// [player, 1, ["ACE_SelfActions"], rp_root_self_action] call ace_interact_menu_fnc_addActionToObject;
// };

if (hasInterface) then {
	rp_root_self_action = ["RpSelfRoot",localize "STR_rp_root_self_action","hud\pdr_module.paa",{0 spawn fnc_showOwnRpInfo;},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], rp_root_self_action] call ace_interact_menu_fnc_addActionToObject;
};

_scriptHandle = execVM "scripts\initEconomy.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\tramController.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initStreetLights.sqf";
waitUntil { scriptDone _scriptHandle };