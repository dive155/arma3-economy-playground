KRV_loadCrate = {
	_crate = _this select 0;
	_cargo = _this select 1;
	_weapons = _cargo select 0;
	_ammo = _cargo select 1;
	_items = _cargo select 2;
	_backpacks = _cargo select 3;
	
	clearWeaponCargoGlobal _crate;
	for "_i" from 0 to ((count (_weapons select 0)) - 1) do {
		_crate addWeaponCargoGlobal [((_weapons select 0) select _i), ((_weapons select 1) select _i)];
	};
	
	clearMagazineCargoGlobal _crate;
	for "_i" from 0 to ((count (_ammo select 0)) - 1) do {
		_crate addMagazineCargoGlobal [((_ammo select 0) select _i), ((_ammo select 1) select _i)];
	};
	
	clearItemCargoGlobal _crate;
	for "_i" from 0 to ((count (_items select 0)) - 1) do {
		_crate addItemCargoGlobal [((_items select 0) select _i), ((_items select 1) select _i)];
	};
	
	clearBackpackCargoGlobal _crate;
	for "_i" from 0 to ((count (_backpacks select 0)) - 1) do {
		_crate addBackpackCargoGlobal [((_backpacks select 0) select _i), ((_backpacks select 1) select _i)];
	};
};

fnc_db_loadCrateData = {
	params ["_crate"];
	_player_SaveDBLocal = ["new", dbNameCrates] call OO_INIDBI;
	_var = vehicleVarName _crate;

	// No data yet for this crate - skipping.
	_sections = "getSections" call _player_SaveDBLocal;
	if not (_var in _sections) exitWith {}; 

	_inv = ["read",[_var, "allCrateItems",[]]] call _player_SaveDBLocal;

	[_crate,_inv] spawn KRV_loadCrate;
};