DMP_fnc_getJournalEntries = {
	params ["_journalName"];
	
	_dbHandle = ["new", dbNameJournals] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	
	if not (_journalName in _sections) exitWith {[]};
	
	_keys = ["getKeys", _journalName] call _dbHandle;
	
	_entries = _keys apply {
		["read", [_journalName, _x, ""]] call _dbHandle
	};
	
	_entries
};

dbJournalEntryPrefix = "entry_";
DMP_fnc_addToJournal = {
	params ["_journalName", "_entry"];
	
	_dbHandle = ["new", dbNameJournals] call OO_INIDBI;
	_sections = "getSections" call _dbHandle;
	//systemChat ("sc " + str(_sections));
	if not (_journalName in _sections) exitWith {
		//systemChat ("jn " + str(_journalName));
		["write", [_journalName, (dbJournalEntryPrefix + "0"), _entry]] call _dbHandle;
	};
	
	_keys = ["getKeys", _journalName] call _dbHandle;
	_lastKey = _keys select (count _keys - 1);
	_index = parseNumber ((_lastKey splitString "_") select 1);
	_index = _index + 1;
	
	_key = (dbJournalEntryPrefix + str(_index));
	["write", [_journalName, _key, _entry]] call _dbHandle;
};

DMP_fnc_deleteJournal = {
	params ["_journalName"];
	_dbHandle = ["new", dbNameJournals] call OO_INIDBI;
	["deleteSection", _journalName] call _dbHandle;
};

DMP_fnc_editJournalEntry = {
	params ["_journalName", "_entryIndex", "_newValue"];
	_dbHandle = ["new", dbNameJournals] call OO_INIDBI;
	
	_key = (dbJournalEntryPrefix + str(_entryIndex));
	["write", [_journalName, _key, _newValue]] call _dbHandle;
};