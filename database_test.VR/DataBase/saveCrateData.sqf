KRV_saveCrate = {
	_crate = _this;
	_weapons = getWeaponCargo _crate;
	_magazines = getMagazineCargo _crate;
	_items = getItemCargo _crate;
	_backpacks = getBackpackCargo _crate;
	_cargo = [_weapons, _magazines, _items, _backpacks];
	_cargo
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
