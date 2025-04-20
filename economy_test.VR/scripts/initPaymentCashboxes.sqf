_cashboxSounds = [
    "a3\missions_f_beta\data\sounds\firing_drills\target_pop-down_large.wss",
    "pdrstuff\sounds\machine_success_money.ogg",
    "pdrstuff\sounds\machine_error.ogg"
];

[
    payment_button_pdr,
    payment_box_pdr,
    "PDR",
    "pdrLeu",
    _cashboxSounds
] execVM "scripts\economy\createPaymentCashbox.sqf";

[
    payment_button_moldova,
    payment_box_moldova,
    "Moldova",
    "moldovaLeu",
    _cashboxSounds
] execVM "scripts\economy\createPaymentCashbox.sqf";