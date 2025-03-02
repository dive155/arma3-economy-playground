fnc_db_savePlayerData = {
	params [
		"_unit", 							// The unit we're saving
		"_isDisconnecting",					// Whether the unit is disconnecting vs regular autosave
		["_plrVarNames", []]                // Custom vars names to be obtained via getVariable
	];

	if (_unit isKindOf "MAN") then {
		_namePlr = _unit getVariable "KRV_playerID";
		_player_SaveDBLocal = ["new", dbNamePlayers] call OO_INIDBI;
		_loadout = ["write", [_namePlr, "plrStuff", getUnitLoadout _unit]] call _player_SaveDBLocal;
		_pos = ["write", [_namePlr, "plrPosition", getPosATL _unit]] call _player_SaveDBLocal;
		_dir = ["write", [_namePlr, "plrDirection", getDir _unit]] call _player_SaveDBLocal;
		_face = ["write", [_namePlr, "plrFace", face _unit]] call _player_SaveDBLocal;
		
		// Misc values that do not go into _plrVarNames
		_plrMisc = [];
		_misc = ["write", [_namePlr, "plrMisc", _plrMisc]] call _player_SaveDBLocal;
		
		// Custom variables dependent on getVariable
		_allCustomVars = [];
		{
			_customVarValue = _unit getVariable [_x, ""];
			_allCustomVars pushBack [_x, _customVarValue];
		} forEach _plrVarNames;
		_custom = ["write", [_namePlr, "plrCustomVars", _allCustomVars]] call _player_SaveDBLocal;
		
		// Handle WBK second weapon mod
		if (!(isNil {_unit getVariable "WBK_SecondWeapon"})) then {
			_crate = (_unit getVariable "WBK_SecondWeapon") select 0;
			_plSecWeap = (_unit getVariable "WBK_SecondWeapon") select 1;
			_varsWeap = ["write", [_namePlr, "plrSecondWeapon", _plSecWeap]] call _player_SaveDBLocal;
			
			if (_isDisconnecting) then {
				deleteVehicle _crate;
			};
		};
		
		// If player is disconnecting delete the unit
		if (_isDisconnecting) then {
			sleep 2;
			deleteVehicle _unit;
		};
	};
};