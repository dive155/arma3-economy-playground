private _scriptHandle = 0 execVM "scripts\helpers\party\clubAmbiance.sqf";
waitUntil { scriptDone _scriptHandle };

private _scriptHandle = 0 execVM "scripts\helpers\party\clubDancers.sqf";
waitUntil { scriptDone _scriptHandle };

fnc_startPartyCommand = { 
	0 spawn {
		missionNamespace setVariable ["DIVE_partyActive", true, true];
	
		{
			[_x, false] remoteExec ["hideObjectGlobal", _x];
		} foreach [dancer_0, dancer_1, dancer_2, dancer_3, dancer_4, dancer_5, dancer_6, dancer_7, dancer_8, dancer_9];
		
		sleep 2;
	
		remoteExec ["fn_createDanceFloorLightsLocal"];
		remoteExec ["fn_startDancingServer", 2];
		//remoteExec ["fn_startMusicServer", 2];
	};
};


fnc_stopPartyCommand = {
	missionNamespace setVariable ["DIVE_partyActive", false, true];
	remoteExec ["fn_destroyDanceFloorLightsLocal"]; 
	remoteExec ["fn_stopDancingServer", 2];
	//remoteExec ["fn_stopMusicServer", 2];
}