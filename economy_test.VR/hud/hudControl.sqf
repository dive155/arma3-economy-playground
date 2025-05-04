// File: scripts/hudControl.sqf

// Show HUD
fnc_showFuelIndicator = {
	if (isNil "CustomHUD_Display") then {
		cutRsc ["CustomHUD", "PLAIN"];
	};
};

// Hide HUD
// fnc_hideFuelIndicator = {
    // if (!isNil "CustomHUD_Display") then {
        // (uiNamespace getVariable "CustomHUD_Display") closeDisplay 1;
        // uiNamespace setVariable ["CustomHUD_Display", nil];
    // };
// };

fnc_hideFuelIndicator = {
	private _disp = uiNamespace getVariable "CustomHUD_Display";
	if (!isNil "_disp") then {
		_disp closeDisplay 1;
		uiNamespace setVariable ["CustomHUD_Display", nil];
	};
};

// Set HUD text lines
fnc_updateFuelIndicator = {
    params ["_line1", "_line2", "_line3"];
    private _display = uiNamespace getVariable "CustomHUD_Display";
    if (!isNil "_display") then {
        (_display displayCtrl 1001) ctrlSetText _line1;
        (_display displayCtrl 1002) ctrlSetText _line2;
        (_display displayCtrl 1003) ctrlSetText _line3;
    };
};
