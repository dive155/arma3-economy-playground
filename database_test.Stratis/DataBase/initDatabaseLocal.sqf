call compile preprocessFileLineNumbers "dataBase\initMiscHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\initZenModules.sqf";
player setVariable ["DMP_SteamID",getPlayerUID player, true];
sleep 0.5;

[player] remoteExec ["DMP_fnc_handlePlayerConnected", 2];