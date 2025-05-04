#include "CustomControlClasses.h"
class PDR_RP_Dialog2
{
	idd = 8346;
	onLoad = "_this spawn fnc_populateRpDialog";

	class ControlsBackground
	{
		class RpBackground
		{
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.34375;
			y = safeZoneY + safeZoneH * 0.225;
			w = safeZoneW * 0.3125;
			h = safeZoneH * 0.55;
			style = 0;
			text = "";
			colorBackground[] = {0,0.061,0.2151,0.8852};
			colorText[] = {0.2549,0.7725,0.1961,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
	};

	class Controls
	{
		class HeaderControl
		{
			type = 0;
			idc = 1000;
			x = safeZoneX + safeZoneW * 0.44375;
			y = safeZoneY + safeZoneH * 0.225;
			w = safeZoneW * 0.1125;
			h = safeZoneH * 0.075;
			style = 2;
			text = "$STR_rpdialog_header_pdr_rp";
			colorBackground[] = {1,1,1,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.5);
		};

		class MainInfoText
		{
			type = 13;
			idc = 1001;
			x = safeZoneX + safeZoneW * 0.36875;
			y = safeZoneY + safeZoneH * 0.3;
			w = safeZoneW * 0.2625;
			h = safeZoneH * 0.125;
			style = 0;
			text = "";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			colorBackground[] = {1,1,1,0};
			tooltipColorText[] = {1,1,1,1};
			class Attributes {};
		};

		class OpenPassportButton
		{
			type = 1;
			idc = 1004;
			x = safeZoneX + safeZoneW * 0.36875;
			y = safeZoneY + safeZoneH * 0.425;
			w = safeZoneW * 0.0875;
			h = safeZoneH * 0.025;
			style = 0;
			text = "$STR_rpdialog_openpassport";
			action = "[grad_passport_fnc_receiveShowPassport, [ACE_player, player, true]] call CBA_fnc_execNextFrame";
			borderSize = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
		};

		class PermissionsInfoText
		{
			type = 13;
			idc = 1002;
			x = safeZoneX + safeZoneW * 0.36875;
			y = safeZoneY + safeZoneH * 0.475
			w = safeZoneW * 0.2625;
			h = safeZoneH * 0.15
			style = 0;
			text = "";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			colorBackground[] = {1,1,1,0};
			tooltipColorText[] = {1,1,1,1};
			class Attributes {};
		};

		class DebtInfoText
		{
			type = 13;
			idc = 1003;
			x = safeZoneX + safeZoneW * 0.36875;
			y = safeZoneY + safeZoneH * 0.65;
			w = safeZoneW * 0.1375;
			h = safeZoneH * 0.1;
			style = 0;
			text = "";
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			colorBackground[] = {1,1,1,0};
			tooltipColorText[] = {1,1,1,1};
			class Attributes {};
		};

		class DebtHistoryPDR
		{
			type = 1;
			idc = 1005;
			x = safeZoneX + safeZoneW * 0.54375;
			y = safeZoneY + safeZoneH * 0.675;
			w = safeZoneW * 0.0875;
			h = safeZoneH * 0.025;
			style = 0;
			text = "$STR_rpdialog_history";
			action = '["PDR"] spawn fnc_showOwnDebtHistory';
			borderSize = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
		};

		class DebtHistoryMoldova: DebtHistoryPDR
		{
			idc = 1006;
			y = safeZoneY + safeZoneH * 0.725;
			action = '["Moldova"] spawn fnc_showOwnDebtHistory';
		};
	};
};
