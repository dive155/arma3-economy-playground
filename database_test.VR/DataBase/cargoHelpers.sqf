KRV_saveCrate = {
	_crate = _this;
	_weapons = getWeaponCargo _crate;
	_magazines = getMagazineCargo _crate;
	_items = getItemCargo _crate;
	_backpacks = getBackpackCargo _crate;
	_cargo = [_weapons, _magazines, _items, _backpacks];
	_cargo
};

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