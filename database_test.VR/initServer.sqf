[
	// Name root for the Database for this mission. It is recommended to have different names for different missions.
	"TestDatabase",
	
	// Whether or not to use database when testing in 3Den editor. Set to false to not use.
	true,
	
	// List of persistent crates.
	[crate_1],
	
	// Names of custom persistent player variables to be used with getVariable.
	[]
]call compile preprocessFileLineNumbers "dataBase\initDatabaseServer.sqf";