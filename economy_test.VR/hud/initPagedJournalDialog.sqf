fnc_requestAndShowJournalPaged = {
    params ["_journalName", ["_pageIndex", -1], ["_itemsPerPage", 10], ["_header", ""]];

    // Close existing dialog to avoid stacking
    if (!isNull findDisplay 13800) then {
        closeDialog 0;
        waitUntil { isNull findDisplay 13800 };
    };

    private _result = ["DMP_fnc_getJournalEntriesPaged", [_journalName, _itemsPerPage, _pageIndex]] call DMP_fnc_requestServerResult;
    _result params ["_returnPageIndex", "_totalPages", "_entries"];

    // Cache info in uiNamespace
    uiNamespace setVariable ["JournalCurrentName", _journalName];
    uiNamespace setVariable ["JournalTotalPages", _totalPages];
    uiNamespace setVariable ["JournalCurrentPage", _returnPageIndex];
    uiNamespace setVariable ["JournalItemsPerPage", _itemsPerPage];
	
	private _indexOffset = _returnPageIndex * _itemsPerPage;
    private _journalText = _header + ([_entries, _indexOffset] call fnc_formatAccountRecord);

    // Open dialog
    createDialog "PagedJournalDialog";
    waitUntil { !isNull (findDisplay 13800) };

    private _display = findDisplay 13800;

    // Update content text
    private _textCtrl = _display displayCtrl 2101;
    _textCtrl ctrlSetStructuredText parseText _journalText;

    // Estimate dynamic height
    private _lineCount = count (_entries);
    //private _estimatedHeight = _lineCount * 0.003;
	private _estimatedHeight = _lineCount * 0.1;
    _textCtrl ctrlSetPositionH (_estimatedHeight max 0.64);
    _textCtrl ctrlCommit 0;

    // Update page info text
    private _infoCtrl = _display displayCtrl 2104;
    _infoCtrl ctrlSetText format ["%1 / %2", _returnPageIndex + 1, _totalPages];
};

fnc_switchJournalPage = {
    params ["_direction"]; // "next" or "prev"

    private _journalName = uiNamespace getVariable ["JournalCurrentName", ""];
    private _page = uiNamespace getVariable ["JournalCurrentPage", 0];
    private _total = uiNamespace getVariable ["JournalTotalPages", 1];
    private _itemsPerPage = uiNamespace getVariable ["JournalItemsPerPage", 10];

    if (_journalName == "") exitWith {};

    private _newPage = switch (_direction) do {
        case "next": { (_page + 1) min (_total - 1) };
        case "prev": { (_page - 1) max 0 };
        default { _page };
    };

    if (_newPage == _page) exitWith {};

    [_journalName, _newPage, _itemsPerPage] call fnc_requestAndShowJournalPaged;
};
