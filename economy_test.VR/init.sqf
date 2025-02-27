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
	120,
	_defaultSoundsConfig
]execVM "scripts\economy\createRawResourceConverter.sqf";

[
	ore_button,
	ore_trigger,
	ore_output_box,
	ore_money_box,
	"DIVE_OreRock",
	"b_dive_ore_bag",
	140,
	_defaultSoundsConfig
]execVM "scripts\economy\createRawResourceConverter.sqf";


[
	stove,
	stove_input_box,
	stove_output_box,
	nil,
	"b_dive_grain_bag",
	"ACE_Banana",
	0,
	["", "pdrstuff\sounds\stove_cooking.ogg", "", ""]
]execVM "scripts\economy\createRawResourceConverter.sqf";



sleep 2;
//hint typeof hay_trigger;

//hint typeName "abobus";
//"B_Messenger_Black_F" isKindOf 

//hint str(isClass (configFile >> "CfgWeapons" >> "B_Messenger_Black_F"));
//hint str(isClass (configFile >> "CfgVehicles" >> "B_Messenger_Black_F"));