fnc_createDefaultWorldState = {
	params["_worldState"];
	
	["fuelInStorage", 100] call fnc_setWorldVariable;
};

_handle = [
	world_state_object,
	fnc_createDefaultWorldState,
	{ params ["_varName", "_newValue"]; hint format ["%1 set to %2", _varName, _newValue]; } 
]execVM "scripts\economy\createWorldState.sqf";

waitUntil { scriptDone _handle };

//sleep 2;
//["amogus", 3] call fnc_setWorldVariable;