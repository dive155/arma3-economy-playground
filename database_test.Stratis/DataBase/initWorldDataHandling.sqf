DMP_fnc_initWorldDataSaving = {
	params[
		["_saveDateTime", true],
		["_saveWeather", true]
	];

	DMP_dbWorldSaveDateTime = _saveDateTime;
	DMP_dbWorldSaveWeather = _saveWeather;
	DMP_dbWorldSectionName = "World";
};

DMP_fnc_saveWorldData = {
	_dbHandle = ["new", DMP_dbNameWorld] call OO_INIDBI;

	if (DMP_dbWorldSaveDateTime) then {
		["write", [DMP_dbWorldSectionName, "dateTime", date]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "timeMultiplier", timeMultiplier]] call _dbHandle;
	};
	
	if (DMP_dbWorldSaveWeather) then {
		["write", [DMP_dbWorldSectionName, "overcast", overcast]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "rain", rain]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "rainParams", rainParams]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "lightning", lightnings]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "rainbow", rainbow]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "waves", waves]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "wind", wind]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "gusts", gusts]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "fogParams", fogParams]] call _dbHandle;
		["write", [DMP_dbWorldSectionName, "humidity", humidity]] call _dbHandle;
	};
};

DMP_fnc_loadWorldData = {
	_dbHandle = ["new", DMP_dbNameWorld] call OO_INIDBI;

	_sections = "getSections" call _dbHandle;
	if not (DMP_dbWorldSectionName in _sections) exitWith { call DMP_fnc_saveWorldData; };

	if (DMP_dbWorldSaveDateTime) then {
		_dateTime = ["read", [DMP_dbWorldSectionName, "dateTime", date]] call _dbHandle;
		_timeMultiplier = ["read", [DMP_dbWorldSectionName, "timeMultiplier", timeMultiplier]] call _dbHandle;
		
		[_dateTime] call BIS_fnc_setDate;
		setTimeMultiplier _timeMultiplier;
	};
	
	if (DMP_dbWorldSaveWeather) then {
		_overcast = ["read", [DMP_dbWorldSectionName, "overcast", overcast]] call _dbHandle;
		_rain = ["read", [DMP_dbWorldSectionName, "rain", rain]] call _dbHandle;
		_rainParams = ["read", [DMP_dbWorldSectionName, "rainParams", rainParams]] call _dbHandle;
		_lightnings = ["read", [DMP_dbWorldSectionName, "lightning", lightnings]] call _dbHandle;
		_rainbow = ["read", [DMP_dbWorldSectionName, "rainbow", rainbow]] call _dbHandle;
		_waves = ["read", [DMP_dbWorldSectionName, "waves", waves]] call _dbHandle;
		_wind = ["read", [DMP_dbWorldSectionName, "wind", wind]] call _dbHandle;
		_gusts = ["read", [DMP_dbWorldSectionName, "gusts", gusts]] call _dbHandle;
		_fogParams = ["read", [DMP_dbWorldSectionName, "fogParams", fogParams]] call _dbHandle;	
		_humidity = ["read", [DMP_dbWorldSectionName, "humidity", humidity]] call _dbHandle;
		
		_values = [_overcast, _rain, _rainParams, _lightnings, _rainbow, _waves, _wind, _gusts, _fogParams, _humidity];
		[_values] remoteExec ["DMP_fnc_setWeatherLocal", 0];
		
		0 setOvercast _overcast;
		0 setLightnings _lightnings;
		0 setRainbow _rainbow;
		0 setWaves _waves;
		setWind [_wind select 0, _wind select 1, false];
		0 setGusts _gusts;
		0 setFog _fogparams;
		setHumidity _humidity;
		
		setRain _rainParams;
		0 setRain _rain;
		
		forceWeatherChange;
	};
};

DMP_fnc_setWeatherLocal = {
	params ["_values"];
	_values params [
		"_overcast", 
		"_rain",
		"_rainParams", 
		"_lightnings", 
		"_rainbow", 
		"_waves", 
		"_wind", 
		"_gusts", 
		"_fogParams",
		"_humidity"
	];
	
	0 setOvercast _overcast;
	0 setLightnings _lightnings;
	0 setRainbow _rainbow;
	0 setWaves _waves;
	setWind [_wind select 0, _wind select 1, false];
	0 setGusts _gusts;
	0 setFog _fogparams;
	setHumidity _humidity;
	
	setRain _rainParams;
	0 setRain _rain;
};