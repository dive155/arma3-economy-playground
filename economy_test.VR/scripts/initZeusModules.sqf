[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_advance_day",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];
		
		[
			localize "STR_dive_pdr_day_advancing_settings", [
				["CHECKBOX", [localize "STR_dive_pdr_players_pay_interest_title", localize "STR_dive_pdr_players_pay_interest_desc"], [true]],
				["CHECKBOX", [localize "STR_dive_pdr_players_pay_taxes_title", localize "STR_dive_pdr_players_pay_taxes_desc"], [true]],
				["CHECKBOX", [localize "STR_dive_pdr_offline_players_work_title", localize "STR_dive_pdr_offline_players_work_desc"], [true]],
				["CHECKBOX", [localize "STR_dive_pdr_mark_services_unpaid", ""], [true]],
				["CHECKBOX", [localize "STR_dive_pdr_pay_for_npcs", ""], [true]]
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
	"moldovaMoney",
	"interestRate_PDR",
	"interestRate_Moldova",
	"inflationCoef_PDR",
	"inflationCoef_Moldova",
	"salesTaxPdr",
	"salesTaxMoldova",
	"exchangeRate",
	"exchangeSpread",
	"lunchPrice",
	"services_priceTram",
	"services_paidTram",
	"services_priceStreetlights",
	"services_paidStreetlights",
	"services_priceSpeedtraps",
	"services_paidSpeedtraps",
	"speedTrapsEnabled", 
	"speedingFineLow",
	"speedingFineHigh",
	"noiseEnabled",
	"noiseMinDelay",
	"noiseMaxDelay",
	"autoBorderEnabled",
	"autoBorderChance",
	"autoBorderForPDRans",
	"autoBorderForMoldovans",
	"autoBoomgatesEnabled",
	"cityNpcPayment"
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

worldVariablesForZeusEditing2 = [
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
	"fuelInStorageMoldova",
	"fuelPrice_Moldova",
	"gasStationOpenMoldova",
	"canBuyMoldovaLeu",
	"canBuyPdrLeu",
	"factoryNpcPayment"
];

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_edit_world2",
	{
		params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];
		
		private _initialVariablesText = [worldVariablesForZeusEditing2, fnc_getWorldVariable] call fnc_getVariablesForEditing;
		
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
	"rp_energized",
	"rp_daysSinceLastMeal",
	"rp_checkupPending",
	"rp_weaponSkill"
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
	localize "STR_dive_pdr_module_title_player",
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
	"accountFull_moldovaMoney",
	"accountRead_moldovaMoney",
	"debtEditing_PDR",
	"debtEditing_Moldova",
	"passportEditing_Pdr",
	"passportEditing_Moldova",
	"visaGiving_PDR",
	"visaGiving_Moldova",
	"visaGiving_Horsk",
	"sellingIndustrialGoods",
	"numberplateEditing",
	"moonshine",
	"carParts"
];

[
	localize "STR_dive_pdr_module_title_player",
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
	localize "STR_dive_pdr_module_title_player",
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
	localize "STR_dive_pdr_module_title_player",
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
	localize "STR_dive_pdr_module_title_player",
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
	localize "STR_dive_pdr_module_title_player",
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
	localize "STR_dive_pdr_module_title_player",
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
		
		[_object] call fnc_modifyNumberPlate;
	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;

[
	localize "STR_dive_pdr_module_title",
	localize "STR_dive_pdr_module_toggle_tram",
	{
		params [["_pos", [0,0,0], [[]], 3], ["_object", objNull, [objNull]]];

		private _tramEnabled = missionNamespace getVariable ["PDR_tram_enabled", false];
		private _lightsPDR = ["PDR"] call fnc_areLightsOn;
		private _lightsMoldova = ["Moldova"] call fnc_areLightsOn;
		private _offroadDamage = ["offroadDamage"] call fnc_getWorldVariable;
		private _partyActive = missionNamespace getVariable ["DIVE_partyActive", false];
		private _partyMusic = missionNamespace getVariable ["DIVE_partyMusicEnabled", false];

		[
			localize "STR_dive_pdr_tram_lights_settings", [
				["CHECKBOX", [localize "STR_dive_pdr_tram_enabled", localize "STR_dive_pdr_tram_enabled_desc"], [_tramEnabled], true],
				["CHECKBOX", [localize "STR_dive_pdr_lights_enabled_pdr", localize "STR_dive_pdr_lights_enabled_pdr_desc"], [_lightsPDR], true],
				["CHECKBOX", [localize "STR_dive_pdr_lights_enabled_moldova", localize "STR_dive_pdr_lights_enabled_moldova_desc"], [_lightsMoldova], true],
				["CHECKBOX", [localize "STR_dive_pdr_offroad_damage", ""], [_offroadDamage], true],
				["CHECKBOX", [localize "STR_dive_pdr_party_active", localize "STR_dive_pdr_party_active_desc"], [_partyActive], true],
				["CHECKBOX", [localize "STR_dive_pdr_party_music", localize "STR_dive_pdr_party_music_desc"], [_partyMusic], true]
			], {
				params ["_values", "_arguments"];

				private _tramNew = _values select 0;
				private _pdrLightsNew = _values select 1;
				private _moldovaLightsNew = _values select 2;
				private _offroadDamage = _values select 3;
				private _partyActiveNew = _values select 4;
				private _partyMusicNew = _values select 5;

				private _tramOld = missionNamespace getVariable ["PDR_tram_enabled", false];
				if (_tramNew != _tramOld) then {
					if (_tramNew) then {
						[] remoteExec ["fnc_startTram", 2];
					} else {
						[] remoteExec ["fnc_stopTram", 2];
					};
				};

				if (_pdrLightsNew != (["PDR"] call fnc_areLightsOn)) then {
					["PDR", _pdrLightsNew] remoteExec ["fnc_setLightsServer", 2];
					//[_pdrLightsNew] remoteExec ["fnc_showTrafficLightsServer", 2];
				};

				if (_moldovaLightsNew != (["Moldova"] call fnc_areLightsOn)) then {
					["Moldova", _moldovaLightsNew] remoteExec ["fnc_setLightsServer", 2];
				};

				["offroadDamage", _offroadDamage] call fnc_setWorldVariable;

				private _partyActiveOld = missionNamespace getVariable ["DIVE_partyActive", false];
				if (_partyActiveNew != _partyActiveOld) then {
					if (_partyActiveNew) then {
						[] spawn fnc_startPartyCommand;
					} else {
						[] spawn fnc_stopPartyCommand;
					};
				};

				private _partyMusicOld = missionNamespace getVariable ["DIVE_partyMusicEnabled", false];
				if (_partyMusicNew != _partyMusicOld) then {
					if (_partyMusicNew) then {
						[] remoteExec ["fn_startMusicServer", 2];
					} else {
						[] remoteExec ["fn_stopMusicServer", 2];
					};
				};

			}, {}, [_pos, _object]
		] call zen_dialog_fnc_create;

	}, "hud\pdr_module.paa"
] call zen_custom_modules_fnc_register;
