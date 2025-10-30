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
	_currentDay = "<t size='1.2' color='#1ade00'>" + str(_currentDay) + "</t>";
 
	// Meal 
	private _daysSinceMeal = player getVariable ["rp_daysSinceLastMeal", 0];
	private _mealColor = switch (_daysSinceMeal) do {
		case 0: { "#1ade00" };   // Green
		case 1: { "#ffff00" };   // Yellow
		case 2: { "#ffa500" };   // Orange
		default { "#ff0000" };   // Red (3 or more)
	};
	_daysSinceMeal = "<t color='" + _mealColor + "'>" + str(_daysSinceMeal) + "</t>";

	// Fatigue 
	private _fatigueCurrent = player getVariable ["rp_fatigue_current", 0];
	private _fatigueMaxActual = [player] call fnc_getFatigueCapacityEnergized;
	private _fatigueBase = player getVariable ["rp_fatigue_capacity", 4];

	private _fatigueMax = if (_fatigueMaxActual isEqualTo _fatigueBase) then {
		_fatigueMaxActual
	} else {
		// Display purple if boosted
		"<t color='#a020f0'>" + str(_fatigueMaxActual) + "</t>"
	};

	private _fatigueColor = switch (true) do {
		case (_fatigueCurrent == 0): { "#1ade00" };                             // Green
		case (_fatigueCurrent < _fatigueMaxActual - 1): { "#ffff00" };         // Yellow
		case (_fatigueCurrent == _fatigueMaxActual - 1): { "#ffa500" };        // Orange
		default { "#ff0000" };                                                 // Red
	};

	_fatigueCurrent = "<t color='" + _fatigueColor + "'>" + str(_fatigueCurrent) + "</t>";


	// Citizenship 
	private _passport = player getVariable ["grad_passport_passportRsc", ""];
	private _countryCode = [_passport] call fnc_getCitizenship;
	private _citizenship = localize ("STR_country" + _countryCode);
	private _citizenshipColor = switch (_countryCode) do {
		case "Pdr": { "#3daeff" };       // Blue
		case "Moldova": { "#ff0000" };   // Red
		default { "#ffffff" };           // Default white
	};
	_citizenship = "<t color='" + _citizenshipColor + "'>" + _citizenship + "</t>";
 
	// Permissions 
	private _perms = player getVariable ["rp_permissions", []]; 
	private _permTextList = _perms apply { localize ("STR_permission_" + _x) }; 
	private _permissionsText = _permTextList joinString ", ";
	
	private _weaponSkill = player getVariable ["rp_weaponSkill", 3];
	if ((_weaponSkill isEqualType "") or (_weaponSkill isEqualType [])) then {
		_weaponSkill = 3;
	};
	_weaponSkill = localize ("STR_rpdialog_weapon_skill_" + str(_weaponSkill));
	private _weaponSkill = "<br/><t size='0.7' color='#ffd333'>" + (localize "STR_rpdialog_weapon_skill_title") + " " + _weaponSkill + ".</t>";
	
	if (_permissionsText isEqualTo "") then { _permissionsText = localize "STR_common_none"; };
	_permissionsText = "<t size='0.6' color='#fce0ff'>" + _permissionsText + "</t>" + _weaponSkill;
 
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
	private _ratePDR = floor ((["interestRate_PDR"] call fnc_getWorldVariable) * 100);
	_ratePDR = format[localize "STR_rpdialog_rateday" ,_ratePDR];
	private _rateMoldova = floor ((["interestRate_Moldova"] call fnc_getWorldVariable) * 100);
	_rateMoldova = format[localize "STR_rpdialog_rateday" ,_rateMoldova];
	
	private _debtCtrl = _display displayCtrl 1003; 
	if (!isNull _debtCtrl) then { 
		private _debtLabel = localize "STR_rpdialog_debts"; 
		private _pdr = localize "STR_rpdialog_countryPDR"; 
		private _mol = localize "STR_rpdialog_countryMoldova"; 
		private _text = format ["<t size='0.6'>%1:<br/><t color='#3daeff'>%2: %3 %6</t><br/><br/><t color='#ff0000'>%4: %5 %7</t><t/>", _debtLabel, _pdr, _debtPDR, _mol, _debtMoldova, _ratePDR, _rateMoldova]; 
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