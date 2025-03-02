_unit = _this select 0;
if (_unit isKindOf "MAN") then {
	_namePlr = _unit getVariable "KRV_playerID";
	_player_SaveDBLocal = ["new", dbNamePlayers] call OO_INIDBI;
	_loadout = ["write", [_namePlr, "plrStuff", getUnitLoadout _unit]] call _player_SaveDBLocal;
	_pos = ["write", [_namePlr, "plrPosition", getPosATL _unit]] call _player_SaveDBLocal;
	_dir = ["write", [_namePlr, "plrDirection", getDir _unit]] call _player_SaveDBLocal;
	_plrvars = [face _unit];
	_vars = ["write", [_namePlr, "plrVariables", _plrvars]] call _player_SaveDBLocal;
	
	if (!(isNil {_unit getVariable "WBK_SecondWeapon"})) then {
		_crate = (_unit getVariable "WBK_SecondWeapon") select 0;
		deleteVehicle _crate;
		_plSecWeap = (_unit getVariable "WBK_SecondWeapon") select 1;
		_varsWeap = ["write", [_namePlr, "plrSecondWeapon", _plSecWeap]] call _player_SaveDBLocal;
	};
	sleep 2;
	deleteVehicle _unit;
};