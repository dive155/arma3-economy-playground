DMP_fnc_saveVehicles = {
	{
		_handle = [_x] spawn DMP_fnc_saveVehicleData;
		waitUntil { scriptDone _handle };
		//systemChat ("saved" + str(_x));
	} forEach dbVehiclesToTrack;
	//systemChat ("saved vics");
	sleep 1;
};

DMP_fnc_savePlayers = {
	//systemChat ("saved players");
	_allPlayersToSave = call BIS_fnc_listPlayers;
	{
		// Making sure the player has not left the game since we started the loop
		_currentPlayers = call BIS_fnc_listPlayers;
		
		if (_x in _currentPlayers) then {;
			[_x, false, dbPlayerVarNames] call DMP_fnc_savePlayerData;
			
			// Saving is spaced out to avoid overloading server with save requests
			sleep 0.3;
		};
		
	} forEach _allPlayersToSave;
};

DMP_fnc_getPersistenObjectCategory = {
	params ["_object"];
	
	// Check if Vehicle
	if (fullCrew [_object, "", true] isNotEqualTo []) exitWith { 0 };
	
	// Check if Crate
	if (getNumber (configFile >> "CfgVehicles" >> typeOf _object >> "maximumLoad") > 0) exitWith { 1 };
	
	// It's a Prop
	2
};