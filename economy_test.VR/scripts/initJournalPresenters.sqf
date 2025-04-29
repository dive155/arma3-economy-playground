fnc_composeAccountRecord = {
	params ["_operationRecord"];
	_operationRecord params ["_playerName", "_operationType", "_amount", "_newBalance", "_playersNote"];
	
	private _date = date;
	_date params ["_year", "_month", "_day", "_hours", "_minutes"];

	// Construct formatted string
	private _dateString = format ["%1.%2.%3 %4:%5", _day, _month, _year, _hours, _minutes];
	
	private _result = format ["%1,%2,%3,%4,%5,%6", _dateString, _playerName, _operationType, _amount, _newBalance, _playersNote];
	_result
};

fnc_formatAccountRecord = {
	params ["_rawArray"];
    private _result = "";
	
    {
        private _index = _forEachIndex + 1;
        private _entryParts = _x splitString ",";

        // First 4 elements are fixed, rest is the note (rejoin with commas if needed)
        private _dateTime = if (count _entryParts > 0) then {_entryParts select 0} else {""};
		_dateTime = "<t color='#caf5c4'>" + _dateTime + "</t>";
        private _playerName = if (count _entryParts > 1) then {"<t color='#00d2ff'>" + (_entryParts select 1) + "</t>"} else {"Unknown"};
			
		private _operationType = (_entryParts select 2);
		_operationType = localize ("STR_transaction_type_" + _operationType);
        private _operationAmount = if (count _entryParts > 3) then {"<t color='#ffc61c'>" + (_entryParts select 3) + "</t>"} else {"0"};
		private _remainder = if (count _entryParts > 4) then {"<t color='#b8a548'>" + (_entryParts select 4) + "</t>"} else {"0"};
        private _note = if (count _entryParts > 5) then {
            (_entryParts select [5, count _entryParts - 5]) joinString ","
        } else {
            ""
        };
		_note = "<t color='#b5b5b5'>" + _note + "</t>";

        private _line = format [
            localize "STR_transaction_log_entry",
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
	params["_journalName", ["_header", ""]];
	
	_journalData = ["DMP_fnc_getJournalEntries", [_journalName]] call DMP_fnc_requestServerResult;
	
	_journalText = _header + ([_journalData] call fnc_formatAccountRecord);
	[_journalText] call fnc_showLongTextDialog;
};