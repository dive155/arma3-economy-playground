if (!hasInterface) exitWith {};

_checkNumberPlate = {
	hint (getPlateNumber _target);
};

_checkNumberPlateAction = ["Check Numberplate", localize "STR_checkNumberPlate", "", _checkNumberPlate, {true}] call ace_interact_menu_fnc_createAction;

["AllVehicles", 0, ["ACE_MainActions"], _checkNumberPlateAction, true] call ace_interact_menu_fnc_addActionToClass;

_checkRemainingFuel = {
	[4, [_target], {
		params["_args"];
		_target = _args select 0;
		_fuelCapacity = getNumber (configFile >> "CfgVehicles" >> typeOf _target >> "ace_refuel_fuelCapacity");
		_currentFuel = fuel _target;
		_remainingFuel = _fuelCapacity * _currentFuel;
		hint format [localize "STR_remainingFuel", _remainingFuel, _fuelCapacity];
	}, {}, (localize "STR_checkingRemainingFuel")] call ace_common_fnc_progressBar;
};

_checkRemainingFuelAction = ["Check Remaining Fuel", (localize "STR_checkRemainingFuel"), "", _checkRemainingFuel, {true}] call ace_interact_menu_fnc_createAction;

["AllVehicles", 0, ["ACE_MainActions"], _checkRemainingFuelAction, true] call ace_interact_menu_fnc_addActionToClass;