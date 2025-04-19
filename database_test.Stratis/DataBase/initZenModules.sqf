[localize "STR_DMP_moduleCategory", localize "STR_DMP_saveVehicle", {
	_target = _this select 1;

	// Check if the target is a man
	if (isNull _target || {_target isKindOf "Man"}) exitWith {
		[objNull, localize "STR_DMP_errorNotVehicleOrObject"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// Check if vehicle is already tracked
	if (!isNil "DMP_dbVehiclesToTrack" && {_target in DMP_dbVehiclesToTrack}) exitWith {
		[objNull, localize "STR_DMP_errorAlreadyTracked"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// Proceed to remoteExec the save function
	[_target] remoteExec ["DMP_fnc_saveVehicleData", 2];
	[objNull, localize "STR_DMP_saveSuccessfull"] call BIS_fnc_showCuratorFeedbackMessage;

}] call zen_custom_modules_fnc_register;

[localize "STR_DMP_moduleCategory", localize "STR_DMP_removeVehicle", {
	_target = _this select 1;

	// If placed on nothing or a man
	if (isNull _target || {_target isKindOf "Man"}) exitWith {
		[objNull, localize "STR_DMP_errorNotVehicleOrObject"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// If vehicle is not being tracked
	if (isNil "DMP_dbVehiclesToTrack" || {!(_target in DMP_dbVehiclesToTrack)}) exitWith {
		[objNull, localize "STR_DMP_errorNotTracked"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// Proceed to remove from database
	[_target] remoteExec ["DMP_fnc_removeVehicleFromData", 2];

	// Show success message
	[objNull, localize "STR_DMP_successRemoved"] call BIS_fnc_showCuratorFeedbackMessage;

}] call zen_custom_modules_fnc_register;

[localize "STR_DMP_moduleCategory", localize "STR_DMP_copyID", {
	_target = _this select 1;

	// If placed on nothing or a man
	if (isNull _target || {_target isKindOf "Man"}) exitWith {
		[objNull, localize "STR_DMP_errorNotVehicleOrObject"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// If object is not tracked
	if (isNil "DMP_dbVehiclesToTrack" || {!(_target in DMP_dbVehiclesToTrack)}) exitWith {
		[objNull, localize "STR_DMP_errorNotTracked"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	// Get variable name (database ID)
	private _id = vehicleVarName _target;

	// Copy to clipboard and show feedback
	copyToClipboard _id;
	[objNull, format [localize "STR_DMP_feedbackCopied", _id]] call BIS_fnc_showCuratorFeedbackMessage;

}] call zen_custom_modules_fnc_register;