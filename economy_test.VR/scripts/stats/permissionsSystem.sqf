permissionsVarName = "rp_permissions";

fnc_addPermission = {
	params["_player", "_permName"];
	
	_perms = _player getVariable [permissionsVarName, []];
	_perms pushBackUnique _permName;
	_player setVariable [permissionsVarName, _perms, true];
};

fnc_checkHasPermission = {
	params["_player", "_permName", ["_showHintOnFailure", false]];
	
	_perms = _player getVariable [permissionsVarName, []];
	_hasPerm = _permName in _perms;
	
	if ((not _hasPerm) and _showHintOnFailure) then {
		hint((localize "STR_permissionMissing") + " " + (localize (format ["STR_permission_%1", _permName])));
	};
	
	_hasPerm
};

fnc_removePermission = {
	params ["_player", "_permName"];
	
	_perms = _player getVariable [permissionsVarName, []];
	_perms = _perms - [_permName];
	_player setVariable [permissionsVarName, _perms, true];
};

if not hasInterface exitWith {};

_allPermissions = [
	"cooking",
	"accountFull_cityMoney",
	"accountRead_cityMoney",
	"accountFull_factoryMoney",
	"accountRead_factoryMoney",
	"debtEditing_PDR",
	"debtEditing_Moldova",
	"passportEditing_PDR",
	"passportEditing_Moldova",
	"visaGiving_PDR",
	"visaGiving_Moldova"
];

_permActions = [
	["debtEditing_PDR", {["PDR"] call fn_applyDebtEditorPermissionLocal}],
	["debtEditing_Moldova", {["Moldova"] call fn_applyDebtEditorPermissionLocal}],
	["passportEditing_PDR", {["PDR"] call fn_applyPassportEditorPermissionLocal}],
	["passportEditing_Moldova", {["Moldova"] call fn_applyPassportEditorPermissionLocal}],
	["visaGiving_PDR", {["PDR"] call fn_applyVisaGiverPermissionsLocal}],
	["visaGiving_Moldova", {["Moldova"] call fn_applyVisaGiverPermissionsLocal}]
];

addedPermissionsActions = [];
fnc_updatePermissionsBasedActions = {
    private _perms = player getVariable [permissionsVarName, []];

    {
        private _permKey = _x select 0;
        private _action = _x select 1;

        if ((_permKey in _perms) and not (_permKey in addedPermissionsActions)) then {
            // Execute the function
            call _action;

            // Add to the list of added permissions to avoid duplicate execution
            addedPermissionsActions pushBackUnique _permKey;
        };
    } forEach _permActions;
};

//sleep 10;
sleep 3;
call fnc_updatePermissionsBasedActions;
