[] spawn {
    private _bufferSize = 10;
    private _positions = [];
    private _fuelLevels = [];
    private _index = 0;
    private _filled = false;

    private _lastVehicle = objNull;
    private _aceFuelCap = 0;
    private _vanFuelCap = 0;

    // Initialize buffers
    for "_i" from 0 to (_bufferSize - 1) do {
        _positions pushBack [0,0,0];
        _fuelLevels pushBack 0;
    };

    while {true} do {
        private _vehicle = vehicle player;

        if (!isNull _vehicle && _vehicle != player && driver _vehicle == player) then {
            // Vehicle changed
            if (_vehicle != _lastVehicle) then {
                _lastVehicle = _vehicle;
                _index = 0;
                _filled = false;

                _aceFuelCap = getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "ace_refuel_fuelCapacity");
                _vanFuelCap = getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "fuelCapacity");
				
				private _startPos = getPosATL _vehicle;
				for "_i" from 0 to (_bufferSize - 1) do {
					_positions pushBack _startPos;
					_fuelLevels pushBack 0;
				};

                if (_aceFuelCap < 0.1) then {
                    //hint "Warning: No ACE fuel capacity detected. Results may be inaccurate.";
                };
            };

			if ( (abs (speed _vehicle)) > 2) then {
				// Update circular buffer
				_positions set [_index, getPosATL _vehicle];
				_fuelLevels set [_index, fuel _vehicle];

				private _oldestIndex = (_index + 1) % _bufferSize;
				private _newestIndex = _index;

				_index = (_index + 1) % _bufferSize;
				if (!_filled && _index == 0) then {
					_filled = true;
				};

				private _distance = 0;
				private _fuelUsed = 0;

				if (_filled) then {
					// Calculate distance over buffer
					for "_i" from 0 to (_bufferSize - 2) do {
						private _a = _positions select ((_oldestIndex + _i) % _bufferSize);
						private _b = _positions select ((_oldestIndex + _i + 1) % _bufferSize);
						_distance = _distance + (_a vectorDistance _b);
					};

					private _oldestFuel = _fuelLevels select _oldestIndex;
					private _newestFuel = _fuelLevels select _newestIndex;

					_fuelUsed = _oldestFuel - _newestFuel;
					if (_fuelUsed < 0) then { _fuelUsed = 0 }; // Just in case
				};


				private _fuelCap = _aceFuelCap max _vanFuelCap;
				private _fuelUsedLiters = _fuelUsed * _fuelCap;
				private _litersPerKm = if (_distance > 0) then {
					(_fuelUsedLiters * 1000) / _distance
				} else {0};

				private _fuelRemainingLiters = fuel _vehicle * _fuelCap;
				private _estimatedRange = if (_litersPerKm > 0) then {
					_fuelRemainingLiters / _litersPerKm
				} else {0};
				
				_litersText = if (_litersPerKm != 0) then { _litersPerKm toFixed 2 } else {"---"};
				_rangeText = if (_estimatedRange != 0) then { _estimatedRange toFixed 1 } else {"---"};
				call fnc_showFuelIndicator;
				[
					format [(localize "STR_hudCons1"), _litersText],
					format [(localize "STR_hudCons2"), _fuelRemainingLiters toFixed 1, _fuelCap toFixed 1],
					format [(localize "STR_hudCons3"), _rangeText]
				] call fnc_updateFuelIndicator;
				 
				// private _msg = format [
					// "Fuel consumption: %1 L/km\nFuel left: %2/%3 L\nEstimated range: %4 km",
					// _litersPerKm toFixed 2,
					// _fuelRemainingLiters toFixed 1,
					// _fuelCap toFixed 1,
					// _estimatedRange toFixed 1
				// ];

				//hintSilent _msg;
			};
        } else {
            // Player not in a vehicle
            _lastVehicle = objNull;
            _filled = false;
			call fnc_hideFuelIndicator;
        };

        sleep 1;
    };
};