videoPlayerKnownMovies = [
	["pdr_movie_brat", "pdrstuff\video\brat.ogv", "DIVE_Video_Brat"]
];

_scriptHandle = [cinema, 0, cinema_crate] execVM "videoplayer\createVideoPlayer.sqf";
waitUntil { scriptDone _scriptHandle };

_scriptHandle = [cinema_1, 0, cinema_crate_1] execVM "videoplayer\createVideoPlayer.sqf";
waitUntil { scriptDone _scriptHandle };