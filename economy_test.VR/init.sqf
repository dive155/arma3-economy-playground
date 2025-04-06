_scriptHandle = execVM "scripts\initWorldState.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\economy\storeHelpers.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\stats\playerStatsInit.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initCurrencies.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initMoneyExchanges.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initResourceConverters.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initGasStations.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initExtraInteractions.sqf";
waitUntil { scriptDone _scriptHandle };