DMP_dbLastUniqueId = 0;
DMP_fnc_generateUniqueID = {
    // Use time as the seed for the random number generator
    private _seed = time + DMP_dbLastUniqueId;

    // Generate a random number between 0 and a large value (e.g., 1 million)
    private _uniqueID = floor (_seed random 1000000);
	
	DMP_dbLastUniqueId = _uniqueID;
	
    _uniqueID
};

DMP_fnc_assignRandomVarName = {
	params ["_vehicle"];
	
	_prefix = typeOf _vehicle;
	_varName = "";
	while { true } do {
		_suffix = call DMP_fnc_generateUniqueID;
		_varName = _prefix + "_" + str(_suffix);
		
		// Make sure the name is unique
		_existingVar = missionNamespace getVariable [_varName, objNull];
		if (isNull _existingVar) exitWith {};
	};
	
	[_vehicle, _varName] remoteExec ["DMP_fnc_setVarName", 0];
	_varName;
};

DMP_fnc_getVehicleData = {
	params ["_vehicle"];
	_varName = vehicleVarName _vehicle;
	_position = getPosATL _vehicle;
    _rotation = vectorDir _vehicle;
	_className = typeOf _vehicle;
	
	_category = call DMP_fnc_getPersistenObjectCategory;
	
	_cargo = [];
	_damageStructural = damage _vehicle;
	
	// If not a Prop
	if (_category != 2) then {
		if (_damageStructural < 1) then {
			_cargo = _vehicle call DMP_fnc_getCargoData;
		};
	};
		
	_fuel = 0;
	_plate = "";
	_flatAnimSources = [];
	_textures = [];
	_damageHitPoints = [];
	_turretMagazines = [];
	_pylons = [];
	_aceCargo = [];
	_aceFuelCargo = [];

	// If it's a vehicle
	if (_category == 0) then {
		_fuel = fuel _vehicle;
		_plate = getPlateNumber _vehicle;
			
		_flatAnimSources = [];
		{
			_anim = configname _x;
			_flatAnimSources pushback _anim;
			_flatAnimSources pushback (_vehicle animationphase _anim);
		} foreach (configProperties [configfile >> "CfgVehicles" >> typeof _vehicle >> "animationSources","isclass _x",true]);

		_textures = getobjecttextures _vehicle;
		
		_damageHitPointsTemp = getAllHitPointsDamage _vehicle;
		
		_damageHitPoints = if (count _damageHitPointsTemp < 3) then { [] } else {
			[_damageHitPointsTemp select 0, _damageHitPointsTemp select 2]
		};
		
		_turretMagazines = [];
		_pylons = [];
		if (_damageStructural < 1) then {
			_turretMagazines = magazinesAllTurrets _vehicle;
			_pylons = getAllPylonsInfo _vehicle;
		};
		
		_aceCargo = [_vehicle] call DMP_fnc_getAceCargoData;
		//_aceFuelCargo = [_vehicle] call DMP_fnc_getAceFuelCargoData;
	};
	_aceFuelCargo = [_vehicle] call DMP_fnc_getAceFuelCargoData;
	
    _vehicleData = [
		_varName,
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
		_turretMagazines,
		_pylons,
		_aceCargo,
		_aceFuelCargo
	];
    _vehicleData
};

DMP_fnc_createVehicleFromData = {
	params ["_vehicleData", ["_existingVehicle", objNull]];
	_vehicleData params [
		"_varName",
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
		"_turretMagazines",
		"_pylons",
		"_aceCargo",
		"_aceFuelCargo"
	];
	
	_veh = _existingVehicle;
	if (isNull _veh) then { 
		_veh = createVehicle [_className, _position vectorAdd [0, 0, 500]];
		[_veh, _varName] remoteExec ["DMP_fnc_setVarName", 0];
	};
	_veh allowDamage false;
	
	[_veh, _varName] remoteExec ["DMP_fnc_setVarName", 0];
	[_veh, _vehicleData] remoteExec ["DMP_fnc_initializeExistingVehicleLocally", _veh];
};

DMP_fnc_initializeExistingVehicleLocally = {
	params ["_veh", "_vehicleData"];
	_vehicleData params [
		"_varName",
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
		"_turretMagazines",
		"_pylons",
		"_aceCargo",
		"_aceFuelCargo"
	];
	
	sleep 0.1;
	
	_veh setVectorDir _rotation;
	_veh setPosATL _position;	
	_veh setFuel _fuel;
	_veh setPlateNumber _plate;
	
    [_veh, false, _flatAnimSources] remoteExec ["BIS_fnc_initVehicle", _veh];
	{
		_veh setObjectTextureGlobal [_forEachIndex, _x];
	} forEach _textures;
	
	// TODO this bunch could be called without remoteExec but it crashes, fix later
	[_veh, _damageStructural, _damageHitPoints] remoteExec ["DMP_fnc_applyDamageLocal", _veh];
	
	_veh addEventHandler ["Deleted", DMP_fnc_handleVehicleDeleted];
	
	if (_damageStructural < 1) then {
		[_veh, _cargo] spawn DMP_fnc_loadCargoFromData;
		[_veh, _turretMagazines] call DMP_fnc_addTurretMagazines;
		[_veh, _aceCargo] call DMP_fnc_loadAceCargoFromData;
		[_veh, _aceFuelCargo] call DMP_fnc_setAceFuelCargo;
		
		sleep 1.5;
		
		[_veh, _pylons] spawn DMP_fnc_addVehiclePylons;
	};
};

DMP_fnc_applyDamageLocal = {
	params ["_vehicle", "_damageStructural", "_damageHitPoints"];
	
	sleep 4;
	_vehicle allowDamage true;
	
	_vehicle setDamage [_damageStructural, false];
	
	if (count _damageHitPoints < 2) exitWith {};
	
	_hitPointNames = _damageHitPoints select 0;
	_hitPointDamageValues = _damageHitPoints select 1;

	{
		_damage = _hitPointDamageValues select _forEachIndex;
		_vehicle setHitPointDamage [_x, _damage, false];
	} forEach _hitPointNames;
};

DMP_fnc_addTurretMagazines = {
	params ["_vehicle", "_turretMagazines"];
	_vehicle setVehicleAmmo 0;
	
	if (count _turretMagazines == 0) exitWith {};
	
	// Without this hack weapons would have unloaded mags when the vehicle is spawned
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
		
		_mags = _vehicle magazinesTurret _path;
		{
			[_vehicle, [_x, _path]] remoteExec ["removeMagazinesTurret", _owner];
		} forEach _mags;
		
	} forEach _allPaths;
	sleep 0.5;
	
	// Adding magazines
	{
		_magType = _x select 0;
		_path = _x select 1;
		_ammoCount = _x select 2;
		_owner = _vehicle turretOwner _path;
		
		[_vehicle, [_magType, _path, _ammoCount]] remoteExec ["addMagazineTurret", _owner];
	} forEach _turretMagazines;
	sleep 0.5;
	
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

DMP_fnc_addVehiclePylons = {
	params ["_vehicle", "_pylonsData"];
	
	if (count _pylonsData == 0) exitWith {};
	
	{
		_pylonId = _x select 0;
		_path = _x select 2;
		_magazine = _x select 3;
		_ammo = _x select 4;
		
		[_vehicle, [_pylonId, _magazine, false, _path]] remoteExec ["setPylonLoadout", _vehicle];
		sleep 0.5;
		[_vehicle, [_pylonId, _ammo]] remoteExec ["setAmmoOnPylon", _vehicle];
		
	} forEach _pylonsData;
};