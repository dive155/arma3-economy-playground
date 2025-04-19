[localize "STR_DMP_moduleCategory", localize "STR_DMP_saveVehicle", {
	_target = _this select 1;

	// Check if the target is a man
	if (isNull _target || {_target isKindOf "Man"}) exitWith {
		[objNull, localize "STR_DMP_errorNotVehicleOrObject"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// Check if vehicle is already tracked
	if (!isNil "dbVehiclesToTrack" && {_target in dbVehiclesToTrack}) exitWith {
		[objNull, localize "STR_DMP_errorAlreadyTracked"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// Proceed to remoteExec the save function
	[_target] remoteExec ["fn_db_saveVehicleData", 2];
	[objNull, localize "STR_DMP_saveSuccessfull"] call BIS_fnc_showCuratorFeedbackMessage;

}] call zen_custom_modules_fnc_register;

[localize "STR_DMP_moduleCategory", localize "STR_DMP_removeVehicle", {
	_target = _this select 1;

	// If placed on nothing or a man
	if (isNull _target || {_target isKindOf "Man"}) exitWith {
		[objNull, localize "STR_DMP_errorNotVehicleOrObject"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// If vehicle is not being tracked
	if (isNil "dbVehiclesToTrack" || {!(_target in dbVehiclesToTrack)}) exitWith {
		[objNull, localize "STR_DMP_errorNotTracked"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// Proceed to remove from database
	[_target] remoteExec ["fn_db_removeVehicleFromData", 2];

	// Show success message
	[objNull, localize "STR_DMP_successRemoved"] call BIS_fnc_showCuratorFeedbackMessage;

}] call zen_custom_modules_fnc_register;