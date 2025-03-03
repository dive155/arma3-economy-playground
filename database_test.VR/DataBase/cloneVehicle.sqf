fnc_cloneVehicle = {
	params ["_vehicle"];
	
	_vehicleData = [_vehicle] call fnc_getVehicleData;
	[_vehicleData] call fnc_createVehicleFromData;
};

fnc_getVehicleData = {
	params ["_vehicle"];
	
	_position = (getPosATL _vehicle) vectorAdd [20, 0, 0];
    _rotation = vectorDir _vehicle;
	_fuel = fuel _vehicle;
	_plate = getPlateNumber _vehicle;
	
	_rawVehData = [_vehicle, [missionNamespace, "db_tempVehSave"]] call BIS_fnc_saveVehicle;
	_className = _rawVehData select 0;
	
	// Default array is in a wrong format so we flatten it
	_rawAnimSources = _rawVehData select 1;
	_flatAnimSources = [];
	{
		_flatAnimSources pushBack (_x select 0);
		_flatAnimSources pushBack (_x select 1);
	} forEach _rawAnimSources;
	
	_textures = _rawVehData select 2;
	
	_damageStructural = damage _vehicle;
	_damageHitPointsTemp = getAllHitPointsDamage _vehicle;
	
	_damageHitPoints = if (count _damageHitPointsTemp < 3) then { [] } else {
		[_damageHitPointsTemp select 0, _damageHitPointsTemp select 2]
	};
	
	_cargo = _vehicle call fnc_db_getCargoData;
	
	_turretMagazines = magazinesAllTurrets _vehicle;
	
    _vehicleData = [
		_className,
		_position,
		_rotation,
		_fuel,
		_plate,
		_flatAnimSources,
		_textures,
		_damageStructural,
		_damageHitPoints,
		_cargo,
		_turretMagazines
	];
    _vehicleData
};

fnc_createVehicleFromData = {
	params ["_vehicleData"];
	_vehicleData params [
		"_className",
		"_position",
		"_rotation",
		"_fuel",
		"_plate",
		"_flatAnimSources",
		"_textures",
		"_damageStructural",
		"_damageHitPoints",
		"_cargo",
		"_turretMagazines"
	];
	
	_veh = createVehicle [_className, _position];
	[_veh, _rotation] remoteExec ["setVectorDir", _veh];
	[_veh, _fuel] remoteExec ["setFuel", _veh];
	[_veh, _plate] remoteExec ["setPlateNumber", _veh];
	
    [_veh, false, _flatAnimSources] remoteExec ["BIS_fnc_initVehicle", _veh];
	{
		_veh setObjectTextureGlobal [_forEachIndex, _x];
	} forEach _textures;
	
	[_veh, _damageStructural, _damageHitPoints] remoteExec ["fnc_applyDamageLocal", _veh];
	
	[_veh, _cargo] spawn fnc_db_loadCargoFromData;
	
	[_veh, _turretMagazines] spawn fnc_addTurretMagazinesLocal;
};

fnc_applyDamageLocal = {
	params ["_vehicle", "_damageStructural", "_damageHitPoints"];
	
	_vehicle setDamage [_damageStructural, false];
	
	if (count _damageHitPoints < 2) exitWith {};
	
	_hitPointNames = _damageHitPoints select 0;
	_hitPointDamageValues = _damageHitPoints select 1;

	{
		_damage = _hitPointDamageValues select _forEachIndex;
		_vehicle setHitPointDamage [_x, _damage, false];
	} forEach _hitPointNames;
};

fnc_addTurretMagazinesLocal = {
	params ["_vehicle", "_turretMagazines"];
	_vehicle setVehicleAmmo 0;
	
	if (count _turretMagazines == 0) exitWith {};
	
	// Without this hack weapons will be unloaded when the vehicle is spawned
	// Gathering all weapons and removing them
	_allWeapons = [];
	_allPaths = [[-1]] + allTurrets _vehicle;
	{
		_path = _x;
		_weapons = _vehicle weaponsTurret _path;
		_allWeapons pushBack [_path, _weapons];
		_owner = _vehicle turretOwner _path;
		
		{
			[_vehicle, [_x, _path]] remoteExec ["removeWeaponTurret", _owner]; ;
		} forEach _weapons;
	} forEach _allPaths;
	
	// Adding magazines
	{
		_magType = _x select 0;
		_path = _x select 1;
		_ammoCount = _x select 2;
		_owner = _vehicle turretOwner _path;
		
		[_vehicle, [_magType, _path, _ammoCount]] remoteExec ["addMagazineTurret", _owner];
	} forEach _turretMagazines;
	
	// Adding weapons back in
	{
		_path = _x select 0;
		_weapons = _x select 1;
		_owner = _vehicle turretOwner _path;
		
		{
			[_vehicle, [_x, _path]] remoteExec ["addWeaponTurret", _owner];
		} forEach _weapons;

	} forEach _allWeapons;
};