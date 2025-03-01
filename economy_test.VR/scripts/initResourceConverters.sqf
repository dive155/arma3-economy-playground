_industrialConverterSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success.ogg",
	"pdrstuff\sounds\machine_error.ogg",
	"pdrstuff\sounds\machine_success_money.ogg"
];

// Hay to Agricultural Products Converter
[
	hay_button,
	[[hay_trigger, "DIVE_Haystack"]],
	hay_output_box,
	hay_money_box,
	"b_dive_grain_bag",
	currencyCodePdrLeu,
	120,
	_industrialConverterSoundsConfig,
	["STR_hay_converter_action", "STR_hay_converter_success", "STR_hay_converter_failure"],
	fnc_checkIfCanWorkOnConverter,
	fnc_onWorkCompletedOnConverter
]execVM "scripts\economy\createResourceConverter.sqf";

// Ore to Minerals Converter
[
	ore_button,
	[[ore_trigger, "DIVE_OreRock"]],
	ore_output_box,
	ore_money_box,
	"b_dive_ore_bag",
	currencyCodeMoldovaLeu,
	14,
	_industrialConverterSoundsConfig,
	["STR_ore_converter_action", "STR_ore_converter_success", "STR_ore_converter_failure"],
	fnc_checkIfCanWorkOnConverter,
	fnc_onWorkCompletedOnConverter
]execVM "scripts\economy\createResourceConverter.sqf";

// Factory
[
	factory_button,
	[[factory_hay_box, "b_dive_grain_bag"], [factory_ore_box, "b_dive_ore_bag"]],
	objNull,
	factory_money_box,
	"",
	currencyCodePdrLeu,
	60,
	_industrialConverterSoundsConfig,
	["STR_factory_action", "STR_factory_success", "STR_factory_failure"],
	fnc_checkIfCanWorkOnConverter,
	fnc_onWorkCompletedOnConverter
]execVM "scripts\economy\createResourceConverter.sqf";

// Cafe stove
[
	stove,
	[[stove_input_box, "b_dive_grain_bag"]],
	stove_output_box,
	objNull,
	"ACE_Banana",
	currencyCodePdrLeu,
	0,
	["pdrstuff\sounds\stove_ignition.ogg", "pdrstuff\sounds\stove_cooking.ogg", "pdrstuff\sounds\stove_failure.ogg", ""],
	["STR_stove_action", "STR_stove_success", "STR_stove_failure"]
]execVM "scripts\economy\createResourceConverter.sqf";