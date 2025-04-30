fnc_getVariablesForEditing = {
	params ["_varNames", "_getter"];
	
	private _lines = [];
	
	{
		private _varName = _x;
		private _value = [_varName] call _getter;
		_lines pushBack format ["%1=%2", _varName, _value];
	} forEach _varNames;
	
	private _newline = toString [10];
	private _result = _lines joinString _newline;
	
	_result
};

fnc_formatValueForEditing = {
	params ["_value"];

	if (typeName _value isEqualTo "STRING") exitWith {
		format ["""%1""", _value]  // Wrap string in double quotes
	};

	if (typeName _value isEqualTo "ARRAY") exitWith {
		private _formatted = _value apply {
			[_x] call fnc_formatValueForEditing
		};
		format ["[%1]", _formatted joinString ","]
	};

	// Default: number, bool, etc.
	str _value
};

fnc_parseVariableString = {
	params ["_str"];

	private _lines = _str splitString toString [10];
	private _map = createHashMap;

	{
		if (_x find "=" > -1) then {
			private _parts = _x splitString "=";
			private _var = _parts select 0;
			private _rawValue = (_parts select [1]) joinString "=";  // In case value contains '='

			// Auto-detect value type
			private _parsedValue = call {
				if (_rawValue isEqualTo "true") exitWith { true };
				if (_rawValue isEqualTo "false") exitWith { false };
				if (_rawValue regexMatch "^-?[0-9]+(\.[0-9]+)?$") exitWith { parseNumber _rawValue };
				if (_rawValue select [0,1] isEqualTo """") then {
					// It's a string
					_rawValue select [1, count _rawValue - 2]
				} else {
					// Try parsing as array
					private _res = parseSimpleArray _rawValue;
					if (typeName _res == "ARRAY") then { _res } else { _rawValue };
				}
			};

			_map set [_var, _parsedValue];
		};
	} forEach _lines;

	_map
};

fnc_setEditedVariables = {
	params ["_originalString", "_newString", "_setter"];

	private _originalMap = [_originalString] call fnc_parseVariableString;
	private _newMap = [_newString] call fnc_parseVariableString;

	{
		private _varName = _x;
		if (_varName in _newMap) then {
			private _originalValue = _originalMap get _varName;
			private _newValue = _newMap get _varName;
						
			if (!(_originalValue isEqualTo _newValue)) then {
				[_varName, _newValue] call _setter;
			};
		};
	} forEach keys _originalMap;
};

