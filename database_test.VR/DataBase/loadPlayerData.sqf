params [ "_unit" ];

if (_unit isKindOf "MAN") then {
	_namePlr = _unit getVariable "KRV_playerID";
	
	_player_SaveDBLocal = ["new", dbNamePlayers] call OO_INIDBI;
	
	// No data yet for this player - skipping.
	_sections = "getSections" call _player_SaveDBLocal;
	
	// -1 means new player
	//if not (_namePlr in _sections) exitWith { -1 }; 
	if not (_namePlr in _sections) exitWith { }; 
	
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

