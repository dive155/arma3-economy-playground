params["_computer", "_options", "_commandName"]; 
[_computer, "input: "] call AE3_armaos_fnc_shell_stdout; 
_output = [_computer] call AE3_armaos_fnc_shell_stdin; hint _output;