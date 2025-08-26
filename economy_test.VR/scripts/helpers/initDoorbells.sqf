/*
    initDoorbells.sqf
    Adds ACE actions to doorbell objects (doorbell_1, doorbell_2, ...).
    Each doorbell can only be checked once per mission/session.
    50% chance to spawn "pdr_stahlpot" in front of the doorbell.
*/

if (!hasInterface) exitWith {};

fn_spawnItemInFront = {
	params ["_obj", "_itemClass", ["_dist", -2]];

	if (isNull _obj) exitWith {
		diag_log "spawnItemInFront: Object is null!";
	};

	// get position in front
	private _pos = _obj modelToWorld [0, _dist, 0];

	// project down to terrain surface
	_pos set [2, (getTerrainHeightASL _pos) + 0.05]; // tiny offset to avoid clipping

	// spawn a ground weapon holder
	private _holder = createVehicle ["GroundWeaponHolder_Scripted", _pos, [], 0, "CAN_COLLIDE"];
	_holder setPosASL _pos;
	_holder addItemCargoGlobal [_itemClass, 1];
};

// function that handles a single doorbell interaction
_doorbellActionFunc = {
    params ["_target", "_player", "_params"];
    private _doorbellIndex = _params select 0;

	// get list of already checked doorbells
	private _checkedDoorbells = ["checkedDoorbells"] call fnc_getWorldVariable;
	if (_checkedDoorbells isEqualType "") then {
		_checkedDoorbells = [];
	};

    // already checked?
    if (_doorbellIndex in _checkedDoorbells) exitWith {
        hint localize "STR_doorbell_already_checked";
    };

    // mark as checked
    _checkedDoorbells pushBack _doorbellIndex;
    ["checkedDoorbells", _checkedDoorbells] call fnc_setWorldVariable;

    // play doorbell sound
    //playSound3D ["pdrstuff\sounds\doorbell.ogg", _target, false, getPosASL _target, 1, 1, 40];
	playSound3D ["pdrstuff\sounds\machine_success.ogg", _target, false, getPosASL _target, 1, 1, 40];

    // 50% chance outcome
    if (random 1 < 0.5) then {
        // SUCCESS – spawn item
        [_target, "pdr_stahlpot", -1] call fn_spawnItemInFront;
        hint localize "STR_doorbell_success";
    } else {
        // FAILURE
        hint localize "STR_doorbell_failure";
    };
};

// go through all doorbells sequentially
private _index = 1;
while {true} do {
    private _doorbellName = format ["doorbell_%1", _index];
    private _doorbellObj = missionNamespace getVariable [_doorbellName, objNull];

    if (isNull _doorbellObj) exitWith {};  // stop if no more doorbells

    // create ACE action for this doorbell
    private _doorbellAction = [
        format ["CheckDoorbell_%1", _index],   // unique action ID
        localize "STR_doorbell_action",        // localized action text
        "",
        _doorbellActionFunc,
        {true},
        {},
        [_index]                               // pass index to function
    ] call ace_interact_menu_fnc_createAction;

    [_doorbellObj, 0, [], _doorbellAction] call ace_interact_menu_fnc_addActionToObject;

    _index = _index + 1;
};
