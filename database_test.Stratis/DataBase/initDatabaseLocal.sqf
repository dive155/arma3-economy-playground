call compile preprocessFileLineNumbers "dataBase\miscHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\initZenModules.sqf";
player setVariable ["DB_SteamID",getPlayerUID player, true];
sleep 0.5;

[player] remoteExec ["DMP_fnc_handlePlayerConnected", 2];