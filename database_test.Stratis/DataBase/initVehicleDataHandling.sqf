DMP_fnc_saveVehicleData = {
	params ["_vehicle", ["_addDeleteEventHandler", true]];
	
	_varName = vehicleVarName _vehicle;
	if (_varName == "") then {
		_varName = [_vehicle] call DMP_fnc_assignRandomVarName;
		waitUntil { (vehicleVarName _vehicle) != "" };
	};
	
	DMP_dbVehiclesToTrack pushBackUnique _vehicle;
	publicVariable "DMP_dbVehiclesToTrack";
	
	if (speed _vehicle > 1) exitWith {};
	
	_vehicleData = _vehicle call DMP_fnc_getVehicleData;
	
	if (_varName == "") exitWith {diag_log "Can't save vehicle with empty varname"; };
	
	_section = _varName;
	_dbHandle = ["new", DMP_dbNameVehicles] call OO_INIDBI;
	
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
	["write", [_section, "aceCargo", _vehicleData select 13]] call _dbHandle;
	["write", [_section, "aceFuelCargo", _vehicleData select 14]] call _dbHandle;
	
	if (_addDeleteEventHandler) then {
		_vehicle addEventHandler ["Deleted", DMP_fnc_handleVehicleDeleted];
	};
};

DMP_fnc_loadAllVehicles = {
	_dbHandle = ["new", DMP_dbNameVehicles] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	
	// Vehicles that we need to track but are not in the db
	{
		if not ((vehicleVarName _x) in _sections) then {
			[_x, false] call DMP_fnc_saveVehicleData;
		};
	} forEach DMP_dbVehiclesToTrack;
	
	// Load the DB, add new elements to DMP_dbVehiclesToTrack
	{
		_exsistingVehicle = missionNamespace getVariable [_x, objNull];
		_vehicleData = [_x] call DMP_fnc_loadVehicleData;
		[_vehicleData, _exsistingVehicle] call DMP_fnc_createVehicleFromData;
		
		_varName = _vehicleData select 0;
		waitUntil { not isNull (missionNamespace getVariable [_varName, objNull]) };
		
		DMP_dbVehiclesToTrack pushBackUnique (missionNamespace getVariable _varName);
	} forEach _sections;
	publicVariable "DMP_dbVehiclesToTrack";
};

DMP_fnc_loadVehicleData = {
	params["_varName"];
	_dbHandle = ["new", DMP_dbNameVehicles] call OO_INIDBI;
	
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
	_aceCargo = ["read", [_varName, "aceCargo", []]] call _dbHandle;
	_aceFuelCargo = ["read", [_varName, "aceFuelCargo", []]] call _dbHandle;
	
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

DMP_fnc_handleVehicleDeleted = {
	params ["_entity"];
	
	if (isServer) then {
		//systemChat ("Removing from db: " + str(_entity));
		_entity call DMP_fnc_removeVehicleFromData;
	};
};

DMP_fnc_removeVehicleFromData = {
	params ["_vehicle"];
	_dbHandle = ["new", DMP_dbNameVehicles] call OO_INIDBI;
	_varName = vehicleVarName _vehicle;
	["deleteSection", vehicleVarName _vehicle] call _dbHandle;
	DMP_dbVehiclesToTrack = DMP_dbVehiclesToTrack  - [_vehicle];
	publicVariable "DMP_dbVehiclesToTrack";
};