[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_advance_day",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];
		
		[
			localize "STR_dive_pdr_day_advancing_settings", [
				["CHECKBOX", [localize "STR_dive_pdr_players_pay_interest_title", localize "STR_dive_pdr_players_pay_interest_desc"], [true]],
				["CHECKBOX", [localize "STR_dive_pdr_players_pay_taxes_title", localize "STR_dive_pdr_players_pay_taxes_desc"], [true]],
				["CHECKBOX", [localize "STR_dive_pdr_offline_players_work_title", localize "STR_dive_pdr_offline_players_work_desc"], [true]]
			], {
				params["_values","_arguments"];
				_values remoteExec ["fnc_advanceDayServer", 2];
			}, {}, [_pos, _object]
		] call zen_dialog_fnc_create;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

worldVariablesForZeusEditing = [
	"rpDay",
	"cityMoney",
	"interestRate_PDR",
	"interestRate_Moldova",
	"exchangeRate",
	"exchangeSpread",
	"gasStationOpen",
	"fuelPrice_PDR",
	"fuelInStorage",
	"factoryMoney",
	"factoryGoodsSellPrice",
	"factoryGoodsTax",
	"factoryBossCommission",
	"factoryOpen",
	"payFactory",
	"fatigueFactory",
	"quarryOpen",
	"payOre",
	"fatigueOre",
	"farmOpen",
	"payHay",
	"fatigueHay",
	"lunchPrice",
	"fuelInStorageMoldova",
	"fuelPrice_Moldova",
	"gasStationOpenMoldova"
];

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_world",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];
		
		private _initialVariablesText = [worldVariablesForZeusEditing, fnc_getWorldVariable] call fnc_getVariablesForEditing;
		
		[
			localize "STR_dive_pdr_module_edit_world", [
				["EDIT:MULTI",["Variables",""],[_initialVariablesText,{},40], true]
			], {
				params["_values","_arguments"];
				
				_pos = _arguments select 0;
				_object = _arguments select 1;
				_initialVariablesText = _arguments select 2;
				_modifiedVariablesText = _values select 0;
												
				[_initialVariablesText, _modifiedVariablesText, fnc_setWorldVariable] call fnc_setEditedVariables;
			}, {}, [_pos, _object, _initialVariablesText]
		] call zen_dialog_fnc_create;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

playerVariablesForZeusEditing = [
	//"rp_permissions",
	"grad_passport_passportRsc",
	"grad_passport_firstName",
	"grad_passport_lastName",
	"grad_passport_placeOfBirth",
	"grad_passport_dateOfBirth",
	"grad_passport_serial",
	"grad_passport_expires",
	"rp_fatigue_current",
	"rp_fatigue_capacity",
	"rp_daysSinceLastMeal"
];

fnc_getPlayerVariableZeus = {
	params ["_varName", "_playerArgs"];
	private _player = _playerArgs select 0;
	
	_player getVariable [_varName, ""]
};

fnc_setPlayerVariableZeus = {
	params ["_varName", "_value", "_playerArgs"];
	private _player = _playerArgs select 0;
	
	_player setVariable [_varName, _value, true];
};

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_player",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];
		
		if ((isNull _object) or {not isPlayer _object}) exitWith {
			[objNull, localize "STR_dive_pdr_module_hint_place_on_player"] call BIS_fnc_showCuratorFeedbackMessage;
		};
		
		private _initialVariablesText = [playerVariablesForZeusEditing, fnc_getPlayerVariableZeus, [_object]] call fnc_getVariablesForEditing;
		
		[
			localize "STR_dive_pdr_module_edit_player", [
				["EDIT:MULTI",["Variables",""],[_initialVariablesText,{},25], true]
			], {
				params["_values","_arguments"];
				
				_pos = _arguments select 0;
				_object = _arguments select 1;
				_initialVariablesText = _arguments select 2;
				_modifiedVariablesText = _values select 0;
												
				[_initialVariablesText, _modifiedVariablesText, fnc_setPlayerVariableZeus, [_object]] call fnc_setEditedVariables;
				
				[_object] spawn {
					params ["_object"];
					sleep 4;
					[_object] remoteExec ["DMP_fnc_forceSavePlayer", 2];
				};
				
			}, {}, [_pos, _object, _initialVariablesText]
		] call zen_dialog_fnc_create;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

allRpPermissions = [
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
	"visaGiving_Moldova",
	"sellingIndustrialGoods"
];

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_perms",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];

		if ((isNull _object) or {not isPlayer _object}) exitWith {
			[objNull, localize "STR_dive_pdr_module_hint_place_on_player"] call BIS_fnc_showCuratorFeedbackMessage;
		};

		private _currentPerms = _object getVariable ["rp_permissions", []];

		// Generate checkboxes for each permission
		private _checkboxes = [];
		{
			private _isChecked = _x in _currentPerms;
			_checkbox = ["CHECKBOX", [_x, _x], [_isChecked]];
			_checkboxes pushBack _checkbox;
		} forEach allRpPermissions;

		[
			localize "STR_dive_pdr_module_edit_perms", _checkboxes, {
				params ["_values", "_arguments"];
				private _pos = _arguments select 0;
				private _object = _arguments select 1;

				private _newPerms = [];
				{
					if (_x) then {
						_newPerms pushBack (allRpPermissions select _forEachIndex);
					};
				} forEach _values;

				_object setVariable ["rp_permissions", _newPerms, true];
				[_object] spawn {
					params ["_object"];
					sleep 4;
					[_object] remoteExec ["DMP_fnc_forceSavePlayer", 2];
					[] remoteExec ["fnc_updatePermissionsBasedActions", _object];
				};

			}, {}, [_pos, _object]
		] call zen_dialog_fnc_create;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_passport",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];

		if ((isNull _object) or {not isPlayer _object}) exitWith {
			[objNull, localize "STR_dive_pdr_module_hint_place_on_player"] call BIS_fnc_showCuratorFeedbackMessage;
		};

		[_object, player] call fn_showPlayerEditDialog;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_debt_pdr",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];

		if ((isNull _object) or {not isPlayer _object}) exitWith {
			[objNull, localize "STR_dive_pdr_module_hint_place_on_player"] call BIS_fnc_showCuratorFeedbackMessage;
		};

		[_object, "PDR", player] call fn_showDebtEditDialog;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_view_debt_pdr",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];

		if ((isNull _object) or {not isPlayer _object}) exitWith {
			[objNull, localize "STR_dive_pdr_module_hint_place_on_player"] call BIS_fnc_showCuratorFeedbackMessage;
		};
		
		private _steamId = (_object getVariable "DMP_SteamID");
		[_steamId, "PDR"] spawn fnc_showPlayerDebtHistory;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_debt_moldova",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];

		if ((isNull _object) or {not isPlayer _object}) exitWith {
			[objNull, localize "STR_dive_pdr_module_hint_place_on_player"] call BIS_fnc_showCuratorFeedbackMessage;
		};

		[_object, "Moldova", player] call fn_showDebtEditDialog;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_view_debt_moldova",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];

		if ((isNull _object) or {not isPlayer _object}) exitWith {
			[objNull, localize "STR_dive_pdr_module_hint_place_on_player"] call BIS_fnc_showCuratorFeedbackMessage;
		};
		
		private _steamId = (_object getVariable "DMP_SteamID");
		[_steamId, "Moldova"] spawn fnc_showPlayerDebtHistory;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_number_plate",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];
		
		if ((isNull _object) or {(_object isKindOf "Man") or {not (_object isKindOf "LandVehicle" or _object isKindOf "Air" or _object isKindOf "Ship")}}) exitWith {
			[objNull, localize "STR_dive_pdr_module_hint_place_on_vehicle"] call BIS_fnc_showCuratorFeedbackMessage;
		};
		
		private _initialPlate = getPlateNumber _object;
		
		systemchat _initialPlate;
		
		[
			localize "STR_dive_pdr_edit_plate_title", [
				["EDIT", [localize "STR_dive_pdr_edit_plate_title", ""], [_initialPlate], true]
			], {
				params["_values","_arguments"];
				
				_pos = _arguments select 0;
				_object = _arguments select 1;
				
				_newPlate = _values select 0;
				
				[_object, _newPlate] remoteExec ["setPlateNumber", _object];
				
				hint format[localize "STR_dive_pdr_edit_plate_result", _newPlate];
				
			}, {}, [_pos, _object]
		] call zen_dialog_fnc_create;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;