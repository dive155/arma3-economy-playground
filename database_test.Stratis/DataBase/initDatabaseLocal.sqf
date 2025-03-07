player setVariable ["DB_SteamID",getPlayerUID player, true];
sleep 0.5;

[player] remoteExec ["fnc_db_handlePlayerConnected", 2];