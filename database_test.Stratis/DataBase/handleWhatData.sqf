params[
	// Value getters used when saving data, format: [["varName", { 123 }], [..]]
	["_getters", []],
	// Value setters used when loading data, format [["varName", { params["_value"]; }], [..]]
	["_setters", []]  
];

dbWorldGetters = _getters;
dbWorldSetters = _setters;
dbWorldSectionName = "World";

// Designed to be used to store any kind of world variable like weather, date, custom missionNamespace variables etc
fnc_db_saveWorldData = {
	_dbHandle = ["new", dbNameWorld] call OO_INIDBI;
	{
		_varName = _x select 0;
		_delegate = _x select 1;
		_value = call _delegate;
		
		_loadout = ["write", [dbWorldSectionName, _varName, _value]] call _dbHandle;
	} forEach dbWorldGetters
};

fnc_db_checkHasWorldData = {
	_dbHandle = ["new", dbNameWorld] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	dbWorldSectionName in _sections
};

fnc_db_loadWorldData = {
	_dbHandle = ["new", dbNameWorld] call OO_INIDBI;
	{
		_varName = _x select 0;
		_delegate = _x select 1;
		
		_value = ["read",[dbWorldSectionName, _varName, objNull]] call _dbHandle;
		[_value] call _delegate;
	} forEach dbWorldSetters;
}