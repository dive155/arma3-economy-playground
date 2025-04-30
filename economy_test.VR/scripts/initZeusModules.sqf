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