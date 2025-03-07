fnc_db_saveVehicles = {
	{
		[_x] spawn fnc_db_saveCrateData;
	} forEach dbCratesToTrack;
	systemChat ("saved crates");
	sleep 2;
	{
		_handle = [_x] spawn fn_db_saveVehicleData;
		waitUntil { scriptDone _handle };
		systemChat ("saved" + str(_x));
	} forEach dbVehiclesToTrack;
	systemChat ("saved vics");
	sleep 2;
};

fnc_db_savePlayers = {
	systemChat ("saved players");
	_allPlayersToSave = call BIS_fnc_listPlayers;
	{
		// Making sure the player has not left the game since we started the loop
		_currentPlayers = call BIS_fnc_listPlayers;
		
		if (_x in _currentPlayers) then {;
			[_x, false, dbPlrVarNames] call fnc_db_savePlayerData;
			
			// Saving is spaced out to avoid overloading server with save requests
			sleep 1;
		};
		
	} forEach _allPlayersToSave;
};

fnc_db_saveWorld = {
	if ((count dbWorldGetters > 0) or (count dbWorldSetters > 0)) then {
		call fnc_db_saveWorldData;
	};
	systemChat ("saved world");
};