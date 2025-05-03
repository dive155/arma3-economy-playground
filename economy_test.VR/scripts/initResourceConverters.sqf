// TODO this does not belong here?
_scriptHandle = execVM "scripts\cityHelpers.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = execVM "scripts\factoryHelpers.sqf";
waitUntil { scriptDone _scriptHandle };

// Hay to Agricultural Products Converter
[
	hay_button,
	[[hay_trigger, "DIVE_Haystack"]],
	hay_output_box,
	hay_money_box,
	["b_dive_grain_bag", 1],
	industrialConverterSoundsConfig,
	["STR_hay_converter_action", "STR_hay_converter_success", "STR_hay_converter_failure"],
	{ // Get pay config
		[currencyCodePdrLeu, "payHay" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueHay", "farmOpen"] call  fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueHay"] call  fnc_handleConverterWorkCompleted;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Ore to Minerals Converter
[
	ore_button,
	[[ore_trigger, "DIVE_OreRock"]],
	ore_output_box,
	ore_money_box,
	["b_dive_ore_bag", 1],
	industrialConverterSoundsConfig,
	["STR_ore_converter_action", "STR_ore_converter_success", "STR_ore_converter_failure"],
	{ // Get pay config
		[currencyCodePdrLeu, "payOre" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueOre", "quarryOpen"] call  fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueOre"] call  fnc_handleConverterWorkCompleted;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Factory
[
	factory_button,
	[[factory_hay_box, "b_dive_grain_bag"], [factory_ore_box, "b_dive_ore_bag"]],
	factory_goods_box,
	factory_money_box,
	["b_dive_goods_bag",1],
	industrialConverterSoundsConfig,
	["STR_factory_action", "STR_factory_success", "STR_factory_failure"],
	{ // Get pay config
		[currencyCodePdrLeu, "payFactory" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueFactory", "factoryOpen"] call  fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueFactory"] call  fnc_handleConverterWorkCompleted;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Selling goods
[
	goods_button,
	[[factory_goods_box, "b_dive_goods_bag"]],
	objNull,
	objNull,
	["",0],
	industrialConverterSoundsConfig,
	["STR_goods_action", "", "STR_goods_failure"],
	{ // Get pay config
		["", 0]
	},
	{ // Extra condition
		true
	},
	{ // On work completed
		call fnc_sellProducedFactoryGoods;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Cafe stove
[
	stove,
	[[stove_input_box, "b_dive_grain_bag"]],
	stove_output_box,
	objNull,
	["pdr_lunch_full", 2],
	["pdrstuff\sounds\stove_ignition.ogg", "pdrstuff\sounds\stove_cooking.ogg", "pdrstuff\sounds\stove_failure.ogg", ""],
	["STR_stove_action", "STR_stove_success", "STR_stove_failure"],
	{["", 0]},
	{ // Extra condition
		[player, "cooking", true] call fnc_checkHasPermission;
	}
]execVM "scripts\economy\createResourceConverter.sqf";