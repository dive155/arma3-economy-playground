fn_hintLocalized = {
	params ["_key", ["_formatArgs", []]];
	private _value = localize _key;
	
	if (count _formatArgs > 0) then {
		_formatArgs = [_value] append _formatArgs;
		_value = format _formatArgs;
	};
	
	hint _value;
};