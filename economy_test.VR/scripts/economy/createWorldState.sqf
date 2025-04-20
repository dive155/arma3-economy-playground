params [  
	["_initialize", { params["_missionNamespace"]; }]
];

allWorldVariablesKey = "allWorldVariables";

// Public method for CLIENT and SERVER
fnc_getWorldVariable = {
	params ["_varName"];
	missionNamespace getVariable _varName;
};

// fnc_setWorldVariable asks server to change variable in missionNamespace
// server does it and then broadcast the changes to all clients so they could
// invoke their localcallbacks
// Public method for CLIENT and SERVER
fnc_setWorldVariable = {
	params ["_varName", "_value"];
	[_varName, _value] remoteExec ["fnc_setWorldVariableServer", 2];
};

// Private method, meant to be called on SERVER
fnc_setWorldVariableServer = {
	params ["_varName", "_value"];
	missionNamespace setVariable [_varName, _value, true];
	
	_allVars = missionNamespace getVariable allWorldVariablesKey;
	_allVars pushBackUnique [_varName];
	 missionNamespace setVariable [allWorldVariablesKey, _allVars, true];
	
	["worldVariableChanged", [_varName, _value]] call CBA_fnc_globalEvent;
};

fnc_increaseWorldVariable = {
	params ["_varName", "_toAdd"];
	
	_value = _varName call fnc_getWorldVariable;
	_value = _value + _toAdd;
	[_varName, _value] call fnc_setWorldVariable;
};

if isServer then {
	missionNamespace setVariable [allWorldVariablesKey, [], true];
	missionNamespace call _initialize;
};

