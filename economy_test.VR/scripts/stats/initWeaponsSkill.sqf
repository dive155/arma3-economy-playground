sleep 5;

// TODO don't use on zeuses

private _skill0 = createHashMapFromArray [
	["canUseSight",false],
	["panicGain", 0.2],
	["nudgeMin",2], 
	["nudgeMax",8],
	["shakeMin",8], 
	["shakeMax",15],
	["ppStrength", 0.1]
];

private _skill1 = createHashMapFromArray [
	["canUseSight",false],
	["panicGain", 0.15],
	["nudgeMin", 0.4], 
	["nudgeMax",3],
	["shakeMin",3], 
	["shakeMax",9],
	["ppStrength", 0.08]
];

private _skill2 = createHashMapFromArray [
	["canUseSight",true],
	["panicGain", 0.1],
	["nudgeMin", 0.3], 
	["nudgeMax",5],
	["shakeMin",1], 
	["shakeMax",7],
	["ppStrength", 0.05]
];

private _skill3 = createHashMapFromArray [
	["canUseSight",true],
	["panicGain", 0],
	["nudgeMin", 0], 
	["nudgeMax",0],
	["shakeMin",0], 
	["shakeMax",0],
	["ppStrength", 0]
];

pdr_all_weapon_skills_configs = createHashMapFromArray [
	[0, _skill0],
	[1, _skill1],
	[2, _skill2],
	[3, _skill3]
];

pdr_current_weapon_skill = 3;

fnc_refreshPlayerWeaponSkill = {
	private _playerSkill = player getVariable ["rp_weaponSkill", 3];
	if ((_playerSkill isEqualType "") or (_playerSkill isEqualType [])) then {
		_playerSkill = 3;
	};

	if (pdr_current_weapon_skill != _playerSkill) then {
		pdr_current_weapon_skill = _playerSkill;
		pdr_current_weapon_skill_config = pdr_all_weapon_skills_configs get _playerSkill;
	};
};

call fnc_refreshPlayerWeaponSkill;

["ChromAberration", 200, [0.1, 0.1, true]] spawn {
	params ["_name", "_priority", "_effect", "_handle"];
	while {
		PDR_panicPP = ppEffectCreate [_name, _priority];
		PDR_panicPP < 0
	} do {
		_priority = _priority + 1;
	};
};

player addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	call fnc_refreshPlayerWeaponSkill;
	
	if (pdr_current_weapon_skill > 2) exitWith {};
	
	private _panicGain   = pdr_current_weapon_skill_config get "panicGain";
	private _nudgeMin    = pdr_current_weapon_skill_config get "nudgeMin";
	private _nudgeMax    = pdr_current_weapon_skill_config get "nudgeMax";
	private _shakeMin    = pdr_current_weapon_skill_config get "shakeMin";
	private _shakeMax    = pdr_current_weapon_skill_config get "shakeMax";
	private _ppStrength  = pdr_current_weapon_skill_config get "ppStrength";
	
	private _panic = _unit getVariable ["pdr_weaponPanic", 0];
	_panic = _panic + _panicGain;
	if (_panic > 1) then {_panic = 1};
	_unit setVariable ["pdr_weaponPanic", _panic]; 

	private _maxDegrees = _nudgeMin + (_nudgeMax * _panic); 
	private _nudgeYaw = (_maxDegrees * 2 * random 1) - _maxDegrees; 
	_unit setDir ((getDir _unit) + _nudgeYaw);

	private _shakeIntensity = _shakeMin + (_shakeMax * _panic);  
	private _shakeDuration = 0.4 + (_panic * 0.6);
	addCamShake [_shakeIntensity, 0.7, 25];
	
	PDR_panicPP ppEffectEnable true;
	PDR_panicPP ppEffectAdjust [_ppStrength * _panic, _ppStrength * _panic, true];
	PDR_panicPP ppEffectCommit 0;
}];

[
	{
		//call fnc_refreshPlayerWeaponSkill;
		
		if (pdr_current_weapon_skill > 2) exitWith {PDR_panicPP ppEffectEnable false};
		
		private _canUseSight = pdr_current_weapon_skill_config get "canUseSight";
		
		if (!_canUseSight and (cameraView == "gunner")) then {
			hint localize "STR_cant_aim";
			player switchCamera "internal";
		};
		
		private _panic = player getVariable ["pdr_weaponPanic", 0];
				
		if (_panic == 0) exitWith {PDR_panicPP ppEffectEnable false};
		
		_panic = _panic * 0.985;

		if (_panic < 0.05) then {_panic = 0};
		
		PDR_panicPP ppEffectAdjust [0.1 * _panic, 0.1 * _panic, true];
		PDR_panicPP ppEffectCommit 0;

		player setVariable ["pdr_weaponPanic", _panic, false];
		systemChat ("weapon panic " + str(_panic));
	},
	0.05
] call CBA_fnc_addPerFrameHandler;
