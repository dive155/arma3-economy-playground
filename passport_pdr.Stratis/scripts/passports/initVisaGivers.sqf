call compile preprocessFileLineNumbers "scripts\passports\passportHelpers.sqf";

fn_setVisaStatusLocal = {
	params ["_player", "_countryName", "_visaStatus"];
	
	_visas = _player getVariable ["rp_visas", []];
	if (count _visas > 0) then {
		_visas = _visas select { _x select 0 != _countryName};
	};
	_visas pushBack [_countryName, _visaStatus];
	_player setVariable ["rp_visas", _visas];
	
	[_player] call fn_updateVisaInfo;
};

fn_addBorderCrossingLocal = {
	params ["_player", "_countryName", "_crossingIsEntry"];
	_crossings = _player getVariable ["rp_borderCrossings", []];
	_crossings pushBack [(call getDateText) + (call getTimeText), _countryName, _crossingIsEntry];
	_player setVariable ["rp_borderCrossings", _crossings];
	
	[_player] call fn_updateVisaInfo;
};

fn_applyVisaGiverPermissions = {
	params ["_player", "_countryName"];
	[_countryName] remoteExec ["fn_applyVisaGiverPermissionsLocal", _player];
};

fn_applyVisaGiverPermissionsLocal = {
	params ["_countryName"];
	
	if (isNil "visa_root_action") then {
		visa_root_action = ["VisaRoot",localize "STR_visaAction","",{nil},{true}] call ace_interact_menu_fnc_createAction;
		["CAManBase", 0, ["ACE_MainActions"], visa_root_action, true] call ace_interact_menu_fnc_addActionToClass;
	};
	
	_issueVisa = {
		params ["_target", "_player", "_actionParams"];
		_countryName = _actionParams select 0;
		
		[_target, _countryName, true] remoteExec ["fn_setVisaStatusLocal", _target];
		[_target] call notifyPassportChanged;
	};
	
	_revokeVisa = {
		params ["_target", "_player", "_actionParams"];
		_countryName = _actionParams select 0;
		
		[_target, _countryName, false] remoteExec ["fn_setVisaStatusLocal", _target];
		[_target] call notifyPassportChanged;
	};
	
	_putEntry = {
		params ["_target", "_player", "_actionParams"];
		_countryName = _actionParams select 0;
		
		[_target, _countryName, true] remoteExec ["fn_addBorderCrossingLocal", _target];
		[_target] call notifyPassportChanged;
	};
	
	_putExit = {
		params ["_target", "_player", "_actionParams"];
		_countryName = _actionParams select 0;
		
		[_target, _countryName, false] remoteExec ["fn_addBorderCrossingLocal", _target];
		[_target] call notifyPassportChanged;
	};
	
	_actionName = format [localize "STR_issueVisaActionFormat", localize ("STR_country" + _countryName)];
	_currentAction = ["IssueVisa" + _countryName, _actionName, "", _issueVisa, {true}, {}, [_countryName]] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _currentAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	_actionName = format [localize "STR_revokeVisaActionFormat", localize ("STR_country" + _countryName)];
	_currentAction = ["RevokeVisa" + _countryName, _actionName, "", _revokeVisa, {true}, {}, [_countryName]] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _currentAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	_actionName = format [localize "STR_putEntryActionFormat", localize ("STR_country" + _countryName)];
	_currentAction = ["PutEntry" + _countryName, _actionName, "", _putEntry, {true}, {}, [_countryName]] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _currentAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	_actionName = format [localize "STR_putExitActionFormat", localize ("STR_country" + _countryName)];
	_currentAction = ["PutExit" + _countryName, _actionName, "", _putExit, {true}, {}, [_countryName]] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "VisaRoot"], _currentAction, true] call ace_interact_menu_fnc_addActionToClass;
};