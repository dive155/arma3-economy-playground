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
shouldUseDB = not _is3DEN or (_is3DEN and _useIn3DEN);

if not shouldUseDB exitWith { 
	systemChat "Skipping persistent inventory initServer because 3Den preview mode detected"; 
};

// Compose full database names for this specific game instance
// Split development database and production database for safety
_environmentPrefix = if (_is3DEN) then { "DEV_" } else { "PROD_" };
_dbNameRootFull = _environmentPrefix + _dbNameRoot;
dbNamePlayers = _dbNameRootFull + "_players";
dbNameWorld = _dbNameRootFull + "_world";
dbNameVehicles = _dbNameRootFull + "_vehicles";
dbNameVariables = _dbNameRootFull + "_variables";
dbNameJournals = _dbNameRootFull + "_journals";

dbPlayerVarNames = _playerVarNames;
dbVehiclesToTrack = _vehicles;
dbSaveInterval = _saveInterval;

call fnc_db_initHandlePlayerDisconnecting;

["STR_DMP_initializing"] remoteExec["fn_hintLocalized"];
sleep 3;

// Load world data
call fnc_db_loadWorldData;
["STR_DMP_loadingObjects"] remoteExec["fn_hintLocalized"];
sleep 3;

// Load all vehicles
0 call fn_db_loadAllVehicles;
0 call fnc_db_addAceCargoHandlers;
sleep 10;

["STR_DMP_loadingDone"] remoteExec["fn_hintLocalized"];
while { true } do {
	call fnc_db_saveVehicles;
	call fnc_db_savePlayers;
	call fnc_db_saveWorldData;
	
	sleep dbSaveInterval;
};