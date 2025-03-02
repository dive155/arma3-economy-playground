params [  
	["_initialize", { params["_missionNamespace"]; }],
	["_onVariableChanged", { params ["_varName", "_newValue"];}]
];

missionNamespaceVariableChangedCallbacks = [_onVariableChanged];
allWorldVariablesKey = "allWorldVariables";

// Public method for CLIENT and SERVER
fnc_subscribeToVariableChange = {
	params ["_callback"];
	missionNamespaceVariableChangedCallbacks pushBack _callback;
};

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
	
	[_varName, _value] remoteExec ["fnc_handleWorldVariableChanged", 0];
};

// Private method, meant to be called on CLIENT
fnc_handleWorldVariableChanged = {
	params ["_varName", "_value"];
	{
		[_varName, _value] call _x;
	} forEach missionNamespaceVariableChangedCallbacks;
};

if isServer then {
	missionNamespace setVariable [allWorldVariablesKey, [], true];
	missionNamespace call _initialize;
};

