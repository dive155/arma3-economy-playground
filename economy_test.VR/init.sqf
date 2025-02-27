_scriptHandle = execVM "scripts\economy\banknoteConversion.sqf";
waitUntil { scriptDone _scriptHandle };

_defaultSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success.ogg",
	"pdrstuff\sounds\machine_error.ogg",
	"pdrstuff\sounds\machine_success_money.ogg"
];

[
	hay_button,
	hay_trigger,
	hay_output_box,
	hay_money_box,
	"DIVE_Haystack",
	"b_dive_grain_bag",
	currencyCodePdrLeu,
	120,
	_defaultSoundsConfig,
	["STR_hay_converter_action", "STR_hay_converter_success", "STR_hay_converter_failure"]
]execVM "scripts\economy\createRawResourceConverter.sqf";

[
	ore_button,
	ore_trigger,
	ore_output_box,
	ore_money_box,
	"DIVE_OreRock",
	"b_dive_ore_bag",
	currencyCodePdrLeu,
	14,
	_defaultSoundsConfig,
	["STR_ore_converter_action", "STR_ore_converter_success", "STR_ore_converter_failure"]
]execVM "scripts\economy\createRawResourceConverter.sqf";


[
	stove,
	stove_input_box,
	stove_output_box,
	nil,
	"b_dive_grain_bag",
	"ACE_Banana",
	"",
	0,
	["pdrstuff\sounds\stove_ignition.ogg", "pdrstuff\sounds\stove_cooking.ogg", "pdrstuff\sounds\stove_failure.ogg", ""],
	["STR_stove_action", "STR_stove_success", "STR_stove_failure"]
]execVM "scripts\economy\createRawResourceConverter.sqf";