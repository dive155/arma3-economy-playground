fn_showDebtEditDialog = {
	params ["_player", "_countryName", "_invoker"];

	private _debts = _player getVariable ["rp_debts", []];
	private _existingDebt = 0;
	{
		if (_x select 0 isEqualTo _countryName) exitWith {
			_existingDebt = _x select 1;
		};
	} forEach _debts;

	private _countryLabel = localize ("STR_country" + _countryName);
	//private _dialogTitle = format [localize "STR_debtEditDialogTitle", _countryLabel, _existingDebt];
	private _dialogTitle = format [localize "STR_debtEditDialogTitle", localize ("STR_country" + _countryName), _existingDebt];
	private _desc = format [localize "STR_debtEditDialogDesc", localize ("STR_country" + _countryName)];

	private _operationOptions = ["FineIssuing", "ManualAccrualOfDebt" ,"DebtWriteOff"];
	private _operationPrettyNames = [
		localize "STR_operation_pretty_issue_fine",
		localize "STR_operation_pretty_add_debt",
		localize "STR_operation_pretty_write_off_debt"
	];
	private _editTitle = localize "STR_edit_title_amount";
	private _editDesc = localize "STR_edit_desc_amount";
	
	[_dialogTitle, [
		["LIST", [localize "STR_list_choose_operation", ""], [_operationOptions, _operationPrettyNames]],
		["EDIT", [_editTitle, _editDesc], ["0"]],
		["EDIT", [localize "STR_accountDialogReason", "STR_accountDialogReasonDesc"], [""]]
	], {
		params ["_values", "_args"];
		private ["_player", "_countryName", "_invoker"];
		_player = _args select 0;
		_countryName = _args select 1;
		_invoker = _args select 2;
		
		private _operation = _values select 0;
		private _valueStr = _values select 1;
		private _parsed = parseNumber _valueStr;
		private _note = _values select 2;

		// Validate input
		if (!(_valueStr regexMatch "^[0-9]+$")) exitWith {
			private _msg = format [localize "STR_debtEditErrorInvalid", _valueStr];
			hint _msg;
		};
		
		if (_operation == "DebtWriteOff") then {_parsed = -1 * _parsed;};
		[
			_player getVariable "DMP_SteamID",
			name player,
			_countryName,
			_operation,
			_parsed,
			_note
		] spawn fnc_handlePlayerDebtTransaction;

		private _msg = format [localize "STR_debtEditSuccess", localize ("STR_country" + _countryName), _parsed];
		hint _msg;
		
		_player spawn {
			params ["_player"];
			sleep 1;
			[_player] call fn_updateCivilianInfo; 
			[_player] call notifyPassportChanged;
		};

	}, {}, [_player, _countryName, _invoker]] call zen_dialog_fnc_create;
};

fn_applyDebtEditorPermission = {
	params ["_player", "_countryName"];
	[_countryName] remoteExec ["fn_applyDebtEditorPermissionLocal", _player];
};

fn_applyDebtEditorPermissionLocal = {
	params ["_countryName"];

	// Add permission to player
	private _perm = "debtEditing_" + _countryName;
	//[_perm] call fn_addPlayerPermLocal;

	call fn_createPassportEditingRootAction;

	// Action to edit debt for passport holder
	private _editDebt = {
		params ["_target", "_player", "_actionParams"];
		private _countryName = _actionParams select 0;
		[_target, _countryName, _player] call fn_showDebtEditDialog;
	};

	private _actionName = format [localize "STR_editDebtActionFormat", localize ("STR_country" + _countryName)];
	private _debtAction = [
		"EditDebtAction_" + _countryName,
		_actionName,
		"",
		_editDebt,
		{ [player, "debtEditing_" + ((_this select 2) select 0), true] call fnc_checkHasPermission },
		{},
		[_countryName]
	] call ace_interact_menu_fnc_createAction;

	["CAManBase", 0, ["ACE_MainActions", "PassportEditRoot"], _debtAction, true] call ace_interact_menu_fnc_addActionToClass;
	
	private _viewDebtHistory = {
		_this spawn {
			params ["_target", "_player", "_actionParams"];
			private _countryCode = _actionParams select 0;
			private _steamId = (_target getVariable "DMP_SteamID");
			[_steamId, _countryCode] spawn fnc_showPlayerDebtHistory;
		};
	};
	
	_actionName = format [localize "STR_viewOthersDebtActionFormat", localize ("STR_country" + _countryName)];
	private _viewDebtAction = [
		"ViewDebtAction_" + _countryName,
		_actionName,
		"",
		_viewDebtHistory,
		{ [player, "debtEditing_" + ((_this select 2) select 0), true] call fnc_checkHasPermission },
		{},
		[_countryName]
	] call ace_interact_menu_fnc_createAction;
	["CAManBase", 0, ["ACE_MainActions", "PassportEditRoot"], _viewDebtAction, true] call ace_interact_menu_fnc_addActionToClass;
};