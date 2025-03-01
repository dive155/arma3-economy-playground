params [ 
	"_anchorObject", 
	["_initialize", { params["_worldState"]; }],
	["_onVariableChanged", { params ["_varName", "_newValue"];}]
];

worldState = _anchorObject;
worldStateVariableChangedCallbacks = [_onVariableChanged];
allWorldVariablesKey = "allWorldVariables";

// Public method for CLIENT and SERVER
fnc_subscribeToVariableChange = {
	params ["_callback"];
	worldStateVariableChangedCallbacks pushBack _callback;
};

// Public method for CLIENT and SERVER
fnc_getWorldVariable = {
	params ["_varName"];
	worldState getVariable _varName;
};

// fnc_setWorldVariable asks server to change variable in worldState
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
	worldState setVariable [_varName, _value];
	
	_allVars = worldState getVariable allWorldVariablesKey;
	_allVars pushBackUnique [_varName];
	 worldState setVariable [allWorldVariablesKey, _allVars];
	
	[_varName, _value] remoteExec ["fnc_handleWorldVariableChanged", 0];
};

// Private method, meant to be called on CLIENT
fnc_handleWorldVariableChanged = {
	params ["_varName", "_value"];
	{
		[_varName, _value] call _x;
	} forEach worldStateVariableChangedCallbacks;
};

if isServer then {
	worldState setVariable [allWorldVariablesKey, []];
	worldState call _initialize;
};

