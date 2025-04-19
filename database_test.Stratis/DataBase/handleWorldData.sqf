params[
	["_saveDateTime", true],
	["_saveWeather", true]
];

dbWorldSaveDateTime = _saveDateTime;
dbWorldSaveWeather = _saveWeather;
dbWorldSectionName = "World";

DMP_fnc_saveWorldData = {
	_dbHandle = ["new", DMP_dbNameWorld] call OO_INIDBI;

	if (dbWorldSaveDateTime) then {
		["write", [dbWorldSectionName, "dateTime", date]] call _dbHandle;
		["write", [dbWorldSectionName, "timeMultiplier", timeMultiplier]] call _dbHandle;
	};
	
	if (dbWorldSaveWeather) then {
		["write", [dbWorldSectionName, "overcast", overcast]] call _dbHandle;
		["write", [dbWorldSectionName, "rain", rain]] call _dbHandle;
		["write", [dbWorldSectionName, "rainParams", rainParams]] call _dbHandle;
		["write", [dbWorldSectionName, "lightning", lightnings]] call _dbHandle;
		["write", [dbWorldSectionName, "rainbow", rainbow]] call _dbHandle;
		["write", [dbWorldSectionName, "waves", waves]] call _dbHandle;
		["write", [dbWorldSectionName, "wind", wind]] call _dbHandle;
		["write", [dbWorldSectionName, "gusts", gusts]] call _dbHandle;
		["write", [dbWorldSectionName, "fogParams", fogParams]] call _dbHandle;
		["write", [dbWorldSectionName, "humidity", humidity]] call _dbHandle;
	};
};

DMP_fnc_loadWorldData = {
	_dbHandle = ["new", DMP_dbNameWorld] call OO_INIDBI;

	_sections = "getSections" call _dbHandle;
	if not (dbWorldSectionName in _sections) exitWith { call DMP_fnc_saveWorldData; };

	if (dbWorldSaveDateTime) then {
		_dateTime = ["read", [dbWorldSectionName, "dateTime", date]] call _dbHandle;
		_timeMultiplier = ["read", [dbWorldSectionName, "timeMultiplier", timeMultiplier]] call _dbHandle;
		
		[_dateTime] call BIS_fnc_setDate;
		setTimeMultiplier _timeMultiplier;
	};
	
	if (dbWorldSaveWeather) then {
		_overcast = ["read", [dbWorldSectionName, "overcast", overcast]] call _dbHandle;
		_rain = ["read", [dbWorldSectionName, "rain", rain]] call _dbHandle;
		_rainParams = ["read", [dbWorldSectionName, "rainParams", rainParams]] call _dbHandle;
		_lightnings = ["read", [dbWorldSectionName, "lightning", lightnings]] call _dbHandle;
		_rainbow = ["read", [dbWorldSectionName, "rainbow", rainbow]] call _dbHandle;
		_waves = ["read", [dbWorldSectionName, "waves", waves]] call _dbHandle;
		_wind = ["read", [dbWorldSectionName, "wind", wind]] call _dbHandle;
		_gusts = ["read", [dbWorldSectionName, "gusts", gusts]] call _dbHandle;
		_fogParams = ["read", [dbWorldSectionName, "fogParams", fogParams]] call _dbHandle;	
		_humidity = ["read", [dbWorldSectionName, "humidity", humidity]] call _dbHandle;
		
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



// _forced, _overcast, _rain, _precipitationType, _lightning, _rainbow, _waves, _wind, _gusts, _fog
