fnc_db_saveCrateData = {
	params ["_crate"];

	_cargoData = _crate call fnc_db_getCargoData;
	_var = vehicleVarName _crate;
	_player_SaveDBLocal = ["new", dbNameCrates] call OO_INIDBI;
	
	_loadout = ["write", [_var, "crateCargo", _cargoData select 0]] call _player_SaveDBLocal;
	_loadout = ["write", [_var, "crateContainers", _cargoData select 1]] call _player_SaveDBLocal;
};


fnc_db_loadCrateData = {
	params ["_crate"];
	_player_SaveDBLocal = ["new", dbNameCrates] call OO_INIDBI;
	_var = vehicleVarName _crate;

	// No data yet for this crate - save instead.
	_sections = "getSections" call _player_SaveDBLocal;
	if not (_var in _sections) exitWith { _crate spawn fnc_db_saveCrateData; };
	
	_cargoData = ["read",[_var, "crateCargo",[]]] call _player_SaveDBLocal;
	_containerData = ["read",[_var, "crateContainers",[]]] call _player_SaveDBLocal;
	
	[_crate, [_cargoData, _containerData]] spawn fnc_db_loadCargoFromData;
};