player setVariable ["KRV_playerID",getPlayerUID player, true];
sleep 0.1;

[player] remoteExec ["fnc_db_handlePlayerConnected", 2];