_scriptHandle = execVM "scripts\misc\initServerValueRequesting.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "hud\initLongTextDialog.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\misc\initJournalPresenters.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\initEconomy.sqf";
waitUntil { scriptDone _scriptHandle };