// TODO this does not belong here?
_scriptHandle = execVM "scripts\helpers\cityHelpers.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\helpers\factoryHelpers.sqf";
waitUntil { scriptDone _scriptHandle };

// Hay to Agricultural Products Converter
[
	hay_button,
	[[hay_trigger, "DIVE_Haystack", false]],
	hay_output_box,
	hay_money_box,
	[["b_dive_grain_bag", 1]],
	industrialConverterSoundsConfig,
	["STR_hay_converter_action", "STR_hay_converter_success", "STR_hay_converter_failure"],
	8,
	{ // Get pay config
		[currencyCodePdrLeu, "payHay" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueHay", "farmOpen", hay_money_box] call fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueHay"] call  fnc_handleConverterWorkCompleted;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Ore to Minerals Converter
[
	ore_button,
	[[ore_trigger, "DIVE_OreRock", false]],
	ore_output_box,
	ore_money_box,
	[["b_dive_ore_bag", 1]],
	industrialConverterSoundsConfig,
	["STR_ore_converter_action", "STR_ore_converter_success", "STR_ore_converter_failure"],
	8,
	{ // Get pay config
		[currencyCodePdrLeu, "payOre" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueOre", "quarryOpen", ore_money_box] call fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueOre"] call  fnc_handleConverterWorkCompleted;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Factory
[
	factory_button,
	[
		[factory_hay_trigger, "b_dive_grain_bag", true], 
		[factory_ore_trigger, "b_dive_ore_bag", true]
	],
	factory_goods_box,
	factory_money_box,
	[["b_dive_goods_bag",1]],
	industrialConverterSoundsConfig,
	["STR_factory_action", "STR_factory_success", "STR_factory_failure"],
	8,
	{ // Get pay config
		[currencyCodePdrLeu, "payFactory" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueFactory", "factoryOpen", factory_money_box] call fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueFactory"] call  fnc_handleConverterWorkCompleted;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Selling goods
[
	goods_button,
	[[factory_goods_box, "b_dive_goods_bag", false]],
	objNull,
	objNull,
	[["",0]],
	industrialConverterSoundsConfig,
	["STR_goods_action", "", "STR_goods_failure"],
	1,
	{ // Get pay config
		["", 0]
	},
	{ // Extra condition
		[player, "sellingIndustrialGoods", true] call fnc_checkHasPermission;
	},
	{ // On work completed
		call fnc_sellProducedFactoryGoods;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Cafe stove
[
	stove,
	[[stove_input_box, "b_dive_grain_bag", false]],
	stove_output_box,
	objNull,
	[["pdr_lunch_full", 8]],
	["pdrstuff\sounds\stove_ignition.ogg", "pdrstuff\sounds\stove_cooking.ogg", "pdrstuff\sounds\stove_failure.ogg", ""],
	["STR_stove_action", "STR_stove_success", "STR_stove_failure"],
	16,
	{["", 0]},
	{ // Extra condition
		[player, "cooking", true] call fnc_checkHasPermission;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

[
	moonshine_button,
	[[moonshine_input_box, "b_dive_grain_bag", false]],
	moonshine_output_box,
	objNull,
	[
		["pdr_moonshine_pear", 4],
		["pdr_moonshine_plum", 4],
		["pdr_moonshine_apple", 4]
	],
	[
		"\z\ace\addons\refuel\sounds\nozzle_start.ogg",
		"pdrstuff\sounds\stove_cooking.ogg",
		"pdrstuff\sounds\machine_error.ogg",
		""
	],
	["STR_moonshine_crafter_action", "STR_moonshine_crafter_success", "STR_moonshine_crafter_failure"],
	16,
	{["", 0]},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 		
		private _hasEnergy = [player, 1] call fnc_checkIfNotTooFatigued;
		private _hasPerms = [player, "moonshine", true] call fnc_checkHasPermission;
		_hasEnergy and _hasPerms
	},
	{
		[player, 1] call fnc_increasePlayerFatigue;
		[] remoteExec ["fnc_showMoonshineSmokeServer", 2];
	}
]execVM "scripts\economy\createResourceConverter.sqf";

if (isServer) then {
	private _pos = getPosWorld moonshine_smoke;
	moonshine_smoke setVariable ["initialPos", _pos, true];
	moonshine_smoke setVariable ["smokeEndTime", 0, true];
	moonshine_smoke setPosWorld [0, 0, 0];
};

fnc_showMoonshineSmokeServer = {
	private _cookTime = 15;
	private _endTime = moonshine_smoke getVariable "smokeEndTime";
	if (_endTime > serverTime) then {
		// Already smoking
		_endTime = _endTime + _cookTime;
		moonshine_smoke setVariable ["smokeEndTime", _endTime, true];
	} else {
		// Not smoking
		private _showPos = moonshine_smoke getVariable "initialPos";
		moonshine_smoke setPosWorld _showPos;
		
		_endTime = serverTime + _cookTime;
		moonshine_smoke setVariable ["smokeEndTime", _endTime, true];
		0 spawn {
			private _endTime = serverTime + 100;
			while { serverTime < _endTime } do {
				systemChat format["server %1 end %2", serverTime, _endTime];
				_endTime = moonshine_smoke getVariable "smokeEndTime";
				sleep 0.9;
			};
			moonshine_smoke setPosWorld [0, 0, 0];
		};
	};
};

[
	prison_button,
	[[prison_input_box, "b_dive_fabric_bag", false]],
	prison_output_box,
	objNull,
	[["rhs_uniform_afghanka_boots", 1]],
	industrialConverterSoundsConfig,
	["STR_uniform_crafter_action", "STR_uniform_crafter_success", "STR_uniform_crafter_failure"],
	16,
	{["", 0]},
	{true}
]execVM "scripts\economy\createResourceConverter.sqf";