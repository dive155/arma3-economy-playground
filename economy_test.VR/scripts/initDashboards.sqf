fnc_getIndustryDashboard = {
    private _factoryMoney     = ["factoryMoney"] call fnc_getWorldVariable;
    private _farmOpen         = ["farmOpen"] call fnc_getWorldVariable;
    private _quarryOpen       = ["quarryOpen"] call fnc_getWorldVariable;
    private _factoryOpen      = ["factoryOpen"] call fnc_getWorldVariable;
    private _payHay           = ["payHay"] call fnc_getWorldVariable;
    private _payOre           = ["payOre"] call fnc_getWorldVariable;
    private _payFactory       = ["payFactory"] call fnc_getWorldVariable;
    private _goodsSellPrice   = ["factoryGoodsSellPrice"] call fnc_getWorldVariable;
    private _taxRate          = ["factoryGoodsTax"] call fnc_getWorldVariable;
    private _bossCut          = ["factoryBossCommission"] call fnc_getWorldVariable;

    private _hayStock     = [hay_output_box, "b_dive_grain_bag"] call fnc_checkHowManyBackpacksInBox;
    private _oreStock     = [ore_output_box, "b_dive_ore_bag"] call fnc_checkHowManyBackpacksInBox;
    private _goodsStock   = [factory_goods_box, "b_dive_goods_bag"] call fnc_checkHowManyBackpacksInBox;

    private _isOpenColor = {
		params ["_value"];
        if (_value) then {"#00ff00"} else {"#ff0000"};
    };

	private _openText = {
		params ["_value"];
		if (_value) then {localize "STR_industry_status_open"} else {localize "STR_industry_status_closed"};
	};

    private _colorValue = {
		params ["_value"];
        if (_value >= 0) then {
            format ["<t color='#00ff00'>+%1</t>", _value]
        } else {
            format ["<t color='#ff0000'>%1</t>", _value]
        }
    };

    private _prodCostTotal = -_payHay - _payOre - _payFactory;
    private _postTaxRevenue = _goodsSellPrice * (1 - _taxRate);
    private _directorCommission = _postTaxRevenue * _bossCut;
    private _cityTax = _goodsSellPrice * _taxRate;
    private _factoryBalance = _goodsSellPrice - _cityTax - _directorCommission - abs _prodCostTotal;

    private _dashboard = format [
        localize "STR_industry_dashboard",
        _factoryMoney,
        _farmOpen call _isOpenColor,
        _farmOpen call _openText,
        _payHay,
        _hayStock,
        _quarryOpen call _isOpenColor,
        _quarryOpen call _openText,
        _payOre,
        _oreStock,
        _factoryOpen call _isOpenColor,
        _factoryOpen call _openText,
        _payFactory,
        _goodsStock,
        _goodsSellPrice,
        [-_payHay] call _colorValue,
        [-_payOre] call _colorValue,
        [-_payFactory] call _colorValue,
        [_prodCostTotal] call _colorValue,
        round(_taxRate * 100),
        [-_cityTax] call _colorValue,
        [-_directorCommission] call _colorValue,
        [_factoryBalance] call _colorValue
    ];

    _dashboard
};

