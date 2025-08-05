if (isServer) then {
	
	fnc_verifyShouldOpen = {
		params ["_player", "_expectedFrom", "_expectedTo", "_expectedCompleted"];
		
		private _pendingCrossing = _player getVariable ["rp_crossingPending", []];
		private _shouldOpen = false;
		if (count _pendingCrossing > 0) then {
			_pendingCrossing params ["_from", "_to", "_completed"];
			_shouldOpen = (_from isEqualTo _expectedFrom) and (_to isEqualTo _expectedTo) and (_completed == _expectedCompleted);
		};
		
		_shouldOpen
	};

	[
		gate_moldova_exit,
		gate_moldova_exit_trigger,
		{
			params ["_player"];
			[_player, "Moldova", "PDR", false] call fnc_verifyShouldOpen;
		},
		{true}
	]execVM "scripts\helpers\createAutomatedBoomgate.sqf";
	
	[
		gate_pdr_entry,
		gate_pdr_entry_trigger,
		{
			params ["_player"];
			[_player, "Moldova", "PDR", true] call fnc_verifyShouldOpen;
		},
		{true}
	]execVM "scripts\helpers\createAutomatedBoomgate.sqf";

	[
		gate_pdr_exit,
		gate_pdr_exit_trigger,
		{
			params ["_player"];
			[_player, "PDR", "Moldova", false] call fnc_verifyShouldOpen;
		},
		{true}
	]execVM "scripts\helpers\createAutomatedBoomgate.sqf";
	
	[
		gate_moldova_entry,
		gate_moldova_entry_trigger,
		{
			params ["_player"];
			[_player, "PDR", "Moldova", true] call fnc_verifyShouldOpen;
		},
		{true}
	]execVM "scripts\helpers\createAutomatedBoomgate.sqf";
};