fnc_showOwnRpInfo = { 
	// Open the dialog 
	createDialog "PDR_RP_Dialog2"; 
 
	// Wait for dialog to open 
	waitUntil { !isNull (findDisplay 8346) }; 
	private _display = findDisplay 8346; 
	if (isNull _display) exitWith {}; 
 
	// === GET DATA === 
 
	// Day 
	private _currentDay = ["rpDay"] call fnc_getWorldVariable; 
 
	// Meal 
	private _daysSinceMeal = player getVariable ["rp_daysSinceLastMeal", 0]; 
 
	// Fatigue 
	private _fatigueCurrent = player getVariable ["rp_fatigue_current", 0]; 
	private _fatigueMax = player getVariable ["rp_fatigue_capacity", 4]; 
 
	// Citizenship 
	private _passport = player getVariable ["grad_passport_passportRsc", ""]; 
	private _countryCode = [_passport] call fnc_getCitizenship; 
	private _citizenship = localize ("STR_country" + _countryCode); 
 
	// Permissions 
	private _perms = player getVariable ["rp_permissions", []]; 
	private _permTextList = _perms apply { localize ("STR_permission_" + _x) }; 
	private _permissionsText = _permTextList joinString ", "; 
	if (_permissionsText isEqualTo "") then { _permissionsText = localize "STR_common_none"; };
	_permissionsText = "<t size='0.8' color='#fce0ff'>" + _permissionsText + "</t>";
 
	// Debts 
	private _debts = player getVariable ["rp_debts", []]; 
 
	private _debtPDR = 0; 
	private _debtMoldova = 0; 
	{ 
		private _tag = _x select 0; 
		private _amount = _x select 1; 
		if (_tag == "PDR") then { _debtPDR = _amount; }; 
		if (_tag == "Moldova") then { _debtMoldova = _amount; }; 
	} forEach _debts; 
 
	// === SET TEXT === 
 
	// Header 
	private _header = _display displayCtrl 1000; 
	if (!isNull _header) then { 
		_header ctrlSetText (localize "STR_rpdialog_header_pdr_rp"); 
	}; 
 
	// Main Info 
	private _mainInfo = _display displayCtrl 1001; 
	if (!isNull _mainInfo) then { 
		private _infoText = format [ 
			"%1: %2<br/>%3: %4<br/>%5: %6/%7<br/>%8: %9", 
			localize "STR_rpdialog_current_day", _currentDay, 
			localize "STR_rpdialog_days_since_meal", _daysSinceMeal, 
			localize "STR_rpdialog_work_fatigue", _fatigueCurrent, _fatigueMax, 
			localize "STR_rpdialog_citizenship", _citizenship 
		]; 
		_mainInfo ctrlSetStructuredText parseText _infoText; 
	}; 
 
	// Permissions Info 
	private _permCtrl = _display displayCtrl 1002; 
	if (!isNull _permCtrl) then { 
		private _permLabel = localize "STR_rpdialog_permissions"; 
		private _text = format ["%1:<br/>%2", _permLabel, _permissionsText]; 
		_permCtrl ctrlSetStructuredText parseText _text; 
	}; 
 
	// Debt Info 
	private _debtCtrl = _display displayCtrl 1003; 
	if (!isNull _debtCtrl) then { 
		private _debtLabel = localize "STR_rpdialog_debts"; 
		private _pdr = localize "STR_rpdialog_countryPDR"; 
		private _mol = localize "STR_rpdialog_countryMoldova"; 
		private _text = format ["%1:<br/>%2: %3<br/><br/>%4: %5", _debtLabel, _pdr, _debtPDR, _mol, _debtMoldova]; 
		_debtCtrl ctrlSetStructuredText parseText _text; 
	};
	
		 // Open Passport Button
	private _passportBtn = _display displayCtrl 1004;
	if (!isNull _passportBtn) then {
		_passportBtn ctrlAddEventHandler ["ButtonClick", {
			// Execute the passport action
			[grad_passport_fnc_receiveShowPassport, [ACE_player, player, true]] call CBA_fnc_execNextFrame;
	
			// Close the main RP dialog
			closeDialog 8346;
		}];
	};
	
	// Debt History PDR Button
	private _pdrBtn = _display displayCtrl 1005;
	if (!isNull _pdrBtn) then {
		_pdrBtn ctrlAddEventHandler ["ButtonClick", {
			["PDR"] spawn fnc_showOwnDebtHistory;
		}];
	};

	// Debt History Moldova Button
	private _molBtn = _display displayCtrl 1006;
	if (!isNull _molBtn) then {
		_molBtn ctrlAddEventHandler ["ButtonClick", {
			["Moldova"] spawn fnc_showOwnDebtHistory;
		}];
	}; 
};