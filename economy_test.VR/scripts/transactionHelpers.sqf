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