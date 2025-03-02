params ["_unit"];

if (_unit isKindOf "MAN") then {
	_namePlr = _unit getVariable "KRV_playerID";
	
	_player_SaveDBLocal = ["new", dbNamePlayers] call OO_INIDBI;
	
	// No data yet for this player - skipping.
	_sections = "getSections" call _player_SaveDBLocal;
	if not (_namePlr in _sections) exitWith {}; 
	
	_inv = ["read",[_namePlr, "plrStuff",[]]] call _player_SaveDBLocal;
	_pos = ["read",[_namePlr, "plrPosition",[]]] call _player_SaveDBLocal;
	_vars = ["read",[_namePlr, "plrVariables",[]]] call _player_SaveDBLocal;
	_varsWeap = ["read",[_namePlr, "plrSecondWeapon",[]]] call _player_SaveDBLocal;
	
	sleep 0.1;
	_unit setUnitLoadout _inv;
	
	sleep 0.1;
	_unit setPosATL _pos;
	_var = _vars select 0;
	[_unit, _var] remoteExec ["setFace",0];
	
	sleep 0.1;
	if (count _varsWeap == 0) exitWith {};
	[[_unit,_varsWeap],WBK_CreateWeaponSecond_scripted] remoteExec ["spawn",_unit];
};

