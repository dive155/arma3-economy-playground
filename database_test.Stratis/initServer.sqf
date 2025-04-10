[
	// Name root for the Database for this mission. It is recommended to have different names for different missions.
	"TestDatabase",
	
	// Save interval in seconds
	60,
	
	// Whether or not to use database when testing in 3Den editor. Set to false to not use.
	true,
	
	// Save date and time
	true,
	
	// Save weather
	true,
	
	// List of persistent vehicles.
	//[amobus, amobus_1, amobus_2, amobus_3, amobus_4, amobus_5, amobus_6, amobus_7, amobus_8, amobus_9, amobus_10 ],
	[amobus, crate_1],
	
	// Names of custom persistent player variables to be used with getVariable.
	["pdr_fatigue", "pdr_address"]
]call compile preprocessFileLineNumbers "dataBase\initDatabaseServer.sqf";

