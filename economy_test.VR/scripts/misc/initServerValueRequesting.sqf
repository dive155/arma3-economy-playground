fnc_requestServerResult = {
	params ["_resultVarName", "_functionName", "_arguments"];
	
	missionNamespace setVariable [_resultVarName, nil];
	
	[clientOwner, _resultVarName, _functionName, _arguments] remoteExec ["fnc_serverHandleResultRequested", 2];
	
	waitUntil {not isNil _resultVarName};
	
	missionNamespace getVariable _resultVarName
};

fnc_serverHandleResultRequested = {
	params ["_ownerNetworkId", "_resultVarName", "_functionName", "_arguments"];
	private _function = missionNamespace getVariable _functionName;
	private _result = _arguments call _function;
	
	[_resultVarName, _result] remoteExec ["fnc_clientHandleServerResultReceived", _ownerNetworkId];
};

fnc_clientHandleServerResultReceived = {
	params ["_resultVarName", "_result"];
	missionNamespace setVariable [_resultVarName, _result];
};