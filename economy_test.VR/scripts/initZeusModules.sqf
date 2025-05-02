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

	}, "\DiceRollByDive\ui\d8_small.paa"
] call zen_custom_modules_fnc_register;

worldVariablesForZeusEditing = [
	"rpDay",
	"cityMoney",
	"interestRate_PDR",
	"interestRate_Moldova",
	"exchangeRate",
	"exchangeSpread",
	"fuelPrice_PDR",
	"fuelInStorage",
	"factoryMoney",
	"factoryGoodsSellPrice",
	"factoryGoodsTax",
	"factoryBossCommission",
	"payFactory",
	"fatigueFactory",
	"payOre",
	"fatigueOre",
	"payHay",
	"fatigueHay",
	"lunchPrice"
];

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_world",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];
		
		private _initialVariablesText = [worldVariablesForZeusEditing, fnc_getWorldVariable] call fnc_getVariablesForEditing;
		
		[
			localize "STR_dive_pdr_module_edit_world", [
				["EDIT:MULTI",["Variables",""],[_initialVariablesText,{},25], true]
			], {
				params["_values","_arguments"];
				
				_pos = _arguments select 0;
				_object = _arguments select 1;
				_initialVariablesText = _arguments select 2;
				_modifiedVariablesText = _values select 0;
												
				[_initialVariablesText, _modifiedVariablesText, fnc_setWorldVariable] call fnc_setEditedVariables;
			}, {}, [_pos, _object, _initialVariablesText]
		] call zen_dialog_fnc_create;

	}, "\DiceRollByDive\ui\d8_small.paa"
] call zen_custom_modules_fnc_register;

playerVariablesForZeusEditing = [
	//"rp_permissions",
	"grad_passport_firstName",
	"grad_passport_passportRsc",
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

	}, "\DiceRollByDive\ui\d8_small.paa"
] call zen_custom_modules_fnc_register;