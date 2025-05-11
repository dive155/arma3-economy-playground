// This whole script runs on SERVER
fnc_createDefaultWorldState = {
	private _noData = ((["cityMoney"] call fnc_getWorldVariable) isEqualTo  "");
	
	if (_noData) then {
		["cityMoney", 1000] call fnc_setWorldVariable;
		["moldovaMoney", 1000] call fnc_setWorldVariable;
		["factoryMoney", 2000] call fnc_setWorldVariable;
		["fuelInStorage", 100] call fnc_setWorldVariable;
		["fuelInStorageMoldova", 100] call fnc_setWorldVariable;
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
		["fuelPrice_Moldova", 2] call fnc_setWorldVariable;
		["exchangeRate", 13] call fnc_setWorldVariable;
		["exchangeSpread", 0.05] call fnc_setWorldVariable;
		["rpDay", 0] call fnc_setWorldVariable;
		["interestRate_PDR", 0.2] call fnc_setWorldVariable;
		["interestRate_Moldova", 0.15] call fnc_setWorldVariable;
		["lunchPrice", 300] call fnc_setWorldVariable;
		["factoryOpen", true] call fnc_setWorldVariable;
		["farmOpen", true] call fnc_setWorldVariable;
		["quarryOpen", true] call fnc_setWorldVariable;
		["gasStationOpen", true] call fnc_setWorldVariable;
		["gasStationOpenMoldova", true] call fnc_setWorldVariable;
		["salesTaxPdr", 0.15] call fnc_setWorldVariable;
		["salesTaxMoldova", 0.2] call fnc_setWorldVariable;
		["inflationCoef_PDR", 1] call fnc_setWorldVariable;
		["inflationCoef_Moldova", 1] call fnc_setWorldVariable;
		["services_priceTram", 800] call fnc_setWorldVariable;
		["services_paidTram", false] call fnc_setWorldVariable;
		["services_priceStreetlights", 300] call fnc_setWorldVariable;
		["services_paidStreetlights", false] call fnc_setWorldVariable;
		["services_priceSpeedtraps", 100] call fnc_setWorldVariable;
		["services_paidSpeedtraps", false] call fnc_setWorldVariable;
		["speedTrapsEnabled", true] call fnc_setWorldVariable;
		["speedingFineLow", 50] call fnc_setWorldVariable;
		["speedingFineHigh", 200] call fnc_setWorldVariable;
	};
};

_handle = [fnc_createDefaultWorldState] execVM "scripts\economy\createWorldStatePersistent.sqf";

waitUntil { scriptDone _handle };