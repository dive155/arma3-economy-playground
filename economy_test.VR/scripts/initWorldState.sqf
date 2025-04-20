// This whole script runs on SERVER
fnc_createDefaultWorldState = {
	private _noData = (["cityMoney"] call fnc_getWorldVariable) == "";
	
	if (_noData) then {
		["cityMoney", 1000] call fnc_setWorldVariable;
		["factoryMoney", 2000] call fnc_setWorldVariable;
		["fuelInStorage", 100] call fnc_setWorldVariable;
		["payHay", 240] call fnc_setWorldVariable;
		["fatigueHay", 1] call fnc_setWorldVariable;
		["payOre", 220] call fnc_setWorldVariable;
		["fatigueOre", 1] call fnc_setWorldVariable;
		["payFactory", 140] call fnc_setWorldVariable;
		["fatigueFactory", 0.5] call fnc_setWorldVariable;
		["factoryGoodsSellPrice", 2000] call fnc_setWorldVariable;
		["factoryGoodsTax", 0.45] call fnc_setWorldVariable;
		["factoryBossCommission", 110] call fnc_setWorldVariable;
		["fuelPricePDR", 50] call fnc_setWorldVariable;
	};
};

_handle = [fnc_createDefaultWorldState] execVM "scripts\economy\createWorldStatePersistent.sqf";

waitUntil { scriptDone _handle };