if (not isNil "DIVE_BanknoteConverterInitialized") exitWith { };
DIVE_BanknoteConverterInitialized = true;

banknoteValues = createHashMapFromArray [["pdr_1000_leu", 1000], ["pdr_500_leu", 500], ["pdr_100_leu", 100], ["pdr_50_leu", 50], ["pdr_10_leu", 10], ["pdr_5_leu", 5], ["pdr_1_leu", 1]];

sortedBanknotes = [];
// Extract key-value pairs and sort by value in descending order
{
	sortedBanknotes pushBack [_x, banknoteValues get _x];
} forEach (keys banknoteValues);

sortedBanknotes sort false; // Sort in ascending order
sortedBanknotes = sortedBanknotes apply { [_x select 1, _x select 0] };
sortedBanknotes sort false; // Sort by value
sortedBanknotes = sortedBanknotes apply { [_x select 1, _x select 0] };


fnc_getBanknotes = {
    params ["_moneyAmount"];
    
    private _result = [];
	
    {
        private _noteName = _x select 0;
        private _noteValue = _x select 1;
        
        private _count = floor (_moneyAmount / _noteValue);
        if (_count > 0) then {
            _result pushBack [_noteName, _count];
            _moneyAmount = _moneyAmount - (_count * _noteValue);
        };
    } forEach sortedBanknotes;
    
    _result
};

fnc_getMoneyAmount = {
    params ["_banknotesArray"];
    
    private _totalAmount = 0;
    
    {
        private _noteName = _x select 0;
        private _count = _x select 1;
        
        if (banknoteValues find _noteName != -1) then {
            _totalAmount = _totalAmount + (banknoteValues get _noteName) * _count;
        };
    } forEach _banknotesArray;
    
    _totalAmount
};

fnc_putMoneyIntoContainer = {
	params ["_container", "_amount"];
	_banknotes = [_amount] call fnc_getBanknotes;
	
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