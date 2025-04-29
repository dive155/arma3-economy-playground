DMP_fnc_getJournalEntries = {
	params ["_journalName"];
	
	_dbHandle = ["new", DMP_dbNameJournals] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	
	if not (_journalName in _sections) exitWith {[]};
	
	_keys = ["getKeys", _journalName] call _dbHandle;
	
	_entries = _keys apply {
		["read", [_journalName, _x, ""]] call _dbHandle
	};
	
	_entries
};

DMP_fnc_getJournalEntriesPaged = {
	params ["_journalName", "_itemsPerPage", ["_pageIndex", -1]];

	_dbHandle = ["new", DMP_dbNameJournals] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;

	if !(_journalName in _sections) exitWith { [-1, 0, []] };

	private _keys = ["getKeys", _journalName] call _dbHandle;
	private _totalEntries = count _keys;

	private _entries = [];
	private _totalPages = 1;
	private _returnPageIndex = 0;

	if (_itemsPerPage <= 0) then {
		// No paging — return all entries
		_entries = _keys apply {
			["read", [_journalName, _x, ""]] call _dbHandle
		};
	} else {
		_totalPages = ceil (_totalEntries / _itemsPerPage);
		_returnPageIndex = if (_pageIndex == -1) then { _totalPages - 1 } else { _pageIndex };
		_returnPageIndex = _returnPageIndex max 0 min (_totalPages - 1);

		private _startIndex = _returnPageIndex * _itemsPerPage;
		private _endIndex = (_startIndex + _itemsPerPage) min _totalEntries;

		private _pageKeys = _keys select [_startIndex, _endIndex - _startIndex];
		_entries = _pageKeys apply {
			["read", [_journalName, _x, ""]] call _dbHandle
		};
	};

	[_returnPageIndex, _totalPages, _entries]
};


DMP_dbJournalEntryPrefix = "entry_";
DMP_fnc_addToJournal = {
	params ["_journalName", "_entry"];
	
	_dbHandle = ["new", DMP_dbNameJournals] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	//systemChat ("sc " + str(_sections));
	if not (_journalName in _sections) exitWith {
		//systemChat ("jn " + str(_journalName));
		["write", [_journalName, (DMP_dbJournalEntryPrefix + "0"), _entry]] call _dbHandle;
	};
	
	_keys = ["getKeys", _journalName] call _dbHandle;
	_lastKey = _keys select (count _keys - 1);
	_index = parseNumber ((_lastKey splitString "_") select 1);
	_index = _index + 1;
	
	_key = (DMP_dbJournalEntryPrefix + str(_index));
	["write", [_journalName, _key, _entry]] call _dbHandle;
};

DMP_fnc_deleteJournal = {
	params ["_journalName"];
	_dbHandle = ["new", DMP_dbNameJournals] call OO_INIDBI;
	["deleteSection", _journalName] call _dbHandle;
};

DMP_fnc_editJournalEntry = {
	params ["_journalName", "_entryIndex", "_newValue"];
	_dbHandle = ["new", DMP_dbNameJournals] call OO_INIDBI;
	
	_key = (DMP_dbJournalEntryPrefix + str(_entryIndex));
	["write", [_journalName, _key, _newValue]] call _dbHandle;
};

DMP_fnc_getAllPersistentJournals = {
	_dbHandle = ["new", DMP_dbNameJournals] call OO_INIDBI;
	_ids = "getSections" call _dbHandle;
	_ids
};