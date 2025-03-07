// Give players their stuff when they connect
fnc_db_handlePlayerConnected = {
	params ["_unit"];
	
	if not shouldUseDB exitWith { };
	
	if (_unit call fnc_db_checkIfHasDataForPlayer) then {
		_unit call fnc_db_loadPlayerData;
	} else {
		// Player joining for the first time - save his data instead of loading
		[_unit, false, dbPlrVarNames] call fnc_db_savePlayerData;
	};
};

fnc_db_initHandlePlayerDisconnecting = {
	addMissionEventHandler ['HandleDisconnect',{
		_un = _this select 0;
		_un enableSimulationGlobal false;
		_un setDamage 0;
		[_un, true, dbPlrVarNames] call fnc_db_savePlayerData;
	}];
};

fnc_db_checkIfHasDataForPlayer = {
	params [ "_unit" ];
	
	if not (_unit isKindOf "MAN") exitWith { false };
	
	_steamId = _unit getVariable "DB_SteamID";
	_dbHandle = ["new", dbNamePlayers] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	_steamId in _sections
};

fnc_db_loadPlayerData = {
	params [ "_unit" ];

	if (_unit isKindOf "MAN") then {
		_steamId = _unit getVariable "DB_SteamID";
		_dbHandle = ["new", dbNamePlayers] call OO_INIDBI;
		
		_inv = ["read",[_steamId, "inventory",[]]] call _dbHandle;
		_pos = ["read",[_steamId, "position",[]]] call _dbHandle;
		_dir = ["read",[_steamId, "dir",0]] call _dbHandle;
		_face = ["read",[_steamId, "face",""]] call _dbHandle;
		
		_allCustomVars = ["read",[_steamId, "plrCustomVars",[]]] call _dbHandle;
		{
			_varName = _x select 0;
			_value = _x select 1;
		
			_unit setVariable [_varName, _value, true];
		} forEach _allCustomVars;
		
		_varsSecondWeapon = ["read",[_steamId, "secondWeapon",[]]] call _dbHandle;
		
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
		_steamId = _unit getVariable "DB_SteamID";
		
		_dbHandle = ["new", dbNamePlayers] call OO_INIDBI;
		_loadout = ["write", [_steamId, "inventory", getUnitLoadout _unit]] call _dbHandle;
		_pos = ["write", [_steamId, "position", getPosATL _unit]] call _dbHandle;
		_dir = ["write", [_steamId, "dir", getDir _unit]] call _dbHandle;
		_face = ["write", [_steamId, "face", face _unit]] call _dbHandle;
		
		// Custom variables dependent on getVariable
		_allCustomVars = [];
		{
			_customVarValue = _unit getVariable [_x, ""];
			_allCustomVars pushBack [_x, _customVarValue];
		} forEach _plrVarNames;
		_custom = ["write", [_steamId, "plrCustomVars", _allCustomVars]] call _dbHandle;
		
		// Handle WBK second weapon mod
		if (!(isNil {_unit getVariable "WBK_SecondWeapon"})) then {
			_crate = (_unit getVariable "WBK_SecondWeapon") select 0;
			_plSecWeap = (_unit getVariable "WBK_SecondWeapon") select 1;
			_varsWeap = ["write", [_steamId, "secondWeapon", _plSecWeap]] call _dbHandle;
			
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