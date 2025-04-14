fn_updateVisaInfo = {
	params ["_player"];
	_passportText = [_player] call fn_compileVisaInfoForPassport;
	_player setVariable ["grad_passport_misc1", _passportText, true];
};

fn_updateCivilianInfo = {
	params ["_player"];
	_passportText = [_player] call fn_compileCivilianDataText;
	_player setVariable ["grad_passport_misc2", _passportText, true];
};

fn_compileVisaInfoForPassport = {
	params ["_player"];
	_visasResult = ([_player] call fn_compileVisaText) + ([_player, 4] call fn_compileCrossingsText);
	_visasResult
};

fn_compileVisaText = {
	params ["_player"];
	_visas = _player getVariable ["rp_visas", []];
	
	_visasText = "";
	if (count _visas > 0) then {
		{
		 	_countryName = _x select 0;
			_countryName = format ["<t shadow='2'>%1</t>",  localize ("STR_country" + _countryName)];
			
			_visaStatusBool = _x select 1;
			_visaStatus = if (_visaStatusBool) then {"Valid"} else {"Revoked"};
			
			_statusColor = "#ff0000";
			if (_visaStatusBool) then {
				_statusColor = "#02b008"
			};
			
			_visaStatus = format ["<t font='EtelkaMonospaceProBold' color='%1'>%2</t>", _statusColor, localize ("STR_visaStatus" + _visaStatus)];
			
			_visaResult = format [localize "STR_visaFormat", _countryName, _visaStatus] + "<br/>";
			_visasText = _visasText + _visaResult;
			
		} forEach _visas;
	};
	_visasText
};

fn_compileCrossingsText = {
	params ["_player", ["_numRows", -1]];
	_visasText = "<t underline='1'>" + localize ("STR_borderCrossings") + ":</t><br/>";
	_crossings = _player getVariable ["rp_borderCrossings", []];
	if (count _crossings > 0) then {
		if (_numRows != -1) then {
			private _count = count _crossings;
			_crossings = _crossings select [(_count max _numRows) - _numRows];
		};
	
		{
		 	_dateText = _x select 0;
			_country = _x select 1;
			_country = localize ("STR_country" + _country);
			
			_crossingIsEntry = _x select 2;
			_crossingType = if _crossingIsEntry then { "Entry" } else { "Exit" };
			_crossingType = localize ("STR_border" + _crossingType);
			
			_statusColor = "#ff0000";
			if (_crossingIsEntry) then {
				_statusColor = "#02b008"
			};
			
			_crossingResult = format ["%1 <t shadow='2'>%2</t>, <t font='EtelkaMonospaceProBold' color='%3'>%4</t>", _dateText, _country, _statusColor, _crossingType];
			_visasText = _visasText + _crossingResult + "<br/>";
		} forEach _crossings;
	};
	_visasText
};

fn_compileCivilianDataText = {
	params ["_player"];
	private _text = "";

	// Government Job
	private _govtJob = _player getVariable ["rp_govtjob", ""];
	_text = _text + format [localize "STR_govtJobFormat", "<t shadow='2'>" + _govtJob + "</t>"] + "<br/>";

	// Government Salary
	private _govtSalary = _player getVariable ["rp_govtsalary", 0];
	_text = _text + format [localize "STR_govtSalaryFormat", "<t shadow='2'>" + str _govtSalary + "</t>"] + "<br/>";

	// Daily Bills
	private _dailyBills = _player getVariable ["rp_dailybills", 0];
	_text = _text + format [localize "STR_dailyBills", "<t shadow='2'>" + str _dailyBills + "</t>"] + "<br/>";

	// Debt Information
	_text = _text + localize "STR_debtInfo" + "<br/>";
	private _debts = _player getVariable ["rp_debts", []];
	{
		private _countryCode = _x select 0;
		private _debt = _x select 1;
		private _countryName = localize format ["STR_country%1", _countryCode];
		_text = _text + format ["%1: <t shadow='2'>%2</t>", _countryName, _debt] + "<br/>";
	} forEach _debts;

	// Registration Address
	private _address = _player getVariable ["rp_registrationaddress", ""];
	_text = _text + localize "STR_registrationAddress" + "<br/>";
	if (_address != "") then {
		_text = _text + "<t shadow='2'>" + _address + "</t><br/>";
	};

	// Owned Property
	_text = _text + localize "STR_ownedProperty" + "<br/>";
	private _properties = _player getVariable ["rp_ownedproperties", []];
	{
		_text = _text + "<t shadow='2'>" + _x + "</t><br/>";
	} forEach _properties;

	// Registered Vehicles
	_text = _text + localize "STR_registeredVehicles" + "<br/>";
	private _vehicles = _player getVariable ["rp_registeredvehicles", []];
	{
		_text = _text + "<t shadow='2'>" + _x + "</t><br/>";
	} forEach _vehicles;

	// Passport Notes
	private _notes = _player getVariable ["rp_passportnotes", ""];
	_text = _text + localize "STR_passportNotes" + "<br/>";
	if (_notes != "") then {
		_text = _text + "<t shadow='2'>" + _notes + "</t><br/>";
	};

	_text
};