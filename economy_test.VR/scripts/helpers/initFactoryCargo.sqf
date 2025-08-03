// Define the action function
if (hasInterface) then {
	_factoryCargoProcess = {
		_this select 0 spawn {
			params ["_target"];

			private _button = _target;
			private _trigger = factory_cargo_trigger;
			private _cargoContainer = factory_cargo;

			playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss", _button, false, getPosASL _button, 1, 1, 0];

			sleep 1;

			private _vehiclesInTrigger = vehicles select {
				(_x isKindOf "LandVehicle") &&
				alive _x &&
				(_x inArea _trigger)
			};

			if (_vehiclesInTrigger isEqualTo []) exitWith {
				playSound3D ["pdrstuff\sounds\machine_error.ogg", _button, false, getPosASL _button, 1, 1, 40];
				hint localize "STR_cargo_error_no_vehicle";
			};

			private _vehicle = _vehiclesInTrigger select 0;

			private _dir = getDir _vehicle;
			if (_dir <= 335 || _dir >= 355) exitWith {
				playSound3D ["pdrstuff\sounds\machine_error.ogg", _button, false, getPosASL _button, 1, 1, 40];
				hint localize "STR_cargo_error_bad_alignment";
			};

			private _cargo = getBackpackCargo _vehicle;
			private _bags = ["b_dive_grain_bag", "b_dive_ore_bag"];
			private _foundBags = [];

			{
				private _index = _bags find _x;
				if (_index >= 0 && (_cargo select 0) find _x >= 0) then {
					_foundBags pushBack _x;
				};
			} forEach (_cargo select 0);

			if (_foundBags isEqualTo []) exitWith {
				playSound3D ["pdrstuff\sounds\machine_error.ogg", _button, false, getPosASL _button, 1, 1, 40];
				hint localize "STR_cargo_error_no_bags";
			};

			playSound3D ["pdrstuff\sounds\machine_success.ogg", _button, false, getPosASL _button, 1, 1, 40];

			{
				private _count = (_cargo select 1) select ((_cargo select 0) find _x);
				_vehicle addBackpackCargoGlobal [_x, -_count];
				_cargoContainer addBackpackCargoGlobal [_x, _count];
			} forEach _foundBags;

			hint localize "STR_cargo_success_transfer";
		};
	};

	_factoryCargoAction = [
		"ProcessFactoryCargo",
		localize "STR_cargo_action_process",
		"",
		_factoryCargoProcess,
		{true}
	] call ace_interact_menu_fnc_createAction;

	[factory_cargo_button, 0, [], _factoryCargoAction] call ace_interact_menu_fnc_addActionToObject;

};