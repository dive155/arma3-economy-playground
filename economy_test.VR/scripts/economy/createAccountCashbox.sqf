params [
	"_buttonObject",            // Button to press
	"_moneyBox",                // Put money here
	"_accountID",
	"_currencyCode",            // Only this currency is accepted
	["_accountMoneyGetter", {100}],   // Delegate to check account balance
	["_accountMoneySetter", {params ["_moneyAmount"];}], // Delegate to set account balance
	["_extraCondition", {true}], // Check if player has access
	["_handleJournaling", {params ["_playerName", "_operationType", "_amount", "_playersNote"]}],
	["_logsAccessCondition", { true }]
	
];

if (isServer) then {
	_buttonObject setVariable ["accountExtraCondition", _extraCondition, true];
	_buttonObject setVariable ["accountMoneyGetter", _accountMoneyGetter, true];
	_buttonObject setVariable ["accountMoneySetter", _accountMoneySetter, true];
	_buttonObject setVariable ["accountJournalHandler", _handleJournaling, true];
	_buttonObject setVariable ["moneyBox", _moneyBox, true];
	_buttonObject setVariable ["accountID", _accountID, true];
	_buttonObject setVariable ["logsAccessCondition", _logsAccessCondition, true];
};

if (isNil "fnc_isNumeric") then {
	fnc_isNumeric = {
		params ["_str"];
		_str regexMatch "^[0-9]+$"
	};
};

if (isNil "fnc_launchAccountDialog") then {
	fnc_launchAccountDialog = {
		params ["_player", "_isWithdrawal", "_buttonObject", "_currencyCode"];

		private _accountGetter = _buttonObject getVariable ["accountMoneyGetter", {0}];
		private _accountSetter = _buttonObject getVariable ["accountMoneySetter", {params["_v"];}];
		private _journalHandler = _buttonObject getVariable ["accountJournalHandler", {params["_a","_b","_c"];}];
		private _extraCondition = _buttonObject getVariable ["accountExtraCondition", {true}];
		private _moneyBox = _buttonObject getVariable ["moneyBox", objNull];
		
		if (!([_player] call _extraCondition)) exitWith {
			//hint localize "STR_accountDialogNoAccess";
		};

		private _accountBalance = call _accountGetter;
		private _accountID = _buttonObject getVariable ["accountID", "unknown"];
		private _accountName = localize ("STR_account_" + _accountID);

		private _dialogTitle = if (_isWithdrawal) then {
			format [localize "STR_accountDialogWithdrawTitle", _accountName, _accountBalance]
		} else {
			format [localize "STR_accountDialogDepositTitle", _accountName, _accountBalance]
		};

		private _desc = if (_isWithdrawal) then {
			localize "STR_accountDialogWithdrawDesc"
		} else {
			localize "STR_accountDialogDepositDesc"
		};

		private _checkboxLabel = if (_isWithdrawal) then {
			localize "STR_accountDialogWithdrawAll"
		} else {
			localize "STR_accountDialogDepositAll"
		};

		[
			_dialogTitle,
			[
				["EDIT", [localize "STR_accountAmount", _desc], ["0"]],
				["CHECKBOX", [_checkboxLabel, ""], false],
				["EDIT", [localize "STR_accountDialogReason", localize "STR_accountDialogReasonDesc"], [""]]
			],
			{
				params ["_values", "_args"];
				private ["_player", "_isWithdrawal", "_moneyBox", "_currencyCode", "_accountGetter", "_accountSetter", "_journalHandler"];

				_player = _args select 0;
				_isWithdrawal = _args select 1;
				_moneyBox = _args select 2;
				_currencyCode = _args select 3;
				_accountGetter = _args select 4;
				_accountSetter = _args select 5;
				_journalHandler = _args select 6;

				private _amountStr = _values select 0;
				private _useFullAmount = _values select 1;
				private _comment = _values select 2;

				private _accountMoney = call _accountGetter;
				private _moneyInBox = [_moneyBox, _currencyCode] call fnc_getMoneyAmountInContainer;
				private _validAmount = 0;

				if (_isWithdrawal) then {
					if (_useFullAmount) then {
						_validAmount = _accountMoney;
					} else {
						if not ([_amountStr] call fnc_isNumeric) exitWith {
							hint format [localize "STR_accountDialogError", _amountStr];
						};
						_validAmount = parseNumber _amountStr;
					};
					
					if (_validAmount > _accountMoney) exitWith {
						hint localize "STR_accountDialogNotEnoughInAccount";
					};
					
					private _newBalance = _accountMoney - _validAmount;
					[_newBalance] call _accountSetter;
					[_moneyBox, _currencyCode, _validAmount] call fnc_putMoneyIntoContainer;
					
					[name _player, "Withdrawal", _validAmount, _newBalance, _comment] call _journalHandler;
					hint format [localize "STR_accountDialogSuccess", _validAmount, localize format ["STR_%1", _currencyCode]];
				} else {
					if (_useFullAmount) then {
						_validAmount = _moneyInBox;
					} else {
						if not ([_amountStr] call fnc_isNumeric) exitWith {
							hint format [localize "STR_accountDialogError", _amountStr];
						};
						_validAmount = parseNumber _amountStr;
					};

					if (_validAmount > _moneyInBox) exitWith {
						hint localize "STR_accountDialogNotEnoughInBox";
					};

					private _newBalance = _accountMoney + _validAmount;
					[_newBalance] call _accountSetter;
					[_moneyBox, _currencyCode, _validAmount] call fnc_takeMoneyFromContainer;
					
					[name _player, "Deposit", _validAmount, _newBalance, _comment] call _journalHandler;
					hint format [localize "STR_accountDialogSuccess", _validAmount, localize format ["STR_%1", _currencyCode]];
				};
			},
			{},
			[_player, _isWithdrawal, _moneyBox, _currencyCode, _accountGetter, _accountSetter, _journalHandler]
		] call zen_dialog_fnc_create;
	};
};

