// This whole script runs on SERVER
fnc_createDefaultWorldState = {
	private _noData = ((["cityMoney"] call fnc_getWorldVariable) isEqualTo  "");
	
	if (_noData) then {
		["cityMoney", 10000] call fnc_setWorldVariable;
		["moldovaMoney", 1000] call fnc_setWorldVariable;
		["factoryMoney", 20000] call fnc_setWorldVariable;
		["fuelInStorage", 400] call fnc_setWorldVariable;
		["fuelInStorageMoldova", 800] call fnc_setWorldVariable;
		["payHay", 410] call fnc_setWorldVariable;
		["fatigueHay", 1] call fnc_setWorldVariable;
		["payOre", 390] call fnc_setWorldVariable;
		["fatigueOre", 1] call fnc_setWorldVariable;
		["payFactory", 200] call fnc_setWorldVariable;
		["fatigueFactory", 0.5] call fnc_setWorldVariable;
		["factoryGoodsSellPrice", 3500] call fnc_setWorldVariable;
		["factoryGoodsTax", 0.55] call fnc_setWorldVariable;
		["factoryBossCommission", 0.5] call fnc_setWorldVariable;
		["fuelPrice_PDR", 25] call fnc_setWorldVariable;
		["fuelPrice_Moldova", 1] call fnc_setWorldVariable;
		["exchangeRate", 13] call fnc_setWorldVariable;
		["exchangeSpread", 0.05] call fnc_setWorldVariable;
		["rpDay", 0] call fnc_setWorldVariable;
		["interestRate_PDR", 0.1] call fnc_setWorldVariable;
		["interestRate_Moldova", 0.2] call fnc_setWorldVariable;
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
		["services_priceTram", 1000] call fnc_setWorldVariable;
		["services_paidTram", false] call fnc_setWorldVariable;
		["services_priceStreetlights", 500] call fnc_setWorldVariable;
		["services_paidStreetlights", false] call fnc_setWorldVariable;
		["services_priceSpeedtraps", 0] call fnc_setWorldVariable;
		["services_paidSpeedtraps", false] call fnc_setWorldVariable;
		["speedTrapsEnabled", false] call fnc_setWorldVariable;
		["speedingFineLow", 50] call fnc_setWorldVariable;
		["speedingFineHigh", 200] call fnc_setWorldVariable;
	};
};

_handle = [fnc_createDefaultWorldState] execVM "scripts\economy\createWorldStatePersistent.sqf";

waitUntil { scriptDone _handle };