class PagedJournalDialog {
	idd = 13800;
	movingEnable = false;
	enableSimulation = true;

	class controlsBackground {
		class Background: RscText {
			idc = -1;
			x = 0.1;
			y = 0.1;
			w = 0.8;
			h = 0.8;
			colorBackground[] = {0, 0, 0, 0.85};
		};
	};

	class controls {
		class ScrollGroup: RscControlsGroup {
			idc = 2100;
			x = 0.12;
			y = 0.12;
			w = 0.76;
			h = 0.64;

			class controls {
				class TextContent: RscStructuredText {
					idc = 2101;
					x = 0;
					y = 0;
					w = 0.74;
					h = 1;
					text = "";
					size = 0.04;
				};
			};
		};

		class PrevButton: RscButton {
			idc = 2102;
			text = "$STR_JournalPrev";
			x = 0.12;
			y = 0.78;
			w = 0.2;
			h = 0.05;
			action = "['prev'] spawn fnc_switchJournalPage;";
		};

		class NextButton: RscButton {
			idc = 2103;
			text = "$STR_JournalNext";
			x = 0.68;
			y = 0.78;
			w = 0.2;
			h = 0.05;
			action = "['next'] spawn fnc_switchJournalPage;";
		};

		class PageInfoText: RscText {
			idc = 2104;
			text = "";
			x = 0.34;
			y = 0.78;
			w = 0.32;
			h = 0.05;
			style = 2; // Center
			SizeEx = 0.04;
		};

		class CloseButton: RscButton {
			idc = 2105;
			text = "$STR_hudClose";
			x = 0.4;
			y = 0.83;
			w = 0.2;
			h = 0.05;
			action = "closeDialog 0;";
		};
	};
};