KRV_saveCrate = {
	_crate = _this;
	_weapons = getWeaponCargo _crate;
	_ammo = getMagazineCargo _crate;
	_items = getItemCargo _crate;
	_backpacks = getBackpackCargo _crate;
	_cargo = [_weapons, _ammo, _items, _backpacks];
	_cargo
};

fnc_db_saveCrateData = {
	params ["_crate"];

	_cargo = _crate call KRV_saveCrate;
	_var = vehicleVarName _crate;
	_player_SaveDBLocal = ["new", dbNameCrates] call OO_INIDBI;
	_loadout = ["write", [_var, "allCrateItems", _cargo]] call _player_SaveDBLocal;
};
