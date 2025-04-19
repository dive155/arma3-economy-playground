params [
	["_dbNameRoot", "DefaultDatabase"],
	["_saveInterval", 60],
	["_useIn3DEN", true],
	["_saveDate", true],
	["_saveWeather", true],
	["_vehicles", []],
	["_playerVarNames", []]
];

call compile preprocessFileLineNumbers "dataBase\serverHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\cargoHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\vehicleHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\handleVehicleData.sqf";
call compile preprocessFileLineNumbers "dataBase\handlePlayerData.sqf";
call compile preprocessFileLineNumbers "dataBase\aceCargoHelpers.sqf";
[_saveDate, _saveWeather] call compile preprocessFileLineNumbers "dataBase\handleWorldData.sqf";
call compile preprocessFileLineNumbers "dataBase\handlePersistentVars.sqf";
call compile preprocessFileLineNumbers "dataBase\handleJournals.sqf";
call compile preprocessFileLineNumbers "dataBase\miscHelpers.sqf";

_is3DEN = is3DENPreview;
DMP_shouldUseDB = not _is3DEN or (_is3DEN and _useIn3DEN);

if not DMP_shouldUseDB exitWith { 
	systemChat "Skipping persistent inventory initServer because 3Den preview mode detected"; 
};

// Compose full database names for this specific game instance
// Split development database and production database for safety
_environmentPrefix = if (_is3DEN) then { "DEV_" } else { "PROD_" };
_dbNameRootFull = _environmentPrefix + _dbNameRoot;
DMP_dbNamePlayers = _dbNameRootFull + "_players";
DMP_dbNameWorld = _dbNameRootFull + "_world";
DMP_dbNameVehicles = _dbNameRootFull + "_vehicles";
DMP_dbNameVariables = _dbNameRootFull + "_variables";
DMP_dbNameJournals = _dbNameRootFull + "_journals";

DMP_dbPlayerVarNames = _playerVarNames;
DMP_dbVehiclesToTrack = _vehicles;
publicVariable "DMP_dbVehiclesToTrack";
DMP_dbSaveInterval = _saveInterval;

call DMP_fnc_initHandlePlayerDisconnecting;

["STR_DMP_initializing"] remoteExec["DMP_fnc_hintLocalized"];
sleep 3;

// Load world data
call DMP_fnc_loadWorldData;
["STR_DMP_loadingObjects"] remoteExec["DMP_fnc_hintLocalized"];
sleep 3;

// Load all vehicles
0 call DMP_fnc_loadAllVehicles;
0 call DMP_fnc_addAceCargoHandlers;
sleep 10;

["STR_DMP_loadingDone"] remoteExec["DMP_fnc_hintLocalized"];
while { true } do {
	call DMP_fnc_saveVehicles;
	call DMP_fnc_savePlayers;
	call DMP_fnc_saveWorldData;
	
	sleep DMP_dbSaveInterval;
};