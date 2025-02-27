_scriptHandle = execVM "scripts\economy\initCurrencies.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\economy\initResourceConverters.sqf";
waitUntil { scriptDone _scriptHandle };