//0 execVM "inits\customInitPlayerLocal.sqf";

["worldVariableChanged", {
    params ["_varName", "_newValue"];
    systemChat format ["%1 set to %2", _varName, _newValue];
}] call CBA_fnc_addEventHandlerArgs;