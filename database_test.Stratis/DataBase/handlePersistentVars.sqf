DMP_dbVariablesSection = "Variables";

DMP_fnc_getPersistentVariable = {
	params ["_varName", ["_defaultValue", ""]];
	
	_dbHandle = ["new", DMP_dbNameVariables] call OO_INIDBI;
	
	_value = ["read", [DMP_dbVariablesSection, _varName, _defaultValue]] call _dbHandle;
	
	if (typeName _value == "STRING") then {
		_value = [_value] call DMP_fnc_restoreLineFeeds;
	};
	
	_value
};

DMP_fnc_setPersistentVariable = {
	params ["_varName", "_value"];
	
	_dbHandle = ["new", DMP_dbNameVariables] call OO_INIDBI;
	
	if (typeName _value == "STRING") then {
		_value = [_value] call DMP_fnc_replaceLineFeeds;
	};
	
	["write", [DMP_dbVariablesSection, _varName, _value]] call _dbHandle;
};

DMP_fnc_increasePersistentVariable = {
	params ["_varName", "_amount"];
	
	_value = [_varName] call DMP_fnc_getPersistentVariable;
	_value = _value + _amount;
	[_varName, _value] call DMP_fnc_setPersistentVariable;
};

// Saving system doesn't support line feeds (unicode character 10)
// Can't use \n here so replacing with %
DMP_fnc_replaceLineFeeds = {
    private _input = _this select 0;
    private _lineFeed = toString [10]; // actual LF character
    private _output = _input splitString _lineFeed;
    _output joinString "%"
};

DMP_fnc_restoreLineFeeds = {
    private _input = _this select 0;
    private _output = _input splitString "%";
    _output joinString (toString [10])
};