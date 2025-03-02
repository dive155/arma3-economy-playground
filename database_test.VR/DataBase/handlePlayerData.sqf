fnc_db_checkIfHasDataForPlayer = {
	params [ "_unit" ];
	
	if not (_unit isKindOf "MAN") exitWith { false };
	
	_namePlr = _unit getVariable "KRV_playerID";
	_player_SaveDBLocal = ["new", dbNamePlayers] call OO_INIDBI;
	_sections = "getSections" call _player_SaveDBLocal;
	_namePlr in _sections
};

fnc_db_loadPlayerData = {
	params [ "_unit" ];

	if (_unit isKindOf "MAN") then {
		_namePlr = _unit getVariable "KRV_playerID";
		_player_SaveDBLocal = ["new", dbNamePlayers] call OO_INIDBI;
		
		_inv = ["read",[_namePlr, "plrStuff",[]]] call _player_SaveDBLocal;
		_pos = ["read",[_namePlr, "plrPosition",[]]] call _player_SaveDBLocal;
		_dir = ["read",[_namePlr, "plrDirection",0]] call _player_SaveDBLocal;
		_face = ["read",[_namePlr, "plrFace",""]] call _player_SaveDBLocal;
		
		_misc = ["read",[_namePlr, "plrMisc",[]]] call _player_SaveDBLocal;
		
		
		_allCustomVars = ["read",[_namePlr, "plrCustomVars",[]]] call _player_SaveDBLocal;
		{
			_varName = _x select 0;
			_value = _x select 1;
		
			_unit setVariable [_varName, _value, true];
		} forEach _allCustomVars;
		
		_varsSecondWeapon = ["read",[_namePlr, "plrSecondWeapon",[]]] call _player_SaveDBLocal;
		
		sleep 0.1;
		_unit setUnitLoadout _inv;
		
		sleep 0.1;
		_unit setPosATL _pos;
		_unit setDir _dir;
		
		if (_face != "") then {
			[_unit, _face] remoteExec ["setFace",0];
		};
		
		sleep 0.1;
		if (count _varsSecondWeapon == 0) exitWith {};
		[[_unit,_varsSecondWeapon],WBK_CreateWeaponSecond_scripted] remoteExec ["spawn",_unit];
	};
};

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
			_unit spawn {
				params ["_unit"];
				sleep 2;
				deleteVehicle _unit;
			};
		};
	};
};