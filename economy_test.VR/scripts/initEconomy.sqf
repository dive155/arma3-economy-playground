_scriptHandle = execVM "scripts\helpers\transactionHelpers.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initWorldState.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\economy\storeHelpers.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\stats\playerStatsInit.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initCurrencies.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\fuelConsumptionCalculations.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\interactables\initMoneyExchanges.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\interactables\initResourceConverters.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\interactables\initGasStations.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\interactables\initStores.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\interactables\initPaymentCashboxes.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\interactables\initAccountCashboxes.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initExtraInteractions.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initAdvanceDaySystem.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initVariablesEditing.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initZeusModules.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initDashboards.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\initSpeedtraps.sqf";
waitUntil { scriptDone _scriptHandle };