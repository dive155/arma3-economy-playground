// Give players their stuff when they connect
DMP_fnc_handlePlayerConnected = {
	params ["_unit"];
	
	if not DMP_shouldUseDB exitWith { };
	
	if (_unit call DMP_fnc_hasDataForPlayer) then {
		_unit call DMP_fnc_loadPlayerData;
	} else {
		// Player joining for the first time - save his data instead of loading
		[_unit, false, DMP_dbPlayerVarNames] call DMP_fnc_savePlayerData;
	};
};

DMP_fnc_initHandlePlayerDisconnecting = {
	addMissionEventHandler ['HandleDisconnect',{
		_un = _this select 0;
		_un enableSimulationGlobal false;
		_un setDamage 0;
		[_un, true, DMP_dbPlayerVarNames] call DMP_fnc_savePlayerData;
	}];
};

DMP_fnc_hasDataForPlayer = {
	params [ "_unit" ];
	
	if not (_unit isKindOf "MAN") exitWith { false };
	
	_steamId = _unit getVariable "DMP_SteamID";
	[_steamId] call DMP_fnc_hasDataForPlayerSteamId;
};

DMP_fnc_hasDataForPlayerSteamId = {
	params ["_steamId"];
	_dbHandle = ["new", DMP_dbNamePlayers] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	_steamId in _sections
};

DMP_fnc_loadPlayerData = {
	params [ "_unit" ];

	if (_unit isKindOf "MAN") then {
		_steamId = _unit getVariable "DMP_SteamID";
		_dbHandle = ["new", DMP_dbNamePlayers] call OO_INIDBI;
		
		_inv = ["read",[_steamId, "inventory",[]]] call _dbHandle;
		_pos = ["read",[_steamId, "position",[]]] call _dbHandle;
		_dir = ["read",[_steamId, "dir",0]] call _dbHandle;
		_face = ["read",[_steamId, "face",""]] call _dbHandle;
		
		// Custom variables dependent on getVariable
		{
			_varName = _x;
			_value = ["read",[_steamId, _varName,[]]] call _dbHandle;
			
			if (typeName _value == "STRING") then {
				_value = [_value] call DMP_fnc_restoreLineFeeds;
			};
			
			_unit setVariable [_varName, _value, true];
		} forEach DMP_dbPlayerVarNames;
		
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

DMP_fnc_savePlayerData = {
	params [
		"_unit", 							// The unit we're saving
		"_isDisconnecting",					// Whether the unit is disconnecting vs regular autosave
		["_plrVarNames", []]                // Custom vars names to be obtained via getVariable
	];

	if (_unit isKindOf "MAN") then {
		_steamId = _unit getVariable "DMP_SteamID";
		
		_dbHandle = ["new", DMP_dbNamePlayers] call OO_INIDBI;
		_loadout = ["write", [_steamId, "inventory", getUnitLoadout _unit]] call _dbHandle;
		_pos = ["write", [_steamId, "position", getPosATL _unit]] call _dbHandle;
		_dir = ["write", [_steamId, "dir", getDir _unit]] call _dbHandle;
		_face = ["write", [_steamId, "face", face _unit]] call _dbHandle;
		
		// Custom variables dependent on getVariable
		{
			_varName = _x;
			_value = _unit getVariable [_varName, ""];
			
			if (typeName _value == "STRING") then {
				_value = [_value] call DMP_fnc_replaceLineFeeds;
			};
			
			["write", [_steamId, _varName, _value]] call _dbHandle;
		} forEach DMP_dbPlayerVarNames;
		
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

DMP_fnc_getPlayerVariableSteamId = {
	params ["_steamId", "_varName", ["_defaultValue", ""]];
	_dbHandle = ["new", DMP_dbNamePlayers] call OO_INIDBI;
	private _value = ["read",[_steamId, _varName,_defaultValue]] call _dbHandle;
	_value
};

DMP_fnc_setPlayerVariableSteamId = {
	params ["_steamId", "_varName", "_value", ["_applyToOnlinePlayer", false]];
	_dbHandle = ["new", DMP_dbNamePlayers] call OO_INIDBI;
	["write", [_steamId, _varName, _value]] call _dbHandle;
	
	if not _applyToOnlinePlayer exitWith {};
	
	private _player = [_steamId] call DMP_fnc_lookupPlayerOnlineSteamId;
	if (not isNull _player) then {
		_player setVariable [_varName, _value, true];
	};
};

DMP_fnc_lookupPlayerOnlineSteamId = {
	params ["_steamId"];
	
	private _result = objNull;
	{
		private _unitSteamId = _x getVariable ["DMP_SteamID", ""];
		if (_unitSteamId isEqualTo _steamId) exitWith { _result = _x };
	} forEach allPlayers;

	_result
};

DMP_fnc_getAllPersistentSteamIds = {
	_dbHandle = ["new", DMP_dbNamePlayers] call OO_INIDBI;
	_ids = "getSections" call _dbHandle;
	_ids
};