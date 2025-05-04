class PDR_RP_Dialog {
    idd = 8000;
    movingEnable = false;
    enableSimulation = true;
    onUnload = "if !(isNull (findDisplay 8001)) then { (findDisplay 8001) closeDisplay 1 };";

    class controlsBackground {
        class BG: RscText {
            idc = -1;
            x = 0.1; y = 0.1;
            w = 0.6; h = 0.8;
            colorBackground[] = {0,0,0,0.7};
        };
    };

    class controls {
        // class Title: RscText {
            // idc = -1;
            // text = "PDR RP";
            // x = 0.3; y = 0.2;
            // w = 0.4; h = 0.04;
        // };

        class InfoText: RscStructuredText {
            idc = 8001;
            x = 0.11; y = 0.11;
            w = 0.5; h = 0.7;
        };

        class BtnPassport: RscButton {
            idc = 8002;
            text = "$STR_rpdialog_openpassport";
            x = 0.37; y = 0.33;
            w = 0.18; h = 0.04;
            action = "[grad_passport_fnc_receiveShowPassport,[ACE_player,player,true]] call CBA_fnc_execNextFrame; closeDialog 0;";
        };

		class BtnDebt1: RscButton {
			idc = 8003;
			text = "$STR_rpdialog_history";
			x = 0.33; y = 0.66;
			w = 0.15; h = 0.04;
			action = "[""PDR""] spawn fnc_showOwnDebtHistory; closeDialog 0;";
		};

        class BtnDebt2: RscButton {
            idc = 8004;
            text = "$STR_rpdialog_history";
            x = 0.33; y = 0.71;
            w = 0.15; h = 0.04;
            action = "[""Moldova""] spawn fnc_showOwnDebtHistory; closeDialog 0;";
        };
    };
};
