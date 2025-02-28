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
    private _banknoteValues = (currencyDefinitions get _currencyCode) select 0;
    
    {
        private _noteName = _x select 0;
        private _count = _x select 1;
        
        if (_banknoteValues getOrDefault [_noteName, -1] != -1) then {
            _totalAmount = _totalAmount + ((_banknoteValues get _noteName) * _count);
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

fnc_takeMoneyFromContainer = {
    params ["_container", "_currencyCode", "_amount"];
    
	private _currencyDefinition = currencyDefinitions get _currencyCode;
	
    // Get all money in the container for the specified currency
    private _itemCargo = getItemCargo _container;
    private _banknotesArray = [];
    {
        private _banknoteName = _x;
        private _index = (_itemCargo select 0) find _banknoteName;
        if (_index != -1) then {
            private _count = (_itemCargo select 1) select _index;
            if (_count > 0) then {
                _banknotesArray pushBack [_banknoteName, _count];
            };
        };
    } forEach (keys (_currencyDefinition select 0));
    
    private _moneyInContainer = [_currencyCode, _banknotesArray] call fnc_getMoneyAmount;
    
	systemChat str(_banknotesArray);
	systemChat str(_moneyInContainer);
    
    // Ensure there is enough money in the container
    if (_moneyInContainer < _amount) exitWith {
        hint format ["Not enough money in the container. Available: %1, Required: %2", _moneyInContainer, _amount];
    };
    
    // Remove all money of the specified currency from the container
    private _banknoteValues = _currencyDefinition select 0;
    {
        private _banknoteName = _x;
        private _itemCargo = getItemCargo _container;
        private _index = (_itemCargo select 0) find _banknoteName;
        if (_index != -1) then {
            private _count = (_itemCargo select 1) select _index;
            _container addItemCargoGlobal [_banknoteName, -_count];
        };
    } forEach (keys _banknoteValues);
    
    // Calculate and return change
    private _remainingAmount = _moneyInContainer - _amount;
    [_container, _currencyCode, _remainingAmount] call fnc_putMoneyIntoContainer;
};


// Example usage:
// _moneyArray = [250] call fnc_getBanknotes;
// Result: [["UA_100hrn", 2], ["UA_50hrn", 1]]

// _moneyAmount = [["UA_100hrn", 2], ["UA_50hrn", 1]] call fnc_getMoneyAmount;
// Result: 250