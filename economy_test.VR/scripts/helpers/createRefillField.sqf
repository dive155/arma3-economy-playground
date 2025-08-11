params [
	"_trigger",       // Trigger area
	"_objectClass",   // Classname of the object to spawn
	"_threshold",     // Minimum number of objects to keep in the trigger
	"_amountToSpawn"  // Number of objects to spawn when threshold is not met
];

private _delay = 10 + random 3;

[
	{
		private _passedArgs = _this select 0;
		_passedArgs params [
			"_trigger",
			"_objectClass",
			"_threshold",
			"_amountToSpawn"
		];
		
		// Get largest trigger radius
		private _area = triggerArea _trigger;
		private _radius = (_area select 0) max (_area select 1);

		// Count matching objects inside trigger
		private _currentCount = {
			(_x isKindOf _objectClass) && { position _x inArea _trigger }
		} count (position _trigger nearObjects [_objectClass, _radius]);

		// If count is below threshold, spawn more
		if (_currentCount < _threshold) then {
			_passedArgs spawn {
				_this params [
					"_trigger",
					"_objectClass",
					"_threshold",
					"_amountToSpawn"
				];

				for "_i" from 1 to _amountToSpawn do {
					// Random position inside trigger
					private _pos = [_trigger] call BIS_fnc_randomPosTrigger;

					sleep 0.2;

					private _obj = createVehicle [_objectClass, _pos, [], 0, "NONE"];
					_obj setDir random 360;
				};
			};
		};
	}, 
	_delay, 
	_this
] call CBA_fnc_addPerFrameHandler;
