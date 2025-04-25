fnc_showLongTextDialog = {
	params ["_text"];

	createDialog "LongTextDialog";
	waitUntil { !isNull (findDisplay 13786) };

	private _display = findDisplay 13786;
	private _ctrl = _display displayCtrl 2001;

	// Set text
	_ctrl ctrlSetStructuredText parseText _text;

	// === Dynamic height estimation ===
	private _lineHeight = 0.03; // Approximate height per line
	private _textPlain = _text splitString "<br/>"; // Very crude approximation
	private _lineCount = count _textPlain;
	private _estimatedHeight = _lineCount * _lineHeight;

	// Set dynamic height (max to ensure we don’t overflow vertically)
	_ctrl ctrlSetPositionH _estimatedHeight max 0.68;  // Clamp height
	_ctrl ctrlCommit 0;
}