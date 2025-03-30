fnc_db_getAceCargoData = {
	params ["_crate"];
	private _cargoRaw = _crate getVariable ["ace_cargo_loaded",[]];
	private _cargoSerialized = [];
	{
		if (_x isEqualType "") then {
			_cargoSerialized pushBack _x;
		} else {
			_cargo = [_x] call fnc_db_getCargoData;
			_cargoSerialized pushBack [typeOf _x, getAllHitPointsDamage _x, _cargo,_x getVariable ["ace_cargo_customName",nil]];
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
			_x params ["_class","_damage","_objInventory","_customName"];
			private _cargo = _class createVehicle [0,0,0];
			_cargo setVariable ["ace_cargo_customName",_customName,true];
			[_cargo,_objInventory] call fnc_db_loadCargoFromData;
			{
				_crate setHitPointDamage [_x,(_damage#2)#(_damage#0 find _x)];
			} forEach _damage#0;
			[_cargo, _crate, true] call ace_cargo_fnc_loadItem;
		};
	} forEach _serializedCargo;
};