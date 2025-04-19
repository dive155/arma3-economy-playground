DMP_fnc_hintLocalized = {
	params ["_key", ["_formatArgs", []]];
	private _value = localize _key;
	
	if (count _formatArgs > 0) then {
		_formatArgs = [_value] append _formatArgs;
		_value = format _formatArgs;
	};
	
	hint _value;
};

DMP_fnc_setVarName = {
params ["_vehicle", "_varName"];
	_vehicle setVehicleVarName _varName;
	missionNamespace setVariable [_varName, _vehicle];
};