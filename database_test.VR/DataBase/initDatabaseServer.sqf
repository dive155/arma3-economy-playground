params [
	["_dbNameRoot", "DefaultDatabase"],
	["_useIn3DEN", true],
	["_crates", []]
];

_is3DEN = is3DENPreview;
shouldUseDB = not _is3DEN or (_is3DEN and _useIn3DEN);

// Give players their stuff when they connect
fnc_db_handlePlayerConnected = {
	params ["_unit"];
	
	if (shouldUseDB) then {
		[_unit] execVM "DataBase\loadPlayerData.sqf";
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

// Save players stuff when they disconnect
addMissionEventHandler ['HandleDisconnect',{
	_un = _this select 0;
	_un enableSimulationGlobal false;
	_un setDamage 0;
	[_un] execVM "DataBase\savePlayerData.sqf";
}];

sleep 5;

// Load inventory for all crates
{
	[_x] execVM "DataBase\loadCrateData.sqf";
} forEach _crates;

sleep 10;

// Save persistent crates inventory every 20 seconds
[_crates] spawn {
	params ["_crates"];
	while {true} do {
		{
			[_x] execVM "DataBase\saveCrateData.sqf";
		} forEach _crates;
		sleep 20;
	};
};