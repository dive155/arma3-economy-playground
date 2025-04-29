getDateText = {
	_curDate = date;
	_ddMMyyyy = format ["%2.%1",
		(if (_curDate select 1 < 10) then { "0" } else { "" }) + str (_curDate select 1),
		(if (_curDate select 2 < 10) then { "0" } else { "" }) + str (_curDate select 2)
	];
	_ddMMyyyy
};

getTimeText = {
	_timeText = [dayTime, "HH:MM"] call BIS_fnc_timeToString;
	_timeText = " (" + _timeText + ")";
	_timeText
};

notifyPassportChanged = {
	params ["_receiver"];
	
	if (_receiver != player) then {
		hint "Внёс изменения в паспорт игрока";
	};
	["В ваш паспорт внесены изменения"] remoteExec ["hint", _receiver];
};

cacheTarget = {
	params ["_toCache"];
	player setVariable ["cachedTarget", _toCache, true];
};

loadCachedTarget = {
	_cachedTarget = player getVariable ["cachedTarget", objNull];
	_cachedTarget
};

fn_hintLocalized = {
	params ["_key", ["_formatArgs", []]];
	private _value = localize _key;
	
	if (count _formatArgs > 0) then {
		_formatArgs = [_value] append _formatArgs;
		_value = format _formatArgs;
	};
	
	hint _value;
};

fn_rpIsNumber = {
	(_this) regexMatch "^-?[0-9]+(\.[0-9]+)?$"
};

fn_createPassportEditingRootAction = {
	// Add the root menu if not already created
	if (isNil "passport_edit_root_action") then {
		passport_edit_root_action = [
			"PassportEditRoot",
			localize "STR_passportEditCategory",
			"",
			{nil},
			{ true }
		] call ace_interact_menu_fnc_createAction;

		["CAManBase", 0, ["ACE_MainActions"], passport_edit_root_action, true] call ace_interact_menu_fnc_addActionToClass;
	};
};

fn_addPlayerPermLocal = {
	params ["_perm"];
	
	// Add permission to caller
	private _perm = "passportEditing" + _countryName;

	if (isNil {player getVariable "rp_permissions"}) then {
		player setVariable ["rp_permissions", [], true];
	};
	private _perms = player getVariable "rp_permissions";
	if (!(_perm in _perms)) then {
		_perms pushBack _perm;
		player setVariable ["rp_permissions", _perms, true];
	};
};

fnc_setPassportVariablesBulk = {
    params ["_unit", "_variables"];

    if ( not (_unit getVariable ["defaultPassportInitialized", false] )) then {
        {
            private _varName = _x select 0;
            private _value = _x select 1;
            _unit setVariable [_varName, _value, true];
        } forEach _variables;

        _unit setVariable ["defaultPassportInitialized", true, true];
    };
};

fnc_getCitizenship = {
	params ["_passportCode"];
	
	//remove "passport" prefix
	_passportCode select [8]
};