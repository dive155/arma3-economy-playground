dbVariablesSection = "Variables";

fnc_db_getPersistentVariable = {
	params ["_varName", ["_defaultValue", ""]];
	
	_dbHandle = ["new", dbNameVariables] call OO_INIDBI;
	
	_value = ["read", [dbVariablesSection, _varName, _defaultValue]] call _dbHandle;
	_value
};

fnc_db_setPersistentVariable = {
	params ["_varName", "_value"];
	
	_dbHandle = ["new", dbNameVariables] call OO_INIDBI;
	["write", [dbVariablesSection, _varName, _value]] call _dbHandle;
};

fnc_db_increasePersistentVariable = {
	params ["_varName", "_amount"];
	
	_value = [_varName] call fnc_db_getPersistentVariable;
	_value = _value + _amount;
	[_varName, _value] call fnc_db_setPersistentVariable;
};