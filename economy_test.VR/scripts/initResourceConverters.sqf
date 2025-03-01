_industrialConverterSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success.ogg",
	"pdrstuff\sounds\machine_error.ogg",
	"pdrstuff\sounds\machine_success_money.ogg"
];

fnc_checkIfFactoryCanPay = {
	params ["_payConfig"];
	_toPay = _payConfig select 1;
	_factoryMoney = "factoryMoney" call fnc_getWorldVariable;
	_leftover = _factoryMoney - _toPay;
	
	if (_leftover > 0) then { true } else {
		hint(localize "STR_factory_no_money");
		false
	};
};

fnc_takeMoneyFromFactory = {
	params["_moneyToTake"];
	
	_factoryMoney = "factoryMoney" call fnc_getWorldVariable;
	_factoryMoney = _factoryMoney - _moneyToTake;
	["factoryMoney", _factoryMoney] call fnc_setWorldVariable;
};

// Hay to Agricultural Products Converter
[
	hay_button,
	[[hay_trigger, "DIVE_Haystack"]],
	hay_output_box,
	hay_money_box,
	"b_dive_grain_bag",
	_industrialConverterSoundsConfig,
	["STR_hay_converter_action", "STR_hay_converter_success", "STR_hay_converter_failure"],
	{[currencyCodePdrLeu, 120]},
	
	{   // Extra condition
		params["_buttonObject", "_payConfig"];
		_fatigueIncrease = "fatigueHay" call fnc_getWorldVariable;
		([_payConfig] call fnc_checkIfFactoryCanPay)
			and ([_fatigueIncrease] call fnc_checkIfNotTooFatigued)
	},
	
	{	// On work completed
		params["_buttonObject", "_payConfig"];
		_fatigueIncrease = "fatigueHay" call fnc_getWorldVariable;
		_moneyToTake = _payConfig select 1;
		_moneyToTake call fnc_takeMoneyFromFactory;
		
		_fatigueIncrease call fnc_increasePlayerFatigue;
	}
]execVM "scripts\economy\createResourceConverter.sqf";

// // Ore to Minerals Converter
// [
	// ore_button,
	// [[ore_trigger, "DIVE_OreRock"]],
	// ore_output_box,
	// ore_money_box,
	// "b_dive_ore_bag",
	// _industrialConverterSoundsConfig,
	// ["STR_ore_converter_action", "STR_ore_converter_success", "STR_ore_converter_failure"],
	// {[currencyCodeMoldovaLeu, 14]},
	// fnc_checkIfCanWorkOnConverter,
	// fnc_onWorkCompletedOnConverter
// ]execVM "scripts\economy\createResourceConverter.sqf";

// // Factory
// [
	// factory_button,
	// [[factory_hay_box, "b_dive_grain_bag"], [factory_ore_box, "b_dive_ore_bag"]],
	// objNull,
	// factory_money_box,
	// "",
	// _industrialConverterSoundsConfig,
	// ["STR_factory_action", "STR_factory_success", "STR_factory_failure"],
	// {[currencyCodePdrLeu, 60]},
	// fnc_checkIfCanWorkOnConverter,
	// fnc_onWorkCompletedOnConverter
// ]execVM "scripts\economy\createResourceConverter.sqf";

// Cafe stove
// [
	// stove,
	// [[stove_input_box, "b_dive_grain_bag"]],
	// stove_output_box,
	// objNull,
	// "ACE_Banana",
	// ["pdrstuff\sounds\stove_ignition.ogg", "pdrstuff\sounds\stove_cooking.ogg", "pdrstuff\sounds\stove_failure.ogg", ""],
	// ["STR_stove_action", "STR_stove_success", "STR_stove_failure"]
// ]execVM "scripts\economy\createResourceConverter.sqf";