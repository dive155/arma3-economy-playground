call compile preprocessFileLineNumbers "dataBase\initMiscHelpers.sqf";
call compile preprocessFileLineNumbers "dataBase\initZenModules.sqf";

private _uid = getPlayerUID player;
while {_uid isEqualTo ""} do {
	sleep 1;
	_uid = getPlayerUID player;
};

player setVariable ["DMP_SteamID",_uid, true];
sleep 1;

[player] remoteExec ["DMP_fnc_handlePlayerConnected", 2];