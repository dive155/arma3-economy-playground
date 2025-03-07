params [
	["_dbNameRoot", "DefaultDatabase"],
	["_useIn3DEN", true],
	["_vehicles", []],
	["_plrVarNames", []],
	["_worldGetters", []],
	["_worldSetters", []]
];

call compile preprocessFileLineNumbers "dataBase\serverHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\cargoHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\handleCrateData.sqf";
call compile preprocessFileLineNumbers "dataBase\handleVehicleData.sqf";
call compile preprocessFileLineNumbers "dataBase\handlePlayerData.sqf";
[_worldGetters, _worldSetters] call compile preprocessFileLineNumbers "dataBase\handleWorldData.sqf";

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

dbPlrVarNames = _plrVarNames;
dbVehiclesToTrack = _vehicles;

dbWorldGetters = _worldGetters;
dbWorldSetters = _worldSetters;

call fnc_db_initHandlePlayerDisconnecting;

sleep 5;

// Load all vehicles
0 spawn fn_db_loadAllVehicles;
sleep 2;

// Load world data
if (call fnc_db_checkHasWorldData) then {
	call fnc_db_loadWorldData;
} else {
	call fnc_db_saveWorldData;
};

sleep 10;

while { true } do {
	call fnc_db_saveVehicles;
	call fnc_db_savePlayers;
	call fnc_db_saveWorld;
	
	sleep 60;
};