if (isNil "fnc_launchAccountJournalDialog") then {
	fnc_launchAccountJournalDialog = {
		params ["_buttonObject"];
		private _accountID = _buttonObject getVariable ["accountID", "unknown"];
		private _accessCondition = _buttonObject getVariable ["logsAccessCondition", {true}];
		
		if (call _accessCondition) then {
			private _header = "<t align='center'><t size='1.5'>" + (localize "STR_transactions_title") + "<t color='#caf5c4'> " + (localize ("STR_account_" + _accountID)) + "</t></t></t><br/><br/>";
			["accountJournal_" + _accountID, _header] call fnc_requestAndShowJournal;
		};
	}
};

if (hasInterface) then {
	private _accountRootAction = ["AccountRoot", localize "STR_accountActionRoot", "", {}, {true}] call ace_interact_menu_fnc_createAction;

	private _createAction = {
		params ["_id", "_label", "_isWithdrawal", "_buttonObject", "_currencyCode"];
		
		[_id, _label, "", {
			params ["_isWithdrawal", "_buttonObject", "_currencyCode"];
			[player, _isWithdrawal, _buttonObject, _currencyCode] call fnc_launchAccountDialog;
		}, {true}, {}, [_isWithdrawal, _buttonObject, _currencyCode]] call ace_interact_menu_fnc_createAction;
	};

	private _withdrawAction = ["AccountWithdraw", localize "STR_accountActionWithdraw", "", {
			(_this select 2) params ["_isWithdrawal", "_buttonObject", "_currencyCode"];
			[player, _isWithdrawal, _buttonObject, _currencyCode] call fnc_launchAccountDialog;
	}, {true}, {}, [true, _buttonObject, _currencyCode]] call ace_interact_menu_fnc_createAction;

	private _depositAction = ["AccountDeposit", localize "STR_accountActionDeposit", "", {
			(_this select 2) params ["_isWithdrawal", "_buttonObject", "_currencyCode"];
			[player, _isWithdrawal, _buttonObject, _currencyCode] call fnc_launchAccountDialog;
	}, {true}, {}, [false, _buttonObject, _currencyCode]] call ace_interact_menu_fnc_createAction;
	
	private _journalAction = ["AccountJournal", localize "STR_accountActionJournal", "", {
			(_this select 2) params ["_buttonObject"];
			[_buttonObject] spawn fnc_launchAccountJournalDialog;
	}, {true}, {}, [_buttonObject]] call ace_interact_menu_fnc_createAction;

	[_buttonObject, 0, [], _accountRootAction] call ace_interact_menu_fnc_addActionToObject;
	[_buttonObject, 0, ["AccountRoot"], _withdrawAction] call ace_interact_menu_fnc_addActionToObject;
	[_buttonObject, 0, ["AccountRoot"], _depositAction] call ace_interact_menu_fnc_addActionToObject;
	[_buttonObject, 0, ["AccountRoot"], _journalAction] call ace_interact_menu_fnc_addActionToObject;
};
