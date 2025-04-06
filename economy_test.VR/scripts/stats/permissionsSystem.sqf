_allPermissions = [
	"cooking"
];

permissionsVarName = "rp_permissions";

fnc_addPermission = {
	params["_permName"];
	
	_perms = player getVariable [permissionsVarName, []];
	_perms pushBackUnique _permName;
	player setVariable [permissionsVarName, _perms, true];
};

fnc_checkHasPermission = {
	params["_permName", ["_showHintOnFailure", false]];
	
	_perms = player getVariable [permissionsVarName, []];
	_hasPerm = _permName in _perms;
	
	if ((not _hasPerm) and _showHintOnFailure) then {
		hint((localize "STR_permissionMissing") + (localize (format ["STR_permission_%1", _permName])));
	};
	
	_hasPerm
};

fnc_removePermission = {
	params ["_permName"];
	
	_perms = player getVariable [permissionsVarName, []];
	_perms = _perms - [_permName];
	player setVariable [permissionsVarName, _perms, true];
};