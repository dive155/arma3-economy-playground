fn_db_saveVehicleData = {
	params ["_vehicle"];
	
	_varName = vehicleVarName _vehicle;
	if (_varName == "") then {
		_varName = [_vehicle] call fnc_assignRandomVarName;
		waitUntil { (vehicleVarName _vehicle) != "" };
	};
	
	dbVehiclesToTrack pushBackUnique _vehicle;
	
	_vehicleData = _vehicle call fnc_getVehicleData;
	_section = _varName;
		
	_dbHandle = ["new", dbNameVehicles] call OO_INIDBI;
	
	["write", [_section, "varName", _vehicleData select 0]] call _dbHandle;
	["write", [_section, "className", _vehicleData select 1]] call _dbHandle;
	["write", [_section, "position", _vehicleData select 2]] call _dbHandle;
	["write", [_section, "rotation", _vehicleData select 3]] call _dbHandle;
	["write", [_section, "fuel", _vehicleData select 4]] call _dbHandle;
	
	["write", [_section, "plate", _vehicleData select 5]] call _dbHandle;
	["write", [_section, "flatAnimSources", _vehicleData select 6]] call _dbHandle;
	["write", [_section, "textures", _vehicleData select 7]] call _dbHandle;
	["write", [_section, "damageStructural", _vehicleData select 8]] call _dbHandle;
	
	["write", [_section, "damageHitPoints", _vehicleData select 9]] call _dbHandle;
	["write", [_section, "cargo", _vehicleData select 10]] call _dbHandle;
	["write", [_section, "turretMagazines", _vehicleData select 11]] call _dbHandle;
	["write", [_section, "pylons", _vehicleData select 12]] call _dbHandle;
};

fn_db_loadAllVehicles = {
	_dbHandle = ["new", dbNameVehicles] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	
	// Vehicles that we need to track but are not in the db
	{
		if not ((vehicleVarName _x) in _sections) then {
			_x call fn_db_saveVehicleData;
		};
	} forEach dbVehiclesToTrack;
	
	// Load the DB, add new elements to dbVehiclesToTrack
	{
		_exsistingVehicle = missionNamespace getVariable [_x, objNull];
		_vehicleData = [_x] call fn_db_loadVehicleData;
		[_vehicleData, _exsistingVehicle] call fnc_createVehicleFromData;
		
		_varName = _vehicleData select 0;
		waitUntil { not isNull (missionNamespace getVariable [_varName, objNull]) };
		
		dbVehiclesToTrack pushBackUnique (missionNamespace getVariable _varName);
	} forEach _sections;
};

fn_db_loadVehicleData = {
	params["_varName"];
	_dbHandle = ["new", dbNameVehicles] call OO_INIDBI;
	
	_varName = ["read", [_varName, "varName", ""]] call _dbHandle;
	_className = ["read", [_varName, "className", ""]] call _dbHandle;
	_position = ["read", [_varName, "position", [0,0,0]]] call _dbHandle;
	_rotation = ["read", [_varName, "rotation", [0,0,0]]] call _dbHandle;
	_fuel = ["read", [_varName, "fuel", 1]] call _dbHandle;
	
	_plate = ["read", [_varName, "plate", ""]] call _dbHandle;
	_flatAnimSources = ["read", [_varName, "flatAnimSources", []]] call _dbHandle;
	_textures = ["read", [_varName, "textures", []]] call _dbHandle;
	_damageStructural = ["read", [_varName, "damageStructural", 0]] call _dbHandle;
	
	_damageHitPoints = ["read", [_varName, "damageHitPoints", []]] call _dbHandle;
	_cargo = ["read", [_varName, "cargo", []]] call _dbHandle;
	_turretMagazines = ["read", [_varName, "turretMagazines", []]] call _dbHandle;
	_pylons = ["read", [_varName, "pylons", []]] call _dbHandle;
	
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
		_pylons
	];
    _vehicleData
};

fn_db_removeVehicleFromData = {
	params ["_vehicle"];
	_dbHandle = ["new", dbNameVehicles] call OO_INIDBI;
	_varName = vehicleVarName _vehicle;
	["deleteSection", vehicleVarName _vehicle] call _dbHandle;
	dbVehiclesToTrack = dbVehiclesToTrack  - [_vehicle];
};