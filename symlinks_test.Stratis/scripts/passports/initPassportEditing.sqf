fn_showPlayerEditDialog = {
	/*
		Function: fn_showPlayerEditDialog.sqf

		Parameters:
		0: OBJECT - The player to edit
		1: OBJECT - The invoker (admin or other)

		Usage:
		[targetPlayer, adminPlayer] call fn_showPlayerEditDialog;
	*/

	params ["_player", "_invoker"];

	// Load current values
	private _govtJob = _player getVariable ["rp_govtjob", ""];
	private _govtSalary = str (_player getVariable ["rp_govtsalary", 0]);
	private _dailyBills = str (_player getVariable ["rp_dailybills", 0]);
	private _regAddress = _player getVariable ["rp_registrationaddress", ""];
	private _ownedProps = (_player getVariable ["rp_ownedproperties", []]) joinString toString [10];
	private _regVehicles = (_player getVariable ["rp_registeredvehicles", []]) joinString toString [10];
	private _passportNotes = (_player getVariable ["rp_passportnotes", []]) joinString toString [10];

	[
		localize "STR_editPlayerDataHeader",
		[
			["EDIT", [format [localize "STR_govtJobFormat", ""], localize "STR_editDescGovtJob"], [_govtJob], true],
			["EDIT", [format [localize "STR_govtSalaryFormat", ""], localize "STR_editDescGovtSalary"], [_govtSalary], true],
			["EDIT", [format [localize "STR_dailyBills", ""], localize "STR_editDescDailyBills"], [_dailyBills], true],
			["EDIT", [localize "STR_registrationAddress", localize "STR_editDescRegAddress"], [_regAddress], true],
			["EDIT:MULTI", [localize "STR_ownedProperty", localize "STR_editDescOwnedProps"], [_ownedProps], true],
			["EDIT:MULTI", [localize "STR_registeredVehicles", localize "STR_editDescRegVehicles"], [_regVehicles], true],
			["EDIT:MULTI", [localize "STR_passportNotes", localize "STR_editDescPassportNotes"], [_passportNotes], true]
		],
		{
			params ["_values", "_args"];
			private _player = _args select 0;
			private _invoker = _args select 1;

			if (!((_values select 1) call fn_rpIsNumber) || !((_values select 2) call fn_rpIsNumber)) exitWith {
				["STR_editErrorInvalidNumbers"] remoteExec ["fn_hintLocalized", _invoker];
			};

			private _salary = parseNumber (_values select 1);
			private _bills = parseNumber (_values select 2);

			// Parse multiline edits into arrays, trim whitespace, filter empty
			private _parseArray = {
				(_this splitString toString [10]) apply {trim _x} select {_x != ""}
			};

			private _ownedPropsArr = (_values select 4) call _parseArray;
			private _regVehiclesArr = (_values select 5) call _parseArray;
			private _notesArr = (_values select 6) call _parseArray;

			// Save all variables
			_player setVariable ["rp_govtjob", _values select 0, true];
			_player setVariable ["rp_govtsalary", _salary, true];
			_player setVariable ["rp_dailybills", _bills, true];
			_player setVariable ["rp_registrationaddress", _values select 3, true];
			_player setVariable ["rp_ownedproperties", _ownedPropsArr, true];
			_player setVariable ["rp_registeredvehicles", _regVehiclesArr, true];
			_player setVariable ["rp_passportnotes", _notesArr, true];
			
			[_player] call fn_updateCivilianInfo; 
			
			["STR_editSuccess"] remoteExec ["fn_hintLocalized", _invoker];
			[_player] call notifyPassportChanged;
		},
		{},
		[_player, _invoker]
	] call zen_dialog_fnc_create;
};

fn_applyPassportEditorPermission = {
	params ["_player", "_countryName"];
	[_countryName] remoteExec ["fn_applyPassportEditorPermissionLocal", _player];
};

fn_applyPassportEditorPermissionLocal = {
	params ["_countryName"];

	// Add permission to caller
	private _perm = "passportEditing_" + _countryName;
	//[_perm] call fn_addPlayerPermLocal;
	
	call fn_createPassportEditingRootAction;

	// Add the single universal edit action if not already created
	if (isNil "passport_edit_action") then {
		passport_edit_action = [
			"EditAnyPassport",
			localize "STR_editAnyPassportAction",
			"",
			{
				params ["_target", "_caller"];

				private _passportRsc = _target getVariable ["grad_passport_passportRsc", ""];
				private _country = _passportRsc select [8]; // strips "passport" prefix
				private _perm = "passportEditing_" + _country;
				private _callerPerms = _caller getVariable ["rp_permissions", []];
				
				if (_perm in _callerPerms) then {
					[_target, _caller] call fn_showPlayerEditDialog;
				} else {
					hint format [localize "STR_editErrorWrongCountry", _country];
				};
			},
			{ true },
			{}
		] call ace_interact_menu_fnc_createAction;

		["CAManBase", 0, ["ACE_MainActions", "PassportEditRoot"], passport_edit_action, true] call ace_interact_menu_fnc_addActionToClass;
	};
};