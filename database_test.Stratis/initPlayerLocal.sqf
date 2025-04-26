_id = ["DMP_playerDataLoaded", {systemChat "Player data loaded event received"}] call CBA_fnc_addEventHandler;
call compile preprocessFileLineNumbers "dataBase\initDatabaseLocal.sqf";