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