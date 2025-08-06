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
	["FL_parts_enginepistonsmall", 600],
	["Land_CanisterFuel_F", 200],
	["Land_CanisterFuel_Red_F", 200],
	["H_Cap_grn", 30],
    ["ACE_morphine", 180],
	["pdr_jaguar", 120],
	["pdr_whoyarilo", 120],
	["WBK_HandFlashlight_Weak", 123]
];

[
	store_1_terminal,           // The interaction button
	store_1_terminal,        // Where to put money
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
	store_2_terminal,           // The interaction button
	store_2_terminal,        // Where to put money
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

if (worldName == "VR") exitWith {};

// Shops:
/*
PDR:
Cigs&Booze
Clothing Basic
Truck parts
Tools&Gear
Pharmacy Advanced


Moldova:
Cigs&Booze
Clothing advanced
Car parts
Pharmacy basic
*/

// PDR: Cigs & Booze
private _storeItemsCigsPdr = [
    ["cigs_pops_poppack", 120],
	["kss_beer_dark", 230],
	["kss_soda_coke", 50],
	["kss_soda_drpepper", 50],
    ["kss_soda_mdew", 50],
	["cigs_lighter", 80],
	["cigs_lucky_strike_cigpack", 200],
	["cigs_morley_cigpack", 200],
    ["cigs_baja_blast_cigpack", 200],
	["pdr_whoyarilo", 130]
];

[
	storeCigsPDR_terminal,
	storeCigsPDR_terminal,   
	storeCigsPDR_item_box,        
	storeCigsPDR_object_area,     
	currencyCodePdrLeu,      
	_storeItemsCigsPdr,         
	_storeSoundsConfig,       
	{true},
	{["salesTaxPdr"] call fnc_getWorldVariable},
	{["inflationCoef_PDR"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToCity
] execVM "scripts\economy\createStore.sqf";

// PDR: clothing (Basic)
private _priceMonteau = 320;
private _priceGopStyle = 350;
private _priceCitizen = 480;
private _priceWorker = 310;
private _priceRock = 620;
private _priceCap = 210;
private _priceMatraska = 570;

private _storeItemsClothingPdr = [
	["Skyline_Character_U_CivilA_01_F", _priceMonteau],
	["Skyline_Character_U_CivilA_02_F", _priceMonteau],
	["Skyline_Character_U_CivilA_03_F", _priceMonteau],
	["Skyline_Character_U_CivilA_04_F", _priceMonteau],
	["Skyline_Character_U_CivilA_05_F", _priceMonteau],
	["Skyline_Character_U_CivilA_06_F", _priceMonteau],
	["Skyline_Character_U_CivilA_07_F", _priceMonteau], // деловые жакеты	
	
	["Skyline_Character_U_CivilE_01_F", _priceGopStyle],
	["Skyline_Character_U_CivilE_02_F", _priceGopStyle],
	["Skyline_Character_U_CivilE_03_F", _priceGopStyle],
	["Skyline_Character_U_CivilE_04_F", _priceGopStyle], // спорт кофточки	
	
	["rds_uniform_citizen1", _priceCitizen],
	["rds_uniform_citizen2", _priceCitizen],
	["rds_uniform_citizen3", _priceCitizen],
	["rds_uniform_citizen4", _priceCitizen], //кожанки со свитерами из рдса
	
	["rds_uniform_Worker1", _priceWorker],
	["rds_uniform_Worker2", _priceWorker],
	["rds_uniform_Worker3", _priceWorker], // рабочая одежда селянина из рдса
	["rds_uniform_Worker3", _priceWorker],

	["rds_uniform_Worker4", _priceRock],
	["rds_uniform_Rocker1", _priceRock],
	["rds_uniform_Rocker2", _priceRock],
	["rds_uniform_Rocker3", _priceRock],
	["rds_uniform_Rocker4", _priceRock], // джинсовки с рокерскими майками из рдса
	
	["H_Cap_grn", _priceCap],
	["H_Cap_blue", _priceCap],
	["H_Cap_oli", _priceCap],
	["H_Cap_tan", _priceCap],
	["H_Cap_red", _priceCap], // кепки ванила
	
	["Skyline_Character_U_CivilB_01_F", _priceMatraska],
	["Skyline_Character_U_CivilB_02_F", _priceMatraska],
	["Skyline_Character_U_CivilB_03_F", _priceMatraska],
	["Skyline_Character_U_CivilB_04_F", _priceMatraska],
	["Skyline_Character_U_CivilB_05_F", _priceMatraska],
	["Skyline_Character_U_CivilB_06_F", _priceMatraska],
	
	["G_Spectacles", 250], // очки пластиковые
	["G_G_Squares_Tinted", 350] // очки солнцезащитные железные
];

[
	storeClothesPDR_terminal,
	storeClothesPDR_terminal,   
	storeClothesPDR_item_box,        
	storeClothesPDR_object_area,     
	currencyCodePdrLeu,      
	_storeItemsClothingPdr,         
	_storeSoundsConfig,       
	{true},
	{["salesTaxPdr"] call fnc_getWorldVariable},
	{["inflationCoef_PDR"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToCity
] execVM "scripts\economy\createStore.sqf";

// PDR: Truck Parts
private _storeItemsTrucks = [
    ["advrepair_SpareParts", 130],
    ["FL_parts_enginepistonlarge", 1200],
    ["FL_parts_enginepistonmedium", 850],
    ["FL_parts_fueltanklarge", 650],
	["ACE_Wheel", 220],
	["triangleinvch", 70],
	["Land_CanisterFuel_Blue_F", 150]
];

[
	storeTruckParts_terminal,
	storeTruckParts_terminal,   
	storeTruckParts_item_box,        
	storeTruckParts_object_area,     
	currencyCodePdrLeu,      
	_storeItemsTrucks,         
	_storeSoundsConfig,       
	{true},
	{["salesTaxPdr"] call fnc_getWorldVariable},
	{["inflationCoef_PDR"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToCity
] execVM "scripts\economy\createStore.sqf";

// PDR: Tools & Gear
private _storeItemsGear = [
	["Skyline_Backpack_Montagne_01_F", 1100],
	["Skyline_Backpack_Montagne_02_F", 1100],
	["Skyline_Backpack_Montagne_03_F", 1100],
	["Skyline_Backpack_Montagne_04_F", 1100], // походный большой рюкзак 29 магазов от АК вместимости
	["Skyline_Backpack_Sac_a_dos_01_F", 820],
	["Skyline_Backpack_Sac_a_dos_02_F", 820],
	["Skyline_Backpack_Sac_a_dos_03_F", 820],
	["Skyline_Backpack_Sac_a_dos_04_F", 820], // походный рюкзак обычный 23 магаза от АК 
    ["advrepair_ToolkitLight", 400],
    ["ACE_CableTie", 300],
    ["ACE_EarPlugs", 100],
    ["MMM_DuffleBag_Black", 900],
    ["MMM_DuffleBag_Blue", 900],
    ["MMM_DuffleBag_Red", 900],
    ["MMM_DuffleBag_Vrana", 900],
    ["rhsgref_chicom", 720],
    ["rhs_chicom_khk", 720],
	["fanny_pack1", 450],
	["fanny_pack", 450],
	["fanny_pack2", 450],
	["fanny_pack8", 450],
	["fanny_pack11", 450],
	["fanny_pack9", 450],
	["fanny_pack10", 450],
    ["G_Bandanna_blk", 320],
    ["G_Bandanna_khk", 320],
    ["G_Bandanna_oli", 320],
    ["usm_kneepads_blk", 150],
    ["usm_swdgoggles", 300],
    ["usm_gigloves", 200],
    ["usm_headwrap_blk", 190],
    ["usm_headwrap_odg1", 190],
    ["usm_headwrap_tan", 190],
    ["WBK_HandFlashlight_Weak", 310],
    ["Crowbar", 700],
	["WBK_SmallHammer", 600],
	["pdr_grinder", 1050],
	["Binocular", 350],
	["G_Shades_Black", 100],
	["G_Shades_Blue", 100],
	["G_Shades_Green", 100],
	["G_Shades_Red", 100],
	["G_Sport_Red", 150],
	["G_Sport_Blackyellow", 150],
	["G_Sport_BlackWhite", 150],
	["G_Sport_Checkered", 150],
	["G_Sport_Blackred", 150],
	["G_Sport_Greenblack", 150]
];

[
	storeTools_terminal,
	storeTools_terminal,   
	storeTools_item_box,        
	storeTools_object_area,     
	currencyCodePdrLeu,      
	_storeItemsGear,         
	_storeSoundsConfig,       
	{true},
	{["salesTaxPdr"] call fnc_getWorldVariable},
	{["inflationCoef_PDR"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToCity
] execVM "scripts\economy\createStore.sqf";

// PDR: Pharmacy
private _storeItemsMedical = [
    ["ACE_elasticBandage", 300],
    ["ACE_epinephrine", 150],
    ["ACE_adenosine", 150],
    ["ACE_morphine", 180],
    ["ACE_painkillers", 110],
    ["ACE_splint", 220],
    ["ACE_tourniquet", 120],
    ["ACE_salineIV", 520],
    ["ACE_salineIV_500", 310],
	["rds_uniform_doctor", 1100]
];

[
	storePharmPDR_terminal,
	storePharmPDR_terminal,   
	storePharmPDR_item_box,        
	storePharmPDR_object_area,     
	currencyCodePdrLeu,      
	_storeItemsMedical,         
	_storeSoundsConfig,       
	{true},
	{["salesTaxPdr"] call fnc_getWorldVariable},
	{["inflationCoef_PDR"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToCity
] execVM "scripts\economy\createStore.sqf";

// Moldova: Cigs&Booze
private _storeItemsCigsMoldova = [
    ["cigs_Kosmos_cigpack", 7],
    ["kss_beer_light", 9],
    ["cigs_matches", 2],
	["kss_vodka", 15],
	["pdr_bugulma", 19],
	["ACE_Sunflower_Seeds", 1],
	["pdr_jaguar", 9]
];

[
	storeCigsMoldova_terminal,
	storeCigsMoldova_terminal,
	storeCigsMoldova_item_box,
	storeCigsMoldova_object_area,
	currencyCodeMoldovaLeu,
	_storeItemsCigsMoldova,
	_storeSoundsConfig,       // Sounds
	{true},
	{["salesTaxMoldova"] call fnc_getWorldVariable},
	{["inflationCoef_Moldova"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToMoldova
] execVM "scripts\economy\createStore.sqf";


// Moldova: Fancy clothes
private _priceJackets = 110;
private _priceBombers = 110;
private _priceSuits = 230;
private _priceCowboyHats = 50;
private _priceGlasses = 30;

private _storeItemsClothing = [
    // Куртки с джинсами разных цветов
    ["Skyline_Character_U_CivilC_02_F", _priceJackets],
    ["Skyline_Character_U_CivilC_01_F", _priceJackets],
    ["Skyline_Character_U_CivilC_03_F", _priceJackets],
    ["Skyline_Character_U_CivilC_04_F", _priceJackets],
    ["Skyline_Character_U_CivilC_05_F", _priceJackets],
    ["Skyline_Character_U_CivilC_06_F", _priceJackets],
    ["Skyline_Character_U_CivilC_07_F", _priceJackets],

    // Бомберы разные с джинсами
    ["MMM_BomberJacket_black", _priceBombers],
    ["MMM_BomberJacket_open_black", _priceBombers],
    ["MMM_BomberJacket_brown", _priceBombers],
    ["MMM_BomberJacket_open_brown", _priceBombers],
    ["MMM_BomberJacket_DarkChocolate", _priceBombers],
    ["MMM_BomberJacket_open_DarkChocolate", _priceBombers],

    // Деловые костюмы
    ["rds_uniform_Functionary1", _priceSuits],
    ["rds_uniform_Functionary2", _priceSuits],
    ["U_C_FormalSuit_01_tshirt_black_F", _priceSuits],
    ["U_C_FormalSuit_01_tshirt_gray_F", _priceSuits],
    ["U_C_FormalSuit_01_black_F", _priceSuits],
    ["U_C_FormalSuit_01_gray_F", _priceSuits],
    ["U_C_FormalSuit_01_blue_F", _priceSuits],
    ["U_C_FormalSuit_01_khaki_F", _priceSuits],

    // Ковбойские шляпы
    ["Skyline_HeadGear_Cowboy_01_F", _priceCowboyHats],
    ["Skyline_HeadGear_Cowboy_02_F", _priceCowboyHats],
    ["Skyline_HeadGear_Cowboy_03_F", _priceCowboyHats],
    ["Skyline_HeadGear_Cowboy_04_F", _priceCowboyHats],
    ["Skyline_HeadGear_Cowboy_05_F", _priceCowboyHats],
    ["Skyline_HeadGear_Cowboy_06_F", _priceCowboyHats],

    // Очки
    ["G_Aviator", _priceGlasses],
    ["G_Spectacles", _priceGlasses],
    ["G_Squares_Tinted", _priceGlasses],
    ["G_Squares", _priceGlasses]
];

[
	storeClothesMoldova_terminal,
	storeClothesMoldova_terminal,
	storeClothesMoldova_item_box,
	storeClothesMoldova_object_area,
	currencyCodeMoldovaLeu,
	_storeItemsClothing,
	_storeSoundsConfig,       // Sounds
	{true},
	{["salesTaxMoldova"] call fnc_getWorldVariable},
	{["inflationCoef_Moldova"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToMoldova
] execVM "scripts\economy\createStore.sqf";


// Moldova: Car parts
private _storeItemsCars = [
    ["advrepair_SpareParts", 10],
	["ACE_Wheel", 13],
	["triangleinvch", 4],
	["Land_CanisterFuel_Red_F", 9],
	["FL_parts_fueltanksmall", 27],
	["FL_parts_enginepistonsmall", 42]
];

[
	storeCarParts_terminal,
	storeCarParts_terminal,
	storeCarParts_item_box,
	storeCarParts_object_area,
	currencyCodeMoldovaLeu,
	_storeItemsCars,
	_storeSoundsConfig,       // Sounds
	{true},
	{["salesTaxMoldova"] call fnc_getWorldVariable},
	{["inflationCoef_Moldova"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToMoldova
] execVM "scripts\economy\createStore.sqf";

// Moldova: Basic Pharmacy
private _storeItemsMedical = [
    ["ACE_fieldDressing", 3],
    ["ACE_painkillers", 6],
    ["ACE_splint", 15]
];

[
	storePharmMoldova_terminal,
	storePharmMoldova_terminal,
	storePharmMoldova_item_box,
	storePharmMoldova_object_area,
	currencyCodeMoldovaLeu,
	_storeItemsMedical,
	_storeSoundsConfig,       // Sounds
	{true},
	{["salesTaxMoldova"] call fnc_getWorldVariable},
	{["inflationCoef_Moldova"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToMoldova
] execVM "scripts\economy\createStore.sqf";

// Moldova: Club
private _storeItemsClub = [
    ["cigs_Kosmos_cigpack", 15],
    ["kss_beer_light", 20],
    ["cigs_matches", 5],
	["kss_vodka", 30],
	["pdr_bugulma", 40],
	["ACE_Sunflower_Seeds", 4],
	["pdr_jaguar", 25]
];

[
	store_club_terminal,
	store_club_terminal,
	store_club_item_box,
	storePharmMoldova_object_area,
	currencyCodeMoldovaLeu,
	_storeItemsClub,
	_storeSoundsConfig,       // Sounds
	{true},
	{["salesTaxMoldova"] call fnc_getWorldVariable},
	{["inflationCoef_Moldova"] call fnc_getWorldVariable},
	fnc_giveSalesTaxToMoldova
] execVM "scripts\economy\createStore.sqf";