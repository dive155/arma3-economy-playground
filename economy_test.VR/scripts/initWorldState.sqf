fnc_createDefaultWorldState = {
	["cityMoney", 1000] call fnc_setWorldVariable;
	["factoryMoney", 2000] call fnc_setWorldVariable;
	["fuelInStorage", 100] call fnc_setWorldVariable;
	["payHay", 120] call fnc_setWorldVariable;
	["fatigueHay", 1] call fnc_setWorldVariable;
	["payOre", 140] call fnc_setWorldVariable;
	["fatigueOre", 1] call fnc_setWorldVariable;
	["payFactory", 90] call fnc_setWorldVariable;
	["fatigueFactory", 0.5] call fnc_setWorldVariable;
	["factoryGoodsSellPrice", 900] call fnc_setWorldVariable;
	["factoryGoodsTax", 0.25] call fnc_setWorldVariable;
	["fuelPricePDR", 50] call fnc_setWorldVariable;
};

_handle = [
	fnc_createDefaultWorldState,
	{ params ["_varName", "_newValue"]; systemChat format ["%1 set to %2", _varName, _newValue]; } 
]execVM "scripts\economy\createWorldState.sqf";

waitUntil { scriptDone _handle };