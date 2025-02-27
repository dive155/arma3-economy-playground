if (not isNil "DIVE_BanknoteConverterInitialized") exitWith { };
DIVE_BanknoteConverterInitialized = true;

currencyDefinitions = createHashMap;
fnc_createCurrencyDefinition = {
	params ["_currencyCode", "_moneyArray"];
	
	_banknoteValues = createHashMapFromArray _moneyArray;

	_sortedBanknotes = [];
	// Extract key-value pairs and sort by value in descending order
	{
		_sortedBanknotes pushBack [_x, _banknoteValues get _x];
	} forEach (keys _banknoteValues);

	_sortedBanknotes sort false; // Sort in ascending order
	_sortedBanknotes = _sortedBanknotes apply { [_x select 1, _x select 0] };
	_sortedBanknotes sort false; // Sort by value
	_sortedBanknotes = _sortedBanknotes apply { [_x select 1, _x select 0] };
	
	_definition = [_banknoteValues, _sortedBanknotes];
	currencyDefinitions set [_currencyCode, _definition];
};

fnc_getBanknotes = {
    params ["_currencyCode", "_moneyAmount"];
    
    private _result = [];
	private _sortedBanknotes = (currencyDefinitions get _currencyCode) select 1;
	
    {
        private _noteName = _x select 0;
        private _noteValue = _x select 1;
        
        private _count = floor (_moneyAmount / _noteValue);
        if (_count > 0) then {
            _result pushBack [_noteName, _count];
            _moneyAmount = _moneyAmount - (_count * _noteValue);
        };
    } forEach _sortedBanknotes;
    
    _result
};

fnc_getMoneyAmount = {
    params ["_currencyCode", "_banknotesArray"];
    
    private _totalAmount = 0;
    private _banknoteValues = (currencyDefinitions get _currencyCode) select 1;
	
    {
        private _noteName = _x select 0;
        private _count = _x select 1;
        
        if (_banknoteValues find _noteName != -1) then {
            _totalAmount = _totalAmount + (_banknoteValues get _noteName) * _count;
        };
    } forEach _banknotesArray;
    
    _totalAmount
};

fnc_putMoneyIntoContainer = {
	params ["_container","_currencyCode", "_amount"];
	_banknotes = [_currencyCode, _amount] call fnc_getBanknotes;
	
	{
		_className = _x select 0;
		_amount = _x select 1;
		_container addItemCargoGlobal [_className, _amount];
	} forEach _banknotes;
};


// Example usage:
// _moneyArray = [250] call fnc_getBanknotes;
// Result: [["UA_100hrn", 2], ["UA_50hrn", 1]]

// _moneyAmount = [["UA_100hrn", 2], ["UA_50hrn", 1]] call fnc_getMoneyAmount;
// Result: 250