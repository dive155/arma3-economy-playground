fnc_handleAutomatedAccountTransaction = {
	params ["_accountName", "_playerName", "_operationType", "_amount"];
		
	private _accountMoney = [_accountName] call fnc_getWorldVariable;
	_accountMoney = _accountMoney + _amount;
	[_accountName, _accountMoney] call fnc_setWorldVariable;
	
	private _recordData = [
		_playerName,
		_operationType,
		_amount,
		_accountMoney,
		localize "STR_transactions_automatedSystem"
	];
	private _record = [_recordData] call fnc_composeAccountRecord;
	["accountJournal_" + _accountName, _record] remoteExec ["DMP_fnc_addToJournal", 2];
};

fnc_handlePlayerDebtTransaction = {
	params ["_steamId", "_instigatorName", "_countryCode", "_operationType", "_amount", "_playersNote"];
	
	private _debts = ["request_debts", "DMP_fnc_getPlayerVariableSteamId", [_steamId, "rp_debts", []]] call fnc_requestServerResult;
	
	if (count _debts == 0) exitWith {hint "Error: No debts defined"};
	
	private _debtBalance = 0;
    private _newDebts = [];
    {
        private _code = _x select 0;
        if (_code == _countryCode) then {
			_debtBalance = _x select 1;
            _debtBalance = _debtBalance + _amount;
			_newDebts pushBack [_code, _debtBalance];
        } else {
            _newDebts pushBack _x;
        };
    } forEach _debts;
	
	[_steamId, "rp_debts", _newDebts, true] remoteExec ["DMP_fnc_setPlayerVariableSteamId", 2];
	
	private _record = [[
		_instigatorName,
		_operationType,
		_amount,
		_debtBalance,
		_playersNote
	]] call fnc_composeAccountRecord;
	
	["debt_" + _steamId + "_" + _countryCode, _record] remoteExec ["DMP_fnc_addToJournal", 2];
};