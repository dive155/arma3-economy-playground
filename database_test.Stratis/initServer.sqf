
_scriptHandle = execVM "dataBase\vehicleHelpers.sqf";

[
	// Name root for the Database for this mission. It is recommended to have different names for different missions.
	"TestDatabase",
	
	// Whether or not to use database when testing in 3Den editor. Set to false to not use.
	true,
	
	// List of persistent vehicles.
	//[amobus, amobus_1, amobus_2, amobus_3, amobus_4, amobus_5, amobus_6, amobus_7, amobus_8, amobus_9, amobus_10 ],
	[amobus, crate_1],
	
	// Names of custom persistent player variables to be used with getVariable.
	[],
	
	// Delegates for saving world variables, example: [["dateVar", { date }]]
	[["dateVar", { date }]],
	
	// Delegates for loading world variables
	// Note that if the value is not found in the database it will be set to objNull
	// Example:
	// [["dateVar", { params["_value"]; [_value] call BIS_fnc_setDate }]]
	[["dateVar", { params["_value"]; [_value] call BIS_fnc_setDate }]]
]call compile preprocessFileLineNumbers "dataBase\initDatabaseServer.sqf";

