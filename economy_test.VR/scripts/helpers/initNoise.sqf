if (isServer) then {
	PDR_noiseSounds = [
		"pdrstuff\sounds\constr1.ogg",
		"pdrstuff\sounds\constr2.ogg",
		"pdrstuff\sounds\constr3.ogg",
		"pdrstuff\sounds\constr4.ogg",
		"pdrstuff\sounds\constr5.ogg",
		"pdrstuff\sounds\constr6.ogg",
		"pdrstuff\sounds\constr7.ogg",
		"pdrstuff\sounds\constr8.ogg",
		"pdrstuff\sounds\constr9.ogg",
		"pdrstuff\sounds\constr10.ogg",
		"pdrstuff\sounds\constr_beep.ogg",
		"pdrstuff\sounds\constr_beep.ogg"
	];

	0 spawn {
		while {true} do {
			private _noiseEnabled = ["noiseEnabled"] call fnc_getWorldVariable;

			// Fix invalid noiseEnabled value
			if (typeName _noiseEnabled == "STRING") then {
				["noiseEnabled", false] call fnc_setWorldVariable;
				_noiseEnabled = false;
			};

			// Get min and max delay values
			private _minDelay = ["noiseMinDelay"] call fnc_getWorldVariable;
			private _maxDelay = ["noiseMaxDelay"] call fnc_getWorldVariable;

			// Validate types
			if (typeName _minDelay != "SCALAR" || {_minDelay < 0}) then {
				_minDelay = 5;
				["noiseMinDelay", _minDelay] call fnc_setWorldVariable;
			};

			if (typeName _maxDelay != "SCALAR" || {_maxDelay < _minDelay}) then {
				_maxDelay = 90;
				["noiseMaxDelay", _maxDelay] call fnc_setWorldVariable;
			};

			if (_noiseEnabled) then {
				// --- First (normal) sound ---
				private _sound = selectRandom PDR_noiseSounds;
				private _randPosATL = noise_trigger call BIS_fnc_randomPosTrigger;
				private _randPosASL = ATLToASL _randPosATL;

				playSound3D [_sound, objNull, false, _randPosASL, 5, 1, 150];
				
				// --- Optional "double sound" ---
				if (random 1 < 0.6) then {
					sleep (3 + random 5); // short delay: 3–8s

					private _sound2 = selectRandom PDR_noiseSounds;
					private _randPos2ATL = noise_trigger call BIS_fnc_randomPosTrigger;
					private _randPos2ASL = ATLToASL _randPos2ATL;
										
					playSound3D [_sound2, objNull, false, _randPos2ASL, 5, 1, 150];
				};
			};

			private _delay = (_minDelay + random (_maxDelay - _minDelay));
			sleep _delay;
		};
	};
};
