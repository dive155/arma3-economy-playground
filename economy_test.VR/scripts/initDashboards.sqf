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