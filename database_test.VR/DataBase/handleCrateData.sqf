fnc_db_loadCrateData = {
	params ["_crate"];
	_player_SaveDBLocal = ["new", dbNameCrates] call OO_INIDBI;
	_var = vehicleVarName _crate;

	// No data yet for this crate - skipping.
	_sections = "getSections" call _player_SaveDBLocal;
	if not (_var in _sections) exitWith {}; 

	_weapons = ["read",[_var, "crateWeapons",[]]] call _player_SaveDBLocal;
	_magazines = ["read",[_var, "crateMagazines",[]]] call _player_SaveDBLocal;
	_items = ["read",[_var, "crateItems",[]]] call _player_SaveDBLocal;
	_backpacks = ["read",[_var, "crateBackpacks",[]]] call _player_SaveDBLocal;
	
	_cargo = [_weapons, _magazines, _items, _backpacks];
	[_crate,_cargo] spawn KRV_loadCrate;
};

fnc_db_saveCrateData = {
	params ["_crate"];

	_cargo = _crate call KRV_saveCrate;
	_var = vehicleVarName _crate;
	_player_SaveDBLocal = ["new", dbNameCrates] call OO_INIDBI;
	
	_loadout = ["write", [_var, "crateWeapons", _cargo select 0]] call _player_SaveDBLocal;
	_loadout = ["write", [_var, "crateMagazines", _cargo select 1]] call _player_SaveDBLocal;
	_loadout = ["write", [_var, "crateItems", _cargo select 2]] call _player_SaveDBLocal;
	_loadout = ["write", [_var, "crateBackpacks", _cargo select 3]] call _player_SaveDBLocal;
};
