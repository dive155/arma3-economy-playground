dbVariablesSection = "Variables";

fnc_db_getPersistentVariable = {
	params ["_varName", ["_defaultValue", ""]];
	
	_dbHandle = ["new", dbNameVariables] call OO_INIDBI;
	
	_value = ["read", [dbVariablesSection, _varName, _defaultValue]] call _dbHandle;
	
	if (typeName _value == "STRING") then {
		_value = [_value] call fnc_db_restoreLineFeeds;
	};
	
	_value
};

fnc_db_setPersistentVariable = {
	params ["_varName", "_value"];
	
	_dbHandle = ["new", dbNameVariables] call OO_INIDBI;
	
	if (typeName _value == "STRING") then {
		_value = [_value] call fnc_db_replaceLineFeeds;
	};
	
	["write", [dbVariablesSection, _varName, _value]] call _dbHandle;
};

fnc_db_increasePersistentVariable = {
	params ["_varName", "_amount"];
	
	_value = [_varName] call fnc_db_getPersistentVariable;
	_value = _value + _amount;
	[_varName, _value] call fnc_db_setPersistentVariable;
};

// Saving system doesn't support line feeds (unicode character 10)
// Can't use \n here so replacing with %
fnc_db_replaceLineFeeds = {
    private _input = _this select 0;
    private _lineFeed = toString [10]; // actual LF character
    private _output = _input splitString _lineFeed;
    _output joinString "%"
};

fnc_db_restoreLineFeeds = {
    private _input = _this select 0;
    private _output = _input splitString "%";
    _output joinString (toString [10])
};