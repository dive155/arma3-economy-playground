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
	_damageHitPoints = [_damageHitPointsTemp select 0, _damageHitPointsTemp select 2];
	
	_cargo = _vehicle call fnc_db_getCargoData;
	
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
		_cargo
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
		"_cargo"
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
	
	[_veh, _cargo] call fnc_db_loadCargoFromData;
};

fnc_applyDamageLocal = {
	params ["_vehicle", "_damageStructural", "_damageHitPoints"];
	
	_vehicle setDamage [_damageStructural, false];
	
	_hitPointNames = _damageHitPoints select 0;
	_hitPointDamageValues = _damageHitPoints select 1;

	{
		_damage = _hitPointDamageValues select _forEachIndex;
		_vehicle setHitPointDamage [_x, _damage, false];
	} forEach _hitPointNames;
};