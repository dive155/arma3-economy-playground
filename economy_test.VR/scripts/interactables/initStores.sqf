_storeSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success_money.ogg",
	"pdrstuff\sounds\machine_error.ogg"
];

fnc_giveSalesTaxToCity = {
	params ["_itemClass", "_moneyCurrency", "_moneyAmount", "_taxAmount"];
	
	[
		"cityMoney",
		name player,
		"SalesTax",
		_taxAmount
	] call fnc_handleAutomatedAccountTransaction;
};

private _storeItems = [
	["kss_bread", 30],
	["cigs_Kosmos_cigpack", 50],
	["MMM_BomberJacket_black", 300],
	["V_Chestrig_oli", 150],
	["B_Carryall_blk", 400],
	["hgun_P07_F", 2000],
	["16Rnd_9x21_Mag", 25],
	["FL_parts_enginepistonsmall", 600]
];

[
	store_1_button,           // The interaction button
	store_1_money_box,        // Where to put money
	store_1_item_box,         // Where to spawn inventory items
	store_1_object_area,      // Where to spawn world objects
	currencyCodePdrLeu,       // Your game's currency code
	_storeItems,              // Items with prices
	_storeSoundsConfig,       // Sounds
	{true},
	{["salesTaxPdr"] call fnc_getWorldVariable},
	{["inflationCoef_PDR"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToCity
] execVM "scripts\economy\createStore.sqf";

fnc_giveSalesTaxToMoldova = {
	params ["_itemClass", "_moneyCurrency", "_moneyAmount", "_taxAmount"];
	
	[
		"moldovaMoney",
		name player,
		"SalesTax",
		_taxAmount
	] call fnc_handleAutomatedAccountTransaction;
};

private _storeItems2 = [
	["kss_bread", 1],
	["cigs_Kosmos_cigpack", 7],
	["MMM_BomberJacket_black", 30],
	["V_Chestrig_oli", 15],
	["B_Carryall_blk", 40],
	["hgun_P07_F", 200],
	["16Rnd_9x21_Mag", 2],
	["FL_parts_enginepistonsmall", 70]
];

[
	store_2_button,           // The interaction button
	store_2_money_box,        // Where to put money
	store_2_item_box,         // Where to spawn inventory items
	store_2_object_area,      // Where to spawn world objects
	currencyCodeMoldovaLeu,       // Your game's currency code
	_storeItems2,              // Items with prices
	_storeSoundsConfig,       // Sounds
	{true},
	{["salesTaxMoldova"] call fnc_getWorldVariable},
	{["inflationCoef_Moldova"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToMoldova
] execVM "scripts\economy\createStore.sqf";