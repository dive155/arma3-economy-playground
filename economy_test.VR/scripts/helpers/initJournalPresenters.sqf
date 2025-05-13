fnc_composeAccountRecord = {
	params ["_operationRecord"];
	_operationRecord params ["_playerName", "_operationType", "_amount", "_newBalance", "_playersNote"];
	
	private _date = date;
	_date params ["_year", "_month", "_day", "_hours", "_minutes"];

	// Construct formatted string
	//private _dateString = format ["%1.%2.%3 %4:%5", _day, _month, _year, _hours, _minutes];
	
	private _day = ["rpDay"] call fnc_getWorldVariable;
	private _dateString = format ["RP Day %1; %2:%3", _day, _hours, _minutes];
	
	private _result = format ["%1,%2,%3,%4,%5,%6", _dateString, _playerName, _operationType, _amount, _newBalance, _playersNote];
	_result
};

fnc_formatAccountRecord = {
	params ["_rawArray", ["_indexOffset", 0], ["_isDebt", false]];
    private _result = "";
	
    {
        private _index = _indexOffset + _forEachIndex + 1;
        private _entryParts = _x splitString ",";

        // First 4 elements are fixed, rest is the note (rejoin with commas if needed)
        private _dateTime = if (count _entryParts > 0) then {_entryParts select 0} else {""};
		_dateTime = "<t color='#caf5c4'>" + _dateTime + "</t>";
        private _playerName = if (count _entryParts > 1) then {"<t color='#00d2ff'>" + (_entryParts select 1) + "</t>"} else {"Unknown"};
			
		private _operationType = (_entryParts select 2);
		_operationType = localize ("STR_transaction_type_" + _operationType);
		
        private _amount = if (count _entryParts > 3) then {parseNumber (_entryParts select 3)} else {0};
		private _color = "";

		if (_isDebt) then {
			// Debt logic: positive -> yellow, negative -> green
			_color = if (_amount >= 0) then {"#ff6229"} else {"#19ff19"};
		} else {
			// Normal logic: positive -> green, negative -> yellow
			_color = if (_amount >= 0) then {"#19ff19"} else {"#ff6229"};
		};

		private _operationAmount = format ["<t color='%1'>%2</t>", _color, _amount];
		
		private _remainder = if (count _entryParts > 4) then {"<t color='#b8a548'>" + (_entryParts select 4) + "</t>"} else {"0"};
        private _note = if (count _entryParts > 5) then {
            (_entryParts select [5, count _entryParts - 5]) joinString ","
        } else {
            ""
        };
		_note = "<t color='#b5b5b5'>" + _note + "</t>";
		
		private _locKey = if (_isDebt) then {"STR_transaction_log_entry_debt"} else {"STR_transaction_log_entry"};
        private _line = format [
            (localize _locKey) + "<br/>-----------------------------------------------------",
            _index,
            _dateTime,
            _operationType,
            _playerName,
            _operationAmount,
			_remainder,
            _note
        ];

        _result = _result + _line + "<br/>";
    } forEach _rawArray;

    _result = _result;
    _result
};

fnc_requestAndShowJournal = {
	params["_journalName", ["_header", ""], ["_isDebt", false]];
	
	_journalData = ["DMP_fnc_getJournalEntries", [_journalName]] call DMP_fnc_requestServerResult;
	
	_journalText = _header + ([_journalData, _isDebt] call fnc_formatAccountRecord);
	[_journalText] call fnc_showLongTextDialog;
};