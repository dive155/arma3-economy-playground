params ["_player", "_target", "_alpha", "_heightOffset", "_drawName", "_drawRank", "_drawSoundwave"];

private _name = _target getVariable ["grad_passport_firstName", ""];
private _surname = _target getVariable ["grad_passport_lastName", ""];
private _customName = _name + " " + _surname;

private _icon = "";
if (_drawRank && rank _target != "") then {
    _icon = format ["\A3\Ui_f\data\GUI\Cfg\Ranks\%1_gs.paa", rank _target];
};

private _color = [1, 1, 1, 1];
if ((group _target) != (group _player)) then {
    _color = [0.77, 0.51, 0.08, 0.8];
} else {
    switch (assignedTeam _target) do {
        case "RED": {_color = [1, 0.1, 0.1, 0.8]};
        case "GREEN": {_color = [0.18, 1, 0.17, 0.8]};
        case "BLUE": {_color = [0.08, 0.09, 1, 0.8]};
        case "YELLOW": {_color = [1, 1, 0, 0.8]};
        default {_color = [1, 1, 1, 0.8]};
    };
};

private _scale = linearConversion [0, 4, ace_nametags_tagSize, 0.333, 1, true];

private _pos = _target modelToWorldVisual ((_target selectionPosition "pilot") vectorAdd [0, 0, _heightOffset + 0.3]);

drawIcon3D [
    _icon,                  // Иконка ранга/рации
    _color,                 // Цвет текста
    _pos,                   // Позиция
    _scale,                 // Ширина иконки
    _scale,                 // Высота иконки
    0,                      // Угол поворота
    _customName,            // КАСТОМНОЕ ИМЯ
    2,                      // Тень (2 - с outline)
    0.05 * _scale,          // Размер текста
    "RobotoCondensed"       // Шрифт ACE3
];