_storeSoundsConfig = [
	"a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
	"pdrstuff\sounds\machine_success_money.ogg",
	"pdrstuff\sounds\machine_error.ogg"
];

private _itemPrices = [["kss_bread", 30], ["cigs_Kosmos_cigpack", 50]];
private _clothingPrices = [["MMM_BomberJacket_black", 300]];
private _vestsPrices = [["V_Chestrig_oli", 150]];
private _backpackPrices = [["B_Carryall_blk", 400]];
private _weaponPrices = [["hgun_P07_F", 2000]];
private _magazinePrices = [["16Rnd_9x21_Mag", 25]];  // Added price for the magazine
private _objectPrices = [["FL_parts_pistonenginesmall", 600]];

private _storeItemsConfig = [
	_itemPrices,
	_clothingPrices,
	_vestsPrices,
	_backpackPrices,
	_weaponPrices,
	_magazinePrices,
	_objectPrices
];

[
	store_1_button,           // The interaction button
	store_1_money_box,        // Where to put money
	store_1_item_box,         // Where to spawn inventory items
	store_1_object_area,      // Where to spawn world objects
	currencyCodePdrLeu,       // Your game's currency code
	_storeItemsConfig,        // Items with prices
	_storeSoundsConfig   // Sounds
] execVM "scripts\economy\createStore.sqf";