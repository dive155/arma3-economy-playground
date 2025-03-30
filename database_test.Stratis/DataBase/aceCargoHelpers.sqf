fnc_db_getAceCargoData = {
	params ["_crate"];
	private _cargoRaw = _crate getVariable ["ace_cargo_loaded",[]];
	private _cargoSerialized = [];
	{
		if (typeName _x == "STRING") then {
			_cargoSerialized pushBack _x;
		} else {
			_cargo = [_x] call fnc_db_getCargoData;
			
			_fuelCargoData = [_x] call fnc_db_getAceFuelCargoData;
			
			_cargoSerialized pushBack [typeOf _x, getAllHitPointsDamage _x, _cargo,_fuelCargoData, _x getVariable ["ace_cargo_customName",""]];
		};
	} forEach _cargoRaw;

	_cargoSerialized
};

fnc_db_loadAceCargoFromData = {
	params ["_crate", "_serializedCargo"];
	_crate setVariable ["ace_cargo_loaded", []];
	_crate setVariable ["ace_cargo_space", [_crate] call ace_cargo_fnc_getCargoSpaceLeft,true];
	
	{
		private _cargo = "";
		if (typeName _x == "STRING") then {
			_cargo = _x;
			[_cargo, _crate, true] call ace_cargo_fnc_loadItem;
		} else {
			_x params ["_class","_damage","_objInventory","_fuelCargoData", "_customName"];
			private _cargo = _class createVehicle [0,0,0];
			
			if (_customName != "") then {
				_cargo setVariable ["ace_cargo_customName",_customName,true];
			};
			
			[_cargo,_objInventory] call fnc_db_loadCargoFromData;
			{
				_crate setHitPointDamage [_x,(_damage#2)#(_damage#0 find _x)];
			} forEach _damage#0;
			[_cargo, _crate, true] call ace_cargo_fnc_loadItem;
			
			[_cargo, _fuelCargoData] call fnc_db_setAceFuelCargo;
		};
	} forEach _serializedCargo;
};

fnc_db_getAceFuelCargoData = {
	params ["_veh"];
	_fuelCargoData = [];
	_currentFuelCargo = _veh getVariable "ace_refuel_currentfuelcargo";
	if not (isNil "_currentFuelCargo") then {
		_fuelCargoData = [
			_veh getVariable "ace_refuel_capacity",
			_veh getVariable "ace_refuel_currentfuelcargo"
		];
	};
	_fuelCargoData
};

fnc_db_setAceFuelCargo = {
	params["_veh", "_fuelCargoData"];

	if (count _fuelCargoData > 0) then {
		[_veh, _fuelCargoData] spawn {
			params ["_veh", "_fuelCargoData"];
			sleep 1;
			_veh setVariable ["ace_refuel_capacity", _fuelCargoData select 0, true];
			_veh setVariable ["ace_refuel_currentfuelcargo", _fuelCargoData select 1, true];
		};
	};
};