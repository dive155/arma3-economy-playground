DMP_fnc_getAceCargoData = {
	params ["_crate"];
	private _cargoRaw = _crate getVariable ["ace_cargo_loaded",[]];
	private _cargoSerialized = [];
	{
		if (typeName _x == "STRING") then {
			_cargoSerialized pushBack _x;
		} else {
			_cargo = [_x] call DMP_fnc_getCargoData;
			
			_fuelCargoData = [_x] call DMP_fnc_getAceFuelCargoData;
			
			_cargoSerialized pushBack [
				typeOf _x, 
				getAllHitPointsDamage _x, 
				_cargo,_fuelCargoData, 
				_x getVariable ["ace_cargo_customName",""],
				_x getVariable ["dbCargoPersistentVarname", ""]
			];
		};
	} forEach _cargoRaw;

	_cargoSerialized
};

DMP_fnc_loadAceCargoFromData = {
	params ["_crate", "_serializedCargo"];
	_crate setVariable ["ace_cargo_loaded", []];
	_crate setVariable ["ace_cargo_space", [_crate] call ace_cargo_fnc_getCargoSpaceLeft,true];
	
	{
		private _cargo = "";
		if (typeName _x == "STRING") then {
			_cargo = _x;
			[_cargo, _crate, true] call ace_cargo_fnc_loadItem;
		} else {
			_x params ["_class","_damage","_objInventory","_fuelCargoData", "_customName", "_persistentVarName"];
			private _cargo = _class createVehicle [0,0,0];
			
			if (_customName != "") then {
				_cargo setVariable ["ace_cargo_customName",_customName,true];
			};
			
			[_cargo,_objInventory] call DMP_fnc_loadCargoFromData;
			{
				_crate setHitPointDamage [_x,(_damage#2)#(_damage#0 find _x)];
			} forEach _damage#0;
			[_cargo, _crate, true] call ace_cargo_fnc_loadItem;
			
			[_cargo, _fuelCargoData] call DMP_fnc_setAceFuelCargo;
			
			if (_persistentVarName != "") then {
				//systemChat ("found persistent cargo varname " + _persistentVarName);
				_exsistingVehicle = missionNamespace getVariable [_persistentVarName, objNull];
				if not isNull _exsistingVehicle then {
					//systemChat ("removing existing from the world " + _persistentVarName);
					deleteVehicle _exsistingVehicle;
				};
				
				_cargo setVehicleVarName _persistentVarName;
				missionNamespace setVariable [_persistentVarName, _cargo];
				_cargo setVariable ["dbCargoPersistentVarname", _varName, true];
			};
		};
	} forEach _serializedCargo;
};

DMP_fnc_getAceFuelCargoData = {
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

DMP_fnc_setAceFuelCargo = {
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

DMP_fnc_addAceCargoHandlers = {
	["ace_cargoLoaded", {
		params ["_item", "_vehicle"];
		//systemChat ("loaded cargo");
		if (_item in dbVehiclesToTrack) then {
			_varName = vehicleVarName _item;
			_item setVariable ["dbCargoPersistentVarname", _varName, true];
			[_item] call DMP_fnc_removeVehicleFromData;
			//systemChat ("cargo persistent, removing from db varname " + _varName);
			[_vehicle] spawn DMP_fnc_saveVehicleData;
		};
		
	}] call CBA_fnc_addEventHandler;

	["ace_cargoUnloaded", {
		params ["_item", "_vehicle", "_unloadType"];
		
		//systemChat ("unloaded cargo");
		_persistentVarName = _item getVariable ["dbCargoPersistentVarname", ""];
		if (_persistentVarName != "") then {
			//systemChat ("cargo persistent, saving to db varname " + _varName);
			[_item] spawn DMP_fnc_saveVehicleData;
		};
		
	}] call CBA_fnc_addEventHandler;
};