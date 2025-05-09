fnc_openRpDialog = {
	private _dialogOpen = createDialog "PDR_RP_Dialog";

	// Wait for dialog to be active
	waitUntil { !isNull findDisplay 8000 };

	// Populate information
	private _rpDay = ["rpDay"] call fnc_getWorldVariable;
	private _daysSinceLastMeal = player getVariable ["rp_daysSinceLastMeal", 0];
	private _fatigueCurrent = player getVariable ["rp_fatigue_current", 0];
	private _fatigueMax = player getVariable ["rp_fatigue_capacity", 4];
	private _passport = player getVariable ["grad_passport_passportRsc", ""];
	private _countryCode = [_passport] call fnc_getCitizenship;
	private _citizenship = localize ("STR_country" + _countryCode);
	private _permissions = player getVariable ["rp_permissions", []];
	private _debts = player getVariable ["rp_debts", []];

	// Format permissions
	private _localizedPerms = _permissions apply { localize ("STR_permission_" + _x) };
	private _permText = if (count _localizedPerms > 0) then { _localizedPerms joinString ", " } else { localize "STR_none" };

	// Format debts
	private _debtPDR = (_debts select { _x#0 == "PDR" }) param [0, ["PDR", 0]] select 1;
	private _debtMoldova = (_debts select { _x#0 == "Moldova" }) param [0, ["Moldova", 0]] select 1;

	private _infoText = format [
		"<t size='1.2'><t align='center'>%1</t></t><br/><br/>" +
		"%2: %3<br/>" +
		"%4: %5<br/>" +
		"%6: %7/%8<br/>" +
		"%9: %10<br/><br/>" +
		"%11: %12<br/><br/>" +
		"%13:<br/>%14: %15<br/>%16: %17",
		localize "STR_rpdialog_header_pdr_rp",
		localize "STR_rpdialog_current_day", _rpDay,
		localize "STR_rpdialog_days_since_meal", _daysSinceLastMeal,
		localize "STR_rpdialog_work_fatigue", _fatigueCurrent, _fatigueMax,
		localize "STR_rpdialog_citizenship", _citizenship,
		localize "STR_rpdialog_permissions", _permText,
		localize "STR_rpdialog_debts",
		localize "STR_rpdialog_countryPDR", _debtPDR,
		localize "STR_rpdialog_countryMoldova", _debtMoldova
	];

	((findDisplay 8000) displayCtrl 8001) ctrlSetStructuredText parseText _infoText;
};