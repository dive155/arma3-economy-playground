// This whole script runs on SERVER
fnc_createDefaultWorldState = {
	private _noData = ((["cityMoney"] call fnc_getWorldVariable) isEqualTo  "");
	
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
		["factoryGoodsTax", 0.35] call fnc_setWorldVariable;
		["factoryBossCommission", 0.3] call fnc_setWorldVariable;
		["fuelPrice_PDR", 50] call fnc_setWorldVariable;
		["exchangeRate", 13] call fnc_setWorldVariable;
		["exchangeSpread", 1] call fnc_setWorldVariable;
		["rpDay", 0] call fnc_setWorldVariable;
		["interestRate_PDR", 0.2] call fnc_setWorldVariable;
		["interestRate_Moldova", 0.15] call fnc_setWorldVariable;
		["lunchPrice", 300] call fnc_setWorldVariable;
		["factoryOpen", true] call fnc_setWorldVariable;
		["farmOpen", true] call fnc_setWorldVariable;
		["quarryOpen", true] call fnc_setWorldVariable;
	};
};

_handle = [fnc_createDefaultWorldState] execVM "scripts\economy\createWorldStatePersistent.sqf";

waitUntil { scriptDone _handle };