params [
	["_dbNameRoot", "DefaultDatabase"],
	["_useIn3DEN", true],
	["_crates", []],
	["_plrVarNames", []],
	["_worldGetters", []],
	["_worldSetters", []]
];

call compile preprocessFileLineNumbers "dataBase\cargoHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\handleCrateData.sqf";
call compile preprocessFileLineNumbers "dataBase\handlePlayerData.sqf";
[_worldGetters, _worldSetters] call compile preprocessFileLineNumbers "dataBase\handleWorldData.sqf";

_is3DEN = is3DENPreview;
shouldUseDB = not _is3DEN or (_is3DEN and _useIn3DEN);

// Give players their stuff when they connect
fnc_db_handlePlayerConnected = {
	params ["_unit"];
	
	if not shouldUseDB exitWith { };
	
	if (_unit call fnc_db_checkIfHasDataForPlayer) then {
		_unit call fnc_db_loadPlayerData;
	} else {
		// Player joining for the first time - save his data instead of loading
		[_unit, false, dbPlrVarNames] call fnc_db_savePlayerData;
	};
};

if not shouldUseDB exitWith { 
	systemChat "Skipping persistent inventory initServer because 3Den preview mode detected"; 
};

// Compose full database names for this specific game instance
// Split development database and production database for safety
_environmentPrefix = if (_is3DEN) then { "DEV_" } else { "PROD_" };
_dbNameRootFull = _environmentPrefix + _dbNameRoot;
dbNamePlayers = _dbNameRootFull + "_players";
dbNameCrates = _dbNameRootFull + "_crates";
dbNameWorld = _dbNameRootFull + "_world";
dbPlrVarNames = _plrVarNames;

// Save players stuff when they disconnect
addMissionEventHandler ['HandleDisconnect',{
	_un = _this select 0;
	_un enableSimulationGlobal false;
	_un setDamage 0;
	[_un, true, dbPlrVarNames] call fnc_db_savePlayerData;
}];

sleep 5;

// Load inventory for all crates
{
	[_x] call fnc_db_loadCrateData;
} forEach _crates;

// Load world data
if (call fnc_db_checkHasWorldData) then {
	call fnc_db_loadWorldData;
} else {
	call fnc_db_saveWorldData;
};

sleep 10;

// Save persistent crates inventory every 20 seconds
[_crates] spawn {
	params ["_crates"];
	while {true} do {
		{
			[_x] call fnc_db_saveCrateData;
		} forEach _crates;
		sleep 20;
	};
};

// Save players stuff from time to time
0 spawn {
	while { true } do {
		_allPlayersToSave = call BIS_fnc_listPlayers;
		{
			// Making sure the player has not left the game since we started the loop
			_currentPlayers = call BIS_fnc_listPlayers;
			
			if (_x in _currentPlayers) then {;
				[_x, false, dbPlrVarNames] call fnc_db_savePlayerData;
				
				// Saving is spaced out to avoid overloading server with save requests
				sleep 3;
			};
			
		} forEach _allPlayersToSave;
	};
};

// Save world data every 25 seconds
if ((count _worldGetters > 0) or (count _worldSetters > 0)) then {
	0 spawn {
		while { true } do {
			call fnc_db_saveWorldData;
			sleep 25;
		};
	};
};