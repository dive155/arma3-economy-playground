[
	crossing_button_pdr,
	"PDR",
	"Moldova",
	{ 0.5 }
]execVM "scripts\passports\createBorderCrossingMachine.sqf";

[
	crossing_button_moldova,
	"Moldova",
	"PDR",
	{ 0.5 }
]execVM "scripts\passports\createBorderCrossingMachine.sqf";

fnc_resetAutoBorderCrossing = {
	params ["_player"];
	
	_player setVariable ["rp_crossingPending", false, true];
	_player setVariable ["rp_checkupPending", false, true];
	
	systemChat "ResetStatus"
};

if (isServer) then {
	[
		{
			{
				if (_x inArea border_reset_trigger) then {
					[_x] call fnc_resetAutoBorderCrossing;
				};
			} forEach allPlayers;
		}, 
		1, 
	[]] call CBA_fnc_addPerFrameHandler;
};