fnc_getCityDashboard = {
	// _civiliansDatabase is an array of arrays, each element is:
	// [_passport, _name, _surname, _job, _salary, _bills, _debt, _isOnline]
	private _civiliansDatabase = ["fnc_getCiviliansInfoServer", ["PDR"]] call DMP_fnc_requestServerResult;

	// Retrieve world variable values
	private _cityMoney	  = ["cityMoney"] call fnc_getWorldVariable;
	private _factoryTax	 = ["factoryGoodsTax"] call fnc_getWorldVariable;	  // 0..1
	private _goodsSellPrice = ["factoryGoodsSellPrice"] call fnc_getWorldVariable;
	private _interestRate   = ["interestRate_PDR"] call fnc_getWorldVariable;	   // 0..1
	private _fuelPrice	  = ["fuelPrice_PDR"] call fnc_getWorldVariable;
	private _fuelInStorage  = ["fuelInStorage"] call fnc_getWorldVariable;
	private _gasStationOpen = ["gasStationOpen"] call fnc_getWorldVariable;

	// Derived values
	private _dailyInterestPercent = round(_interestRate * 100);
	private _factoryTaxPercent	= round(_factoryTax * 100);
	private _taxPerItem		   = round(_goodsSellPrice * _factoryTax);

	// Helper functions for coloring
	private _colorNumber = {
		params ["_num"];
		// Numbers in general are colored green.
		format ["<t color='#00ff00'>%1</t>", _num]
	};

	private _colorDebt = {
		params ["_num"];
		// Debt values are colored red.
		format ["<t color='#ff0000'>%1</t>", _num]
	};

	private _colorBills = {
		params ["_num"];
		// Daily bills are colored yellow.
		format ["<t color='#ffff00'>%1</t>", _num]
	};

	private _colorGovSal = {
		params ["_num"];
		// Government salary is colored light green.
		format ["<t color='#90EE90'>%1</t>", _num]
	};

	private _colorGovJob = {
		params ["_job"];
		// Government job text is colored dark blue.
		if (_job isEqualTo "") then {_job = "--"};
		format ["<t color='#73a6ff'>%1</t>", _job]
	};

	private _colorName = {
		params ["_name"];
		// Citizen names are colored blue.
		format ["<t color='#b8fffd'>%1</t>", _name]
	};

	private _onlineText = {
		params ["_value"];
		if (_value) then {
			format ["<t color='#00ff00'>%1</t>", localize "STR_citizen_online"]
		} else {
			format ["<t color='#ffa500'>%1</t>", localize "STR_citizen_offline"]
		}
	};

	private _gasStationStatus = {
		if (_this) then {
			format ["<t color='#00ff00'>%1</t>", localize "STR_city_status_open"]
		} else {
			format ["<t color='#ff0000'>%1</t>", localize "STR_city_status_closed"]
		}
	};

	// Process the citizens database:
	// Sort citizens alphabetically by their first name (index 1).
	// Correct — using BIS_fnc_sortBy
	private _sortedCivilians = [_civiliansDatabase, [], { _x select 1 }, "ASCEND"] call BIS_fnc_sortBy;

	// Build a multi-line string of citizen data
	private _citizensText = "";
	{
		private _index = _forEachIndex;  // using forEach index
		private _entry   = _x;
		private _name	= _entry select 1;
		private _surname = _entry select 2;
		private _job	 = _entry select 3;
		private _salary  = _entry select 4;
		private _bills   = _entry select 5;
		private _debt	= _entry select 6;
		private _isOnline= _entry select 7;
		
		private _citizenLine = format [
			"%1. %2 %3: <br/>%4 %5. %6 %7. %8 %9. %10 %11. %12.",
			_index + 1,
			_name call _colorName,
			_surname call _colorName,
			localize "STR_citizen_debt",		 // "Debt:"
			_debt call _colorDebt,
			localize "STR_citizen_dailyBills",	// "Daily Bills:"
			_bills call _colorBills,
			localize "STR_citizen_job",		   // "Government Job:"
			_job call _colorGovJob,
			localize "STR_citizen_salary",		// "Government Salary:"
			_salary call _colorGovSal,
			_isOnline call _onlineText		   // Online/Offline status
		];

		_citizensText = _citizensText + _citizenLine + "<br/>";
	} forEach _sortedCivilians;

	// Compose the final dashboard using a localization string:
	private _dashboard = format [
		localize "STR_city_dashboard",
		_cityMoney call _colorNumber,
		_dailyInterestPercent call _colorNumber,
		_factoryTaxPercent call _colorNumber,
		_taxPerItem call _colorNumber,
		_gasStationOpen call _gasStationStatus,
		_fuelPrice call _colorNumber,
		_fuelInStorage call _colorNumber,
		_citizensText
	];

	_dashboard
};



// Director of Industry Dashboard
// <br/>Factory Funds:       5000
// <br/>
// <br/>Farm Status:
// <br/>Open
// <br/>Pay:                  220
// <br/>Hay in stockpile:     5
// <br/>
// <br/>Quarry Status:
// <br/>Open
// <br/>Pay:                  240
// <br/>Ore in stockpile:     3
// <br/>
// <br/>Factory Status:
// <br/>Open
// <br/>Pay:                  220
// <br/>Goods in stockpile:   5
// <br/>
// <br/>
// <br/>Financial Breakdown:
// <br/>--------------------------
// <br/>(Not Adjustable)
// <br/>Goods are sold for:  2000 
// <br/>
// <br/>(Adjustable)
// <br/>Production Cost:
// <br/>--Farm:     -220
// <br/>--Quarry    -240
// <br/>--Factory   -150
// <br/>Total:               -610
// <br/>
// <br/>(Not Adjustable)
// <br/>City Tax (35%)       -700
// <br/>
// <br/>(Adjustable)
// <br/>Director Commission  -300
// <br/>--------------------------
// <br/>Factory Balance      +390

// Mayor Dashboard// <br/>// <br/>City Money:                  5000// <br/>// <br/>(Adjustable)// <br/>Daily Interest on Debt:        20%// <br/>Factory Goods Tax:             35% (700 per Item Sold)// <br/>// <br/>(Adjustable)// <br/>Gas Station:// <br/>Open// <br/>Fuel Sell Price                50// <br/>Fuel in storage (liters)      345// <br/>// <br/>Citizens:// <br/>1. John Doe:// <br/>Debt: 235. Daily Bills: 300. Government Job: Policeman. Government Salary: 700. Online.// <br/>2. Jane Doe// <br/>Debt: 123. Daily Bills: 100. Government Job: -. Government Salary: 0. Offline.