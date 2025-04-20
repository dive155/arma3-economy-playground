params [  
	["_initialize", { params["_missionNamespace"]; }]
];

allWorldVariablesKey = "allWorldVariables";

// Public method for CLIENT and SERVER
fnc_getWorldVariable = {
	params ["_varName"];
	
	// All persistent variables are mirrored to missionNamespace to make them available for clients
	missionNamespace getVariable [_varName, ""];
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
		
	[_varName, _value] call DMP_fnc_setPersistentVariable; 
	["worldVariableChanged", [_varName, _value]] call CBA_fnc_globalEvent;
};

fnc_increaseWorldVariable = {
	params ["_varName", "_toAdd"];
	
	_value = _varName call fnc_getWorldVariable;
	_value = _value + _toAdd;
	[_varName, _value] call fnc_setWorldVariable;
};

if isServer then {
	//missionNamespace setVariable [allWorldVariablesKey, [], true];
	sleep 1;
	_allVars = call DMP_fnc_allPersistentVariables;
	{
		// Mirroring all vars to missionNamespace to make them available for clients
		private _value = [_x] call DMP_fnc_getPersistentVariable;
		missionNamespace setVariable [_x, _value, true];
		
	} forEach _allVars;
	
	call _initialize;
};

