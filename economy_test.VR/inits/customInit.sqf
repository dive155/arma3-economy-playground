_scriptHandle = execVM "hud\initLongTextDialog.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initJournalPresenters.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initVideoPlayers.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initBooks.sqf";
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

_scriptHandle = execVM "scripts\helpers\party\initParty.sqf";
waitUntil { scriptDone _scriptHandle };

if (hasInterface) then {
	// Collect all existing offroad_safe_N objects
	private _offroadSafes = [];
	private _index = 1;
	private _obj = objNull;

	while {
		_obj = missionNamespace getVariable [format ["offroad_safe_%1", _index], objNull];
		!isNull _obj
	} do {
		_offroadSafes pushBack _obj;
		_index = _index + 1;
	};

	// Execute the script with dynamically found objects
	private _scriptHandle = [
		{["offroadDamage"] call fnc_getWorldVariable},
		_offroadSafes
	] execVM "scripts\helpers\initOffroading.sqf";

	waitUntil { scriptDone _scriptHandle };
};