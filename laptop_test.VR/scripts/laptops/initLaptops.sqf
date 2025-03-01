sleep 5;

private _computer = laptopMayor;

private _ptr = []; // current working dir; not necessary in this case
private _filesystem = _computer getVariable "AE3_filesystem"; // the complete filesystem of a computer
private _path = "hint";
//private _content = compile loadFile "scripts\laptops\hintCommand.sqf";
private _content = compile preprocessFileLineNumbers "scripts\laptops\hintCommand.sqf";
private _user = "root"; // The user that performs the action/adds the file
private _owner = "Mayor"; // the final owner of the file
private _permissions = [[true, true, true], [true, true, true]]; // ownerX, ownerR, ownerW, otherX, otherR, otherW

[_ptr, _filesystem, _path, _content, _user, _owner, _permissions] call AE3_filesystem_fnc_createFile;

_computer setVariable ["AE3_filesystem", _filesystem, true]; // write filesystem back to computer