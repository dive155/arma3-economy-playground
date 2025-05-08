if (!hasInterface) exitWith {};

_checkNumberPlate = {
	hint (getPlateNumber _target);
};

_checkNumberPlateAction = ["Check Numberplate", localize "STR_checkNumberPlate", "", _checkNumberPlate, {true}] call ace_interact_menu_fnc_createAction;

["LandVehicle", 0, ["ACE_MainActions"], _checkNumberPlateAction, true] call ace_interact_menu_fnc_addActionToClass;
["Ship", 0, ["ACE_MainActions"], _checkNumberPlateAction, true] call ace_interact_menu_fnc_addActionToClass;
["Air", 0, ["ACE_MainActions"], _checkNumberPlateAction, true] call ace_interact_menu_fnc_addActionToClass;

_checkRemainingFuel = {
	[4, [_target], {
		params["_args"];
		_target = _args select 0;
		
		_aceFuelCap = getNumber (configFile >> "CfgVehicles" >> typeOf _target >> "ace_refuel_fuelCapacity");
        _vanFuelCap = getNumber (configFile >> "CfgVehicles" >> typeOf _target >> "fuelCapacity");
		_fuelCapacity = if (_aceFuelCap != 0) then {_aceFuelCap} else {_vanFuelCap};
		_currentFuel = fuel _target;
		_remainingFuel = _fuelCapacity * _currentFuel;
		hint format [localize "STR_remainingFuel", _remainingFuel, _fuelCapacity];
	}, {}, (localize "STR_checkingRemainingFuel")] call ace_common_fnc_progressBar;
};

_checkRemainingFuelAction = ["Check Remaining Fuel", (localize "STR_checkRemainingFuel"), "", _checkRemainingFuel, {true}] call ace_interact_menu_fnc_createAction;

["LandVehicle", 0, ["ACE_MainActions"], _checkRemainingFuelAction, true] call ace_interact_menu_fnc_addActionToClass;
["Ship", 0, ["ACE_MainActions"], _checkRemainingFuelAction, true] call ace_interact_menu_fnc_addActionToClass;
["Air", 0, ["ACE_MainActions"], _checkRemainingFuelAction, true] call ace_interact_menu_fnc_addActionToClass;

fnc_modifyNumberPlate = {
	params ["_target"];
	private _initialPlate = getPlateNumber _target;
	[
		localize "STR_dive_pdr_edit_plate_title", [
			["EDIT", [localize "STR_dive_pdr_edit_plate_title", ""], [_initialPlate], true]
		], {
			params["_values","_arguments"];
			_object = _arguments select 0;
			
			_newPlate = _values select 0;
			
			[_object, _newPlate] remoteExec ["setPlateNumber", _object];
			
			hint format[localize "STR_dive_pdr_edit_plate_result", _newPlate];
			
		}, {}, [_target]
	] call zen_dialog_fnc_create;
};

_changeNumberPlateAction = ["ChangeNumberPlate", (localize "STR_dive_pdr_edit_plate_title"), "", fnc_modifyNumberPlate, {
	[player, "numberplateEditing"] call fnc_checkHasPermission
}] call ace_interact_menu_fnc_createAction;

["LandVehicle", 0, ["ACE_MainActions"], _changeNumberPlateAction, true] call ace_interact_menu_fnc_addActionToClass;
["Ship", 0, ["ACE_MainActions"], _changeNumberPlateAction, true] call ace_interact_menu_fnc_addActionToClass;
["Air", 0, ["ACE_MainActions"], _changeNumberPlateAction, true] call ace_interact_menu_fnc_addActionToClass;