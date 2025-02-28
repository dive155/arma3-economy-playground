_scriptHandle = execVM "scripts\stats\playerStatsInit.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\economy\initCurrencies.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\economy\initResourceConverters.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\economy\initGasStations.sqf";
waitUntil { scriptDone _scriptHandle };