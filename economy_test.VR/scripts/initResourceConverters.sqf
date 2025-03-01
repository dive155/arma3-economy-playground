_scriptHandle = execVM "scripts\factoryHelpers.sqf";
waitUntil { scriptDone _scriptHandle };

// Hay to Agricultural Products Converter
[
	hay_button,
	[[hay_trigger, "DIVE_Haystack"]],
	hay_output_box,
	hay_money_box,
	"b_dive_grain_bag",
	industrialConverterSoundsConfig,
	["STR_hay_converter_action", "STR_hay_converter_success", "STR_hay_converter_failure"],
	{ // Get pay config
		[currencyCodePdrLeu, "payHay" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueHay"] call  fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueHay"] call  fnc_handleFactoryWorkCompleted
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Ore to Minerals Converter
[
	ore_button,
	[[ore_trigger, "DIVE_OreRock"]],
	ore_output_box,
	ore_money_box,
	"b_dive_ore_bag",
	industrialConverterSoundsConfig,
	["STR_ore_converter_action", "STR_ore_converter_success", "STR_ore_converter_failure"],
	{ // Get pay config
		[currencyCodePdrLeu, "payOre" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueOre"] call  fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueOre"] call  fnc_handleFactoryWorkCompleted
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Factory
[
	factory_button,
	[[factory_hay_box, "b_dive_grain_bag"], [factory_ore_box, "b_dive_ore_bag"]],
	objNull,
	factory_money_box,
	"",
	industrialConverterSoundsConfig,
	["STR_factory_action", "STR_factory_success", "STR_factory_failure"],
		{ // Get pay config
		[currencyCodePdrLeu, "payFactory" call fnc_getWorldVariable]
	},
	{ // Extra condition
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueFactory"] call  fnc_checkFactoryWorkConditions
	},
	{ // On work completed
		params["_buttonObject", "_payConfig"]; 
		[_payConfig, "fatigueFactory"] call  fnc_handleFactoryWorkCompleted
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// Cafe stove
[
	stove,
	[[stove_input_box, "b_dive_grain_bag"]],
	stove_output_box,
	objNull,
	"ACE_Banana",
	["pdrstuff\sounds\stove_ignition.ogg", "pdrstuff\sounds\stove_cooking.ogg", "pdrstuff\sounds\stove_failure.ogg", ""],
	["STR_stove_action", "STR_stove_success", "STR_stove_failure"]
]execVM "scripts\economy\createResourceConverter.sqf";