fnc_requestAndShowJournalPaged = {
    params ["_journalName", ["_header", ""], ["_pageIndex", -1], ["_itemsPerPage", 10]];

    private _isFirstOpen = isNull findDisplay 13800;

    // Only open the dialog if it doesn't exist yet
    if (_isFirstOpen) then {
        createDialog "PagedJournalDialog";
        waitUntil { !isNull (findDisplay 13800) };
    };

	private _display = findDisplay 13800;
	private _textCtrl = _display displayCtrl 2101;
	_textCtrl ctrlSetStructuredText parseText localize "STR_Journal_Loading";
	
	private _infoCtrl = _display displayCtrl 2104;
	_infoCtrl ctrlSetText "-";

    private _result = ["DMP_fnc_getJournalEntriesPaged", [_journalName, _itemsPerPage, _pageIndex]] call DMP_fnc_requestServerResult;
    _result params ["_returnPageIndex", "_totalPages", "_entries"];

    // Cache variables in uiNamespace
    uiNamespace setVariable ["JournalCurrentName", _journalName];
    uiNamespace setVariable ["JournalTotalPages", _totalPages];
    uiNamespace setVariable ["JournalCurrentPage", _returnPageIndex];
    uiNamespace setVariable ["JournalItemsPerPage", _itemsPerPage];

    // Save header (so it's preserved on page switches)
    if (_isFirstOpen) then {
        uiNamespace setVariable ["JournalCurrentHeader", _header];
    } else {
        _header = uiNamespace getVariable ["JournalCurrentHeader", ""];
    };

	private _indexOffset = _returnPageIndex * _itemsPerPage;
    private _journalText = _header + ([_entries, _indexOffset] call fnc_formatAccountRecord);

    private _display = findDisplay 13800;
    private _textCtrl = _display displayCtrl 2101;

    _textCtrl ctrlSetStructuredText parseText _journalText;

    // Dynamic height estimate
    private _lineCount = count (_entries);
    //private _estimatedHeight = _lineCount * 0.003;
	private _estimatedHeight = _lineCount * 0.17;
    _textCtrl ctrlSetPositionH (_estimatedHeight max 0.64);
    _textCtrl ctrlCommit 0;
	
	private _scrollGroup = _display displayCtrl 2100;
	_scrollGroup ctrlSetScrollValues [0, 0];

    // Update page info display
    private _infoCtrl = _display displayCtrl 2104;
    _infoCtrl ctrlSetText format ["%1 / %2", _returnPageIndex + 1, _totalPages];
};

fnc_switchJournalPage = {
    params ["_direction"]; // "next" or "prev"

    private _journalName = uiNamespace getVariable ["JournalCurrentName", ""];
    private _header = uiNamespace getVariable ["JournalCurrentHeader", ""];
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

    // Pass _header along with other arguments
    [_journalName, _header, _newPage, _itemsPerPage] call fnc_requestAndShowJournalPaged;
};
