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
	
	_rawAnimSources = _rawVehData select 1;
	_flatAnimSources = [];
	{
		_flatAnimSources pushBack (_x select 0);
		_flatAnimSources pushBack (_x select 1);
	} forEach _rawAnimSources;
	
	_textures = _rawVehData select 2;

    _vehicleData = [
		_className,
		_position,
		_rotation,
		_fuel,
		_plate,
		_flatAnimSources,
		_textures
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
		"_textures"
	];
	
	_veh = createVehicle [_className, _position];
	[_veh, _rotation] remoteExec ["setVectorDir", _veh];
	[_veh, _fuel] remoteExec ["setFuel", _veh];
	[_veh, _plate] remoteExec ["setPlateNumber", _veh];
	
    [_veh, false, _flatAnimSources] remoteExec ["BIS_fnc_initVehicle", _veh];
	
	{
		_veh setObjectTextureGlobal [_forEachIndex, _x];
	} forEach _textures;
};