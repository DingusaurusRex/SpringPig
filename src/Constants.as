package  
{
	/**
	 * ...
	 * @author Jack
	 */
	public class Constants 
	{
		public static const SHOW_JUMP_HEIGHT:Boolean = true;
		// highlight non-empty tiles too
		public static const HIGHLIGHT_NON_EMPTY:Boolean = true;
		
		// A/B TESTING
		public static const JUMP_HEIGHT_ONE_HIGHER:Boolean = true;
		public static const HIGHLIGHT_PLAYER_SQUARE:Boolean = false; // highlight the whole square
		public static const HIGHLIGHT_SMALL_PLAYER_SQUARE:Boolean = false; // highlight only the top part of the square
		public static const MOVE_CRATES_IN_AIR:Boolean = true;
		public static const SHOW_BACKGROUND:Boolean = true;
		public static const SHOW_GRID:Boolean = false;

        /**
         * Debug Options
         */
        public static const SHOW_ALL_LEVELS:Boolean = true;

        /**
         * Rewind Options
         */
        public static const LIMIT_RECORD:Boolean = false;
        public static const RECORDED_FRAMES:int = 300;
        public static const UPDATES_BEFORE_REWIND:int = 1;

        public static const REWIND_SYMBOL_WIDTH:int = 229;
        public static const REWIND_SYMBOL_HEIGHT:int = 243;

        public static const REWIND_BAR_HEIGHT:int = 20;
        public static const REWIND_BAR_BOTTOM_PADDING:int = 5;
        public static const REWIND_BAR_LEFT_PADDING:int = 5;
        public static const REWIND_BAR_RIGHT_PADDING:int = 5;
        public static const REWIND_BAR_INNER_PADDING:int = 4;
        public static const REWIND_BAR_BACKGROUND_COLOR:uint = 0xFFFF66;
        public static const REWIND_BAR_COLOR:uint = 0x30EAEA;

        /**
         * Logging info
         */
        public static const LOG:Boolean = false;

        public static const GID:int = 116;
        public static const DB_NAME:String = "cgs_gc_SpringMan";
        public static const SKEY:String = "779979ab7f59b74ca0e57d9d7baeb9f0";

        // Action IDs
        public static const AID_SPRING:int = 1;
        public static const AID_RESET:int = 2;
        public static const AID_DEATH:int = 3;
        public static const AID_SUCCESSFUL_SPRING:int = 4;
        public static const AID_FAILED_SPRING:int = 5;
        public static const AID_SUCCESSFUL_TRAMPOLINE_SPRING:int = 6;
        public static const AID_FAILED_TRAMPOLINE_SPRING:int = 7;
        public static const AID_START_REWIND:int = 8;
        public static const AID_END_REWIND:int = 9;

        // Versions
        public static const VERSION_NULL:String = "NULL";
        public static const VERSION_A:String = "A";
        public static const VERSION_B:String = "B";

		/**
		 * Colors
		**/
		
		public static const BACKGROUND_COLOR:uint = 0xcceaff;
		public static const WALL_COLOR:uint = 0xD0D0D0;

		public static const IN_GAME_TEXT_COLOR:uint = 0x000080;

		// Grid values
		public static const GRID_THICKNESS:Number = 1;
		public static const GRID_COLOR:uint = 0x000000;
		public static const GRID_ALPHA:Number = 0.25;
		
		// Meter values
		public static const METER_BACKGROUND_COLOR:uint = 0xaaaaaa;
		public static const METER_LEVEL_COLOR:uint = 0xff0000;
		
		public static const METER_LINES_COLOR:uint = 0x000000;
		public static const METER_LINES_TICKNESS:uint = 1;
		
		// Sign Colors
		public static const SIGN_BORDER_COLOR:uint = 0x8B4513;
		public static const SIGN_BACKGROUND_COLOR:uint = 0xEECBAD;

		public static const SIGN_TEXT_FONT_SIZE:int = 17;
		public static const SIGN_TEXT_COLOR:uint = 0x8B4513;
		public static const SIGN_TEXT_ALPHA:Number = 0.6;
		public static const SIGN_TEXT_ALIGNMENT:String = "center";

		/**
		 * Screen Values
		**/
		
		public static const SCREEN_WIDTH:int = 800;
		public static const SCREEN_HEIGHT:int = 600;
		
		public static const SIDEBAR_WIDTH:int = 0;
		
		public static const BOARD_WIDTH:int = SCREEN_WIDTH - SIDEBAR_WIDTH;
		public static const BOARD_HEIGHT:int = SCREEN_HEIGHT;
		
		// Meter Values
		public static const METER_WIDTH:int = SIDEBAR_WIDTH;
		public static const METER_HEIGHT:int = 300;
		
		public static const METER_RULER_WIDTH:int = METER_WIDTH / 4;
		
		public static const METER_X:int = BOARD_WIDTH;
		public static const METER_Y:int	= 20;
		
		// Stopwatch Values
		public static const STOPWATCH_DEFAULT_TEXT:String = "00:00.000";
        public static const STOPWATCH_DEFAULT_TIME:int = 5999999;
		
		public static const GAME_STOPWATCH_FONT:String = "breeSerif";
		public static const GAME_STOPWATCH_FONT_SIZE:int = 20;
		public static const GAME_STOPWATCH_WIDTH:int = 100;
		public static const GAME_STOPWATCH_HEIGHT:int = 25;
		public static const GAME_STOPWATCH_TOP_PADDING:int = 10;
		public static const GAME_STOPWATCH_BOTTOM_PADDING:int = 5;
		public static const GAME_STOPWATCH_LEFT_PADDING:int = 5;

		public static const MENU_STOPWATCH_DEFAULT_TEXT:String = "Your Time: ";
		public static const MENU_STOPWATCH_HEIGHT:int = 30;
		public static const MENU_STOPWATCH_FONT_SIZE:int = 25;
		public static const MENU_STOPWATCH_TEXT_ALIGNMENT:String = "center";

        // GameState Values
        public static const PLAYER_RECORD_TIME_GAME_DEFAULT_TEXT:String = "Best Time: ";
        public static const PLAYER_RECORD_TIME_GAME_FONT_SIZE:int = 15;
        public static const PLAYER_RECORD_TIME_GAME_WIDTH:int = 150;
        public static const PLAYER_RECORD_TIME_GAME_TOP_PADDING:int = 5;
        public static const PLAYER_RECORD_TIME_GAME_LEFT_PADDING:int = 20;
        public static const PLAYER_RECORD_TIME_GAME_TEXT_ALIGNMENT:String = "left";

        public static const PLAYER_RECORD_TIME_END_LEVEL_DEFAULT_TEXT:String = "Best Time: ";
        public static const PLAYER_RECORD_TIME_END_LEVEL_NEW_RECORD_TEXT:String = "\nNEW RECORD!";
        public static const PLAYER_RECORD_TIME_END_LEVEL_FONT_SIZE:int = 25;
        public static const PLAYER_RECORD_TIME_END_LEVEL_TOP_PADDING:int = 40;
        public static const PLAYER_RECORD_TIME_END_LEVEL_TEXT_ALIGNMENT:String = "center";

		// Directions
		public static const RIGHT:int = 0;
		public static const LEFT:int = 1;
		public static const UP:int = 2;
		public static const DOWN:int = 3;
		
		// Platforms
		public static const PLATFORM_SPEED:int = 3;
		
		/**
		 *
		 * Tile Values
		 * 
		**/
		
		public static const EMPTY:int = 0;
		public static const WALL:int = 1;
		public static const LAVA:int = 2;
		public static const TRAMP:int = 3;
		public static const LADDER:int = 4;
		public static const CRATE:int = 5;
		
		public static const START:int = 10;
		public static const END:int = 11;
		
		// Gates (opens when button is down)
		public static const GATE1:int = 20;
		public static const GATE2:int = 21;
		public static const GATE3:int = 22;
		public static const GATE4:int = 23;
		public static const GATE5:int = 24;
		
		// Stay down buttons
		public static const BUTTON1:int = 30;
		public static const BUTTON2:int = 31;
		public static const BUTTON3:int = 32;
		public static const BUTTON4:int = 33;
		public static const BUTTON5:int = 34;	

		// popup buttons (buttons that pop up if you are not pressing them)
		public static const POPUP_BUTTON1:int = 35;
		public static const POPUP_BUTTON2:int = 36;
		public static const POPUP_BUTTON3:int = 37;
		public static const POPUP_BUTTON4:int = 38;
		public static const POPUP_BUTTON5:int = 39;
		
		// platforms
		public static const MOVING_PLATFORM_START1:int = 40;
		public static const MOVING_PLATFORM_START2:int = 41;
		public static const MOVING_PLATFORM_START3:int = 42;
		public static const MOVING_PLATFORM_START4:int = 43;
		public static const MOVING_PLATFORM_START5:int = 44;
		public static const LONG_MOVING_PLATFORM_START1:int = 45;
		public static const LONG_MOVING_PLATFORM_START2:int = 46;
		
		public static const MOVING_PLATFORM_END1:int = 47;
		public static const MOVING_PLATFORM_END2:int = 48;
		public static const MOVING_PLATFORM_END3:int = 49;
		public static const MOVING_PLATFORM_END4:int = 50;
		public static const MOVING_PLATFORM_END5:int = 51;
		public static const LONG_MOVING_PLATFORM_END1:int = 52;
		public static const LONG_MOVING_PLATFORM_END2:int = 53;
		
		// Signs
		public static const SIGN1:int = 54;
		public static const SIGN2:int = 55;
		public static const SIGN3:int = 56;
		public static const SIGN4:int = 57;
		public static const SIGN5:int = 58;

		// plastered Signs
		public static const PLASTERED_SIGN1:int = 71;
		public static const PLASTERED_SIGN2:int = 72;
		public static const PLASTERED_SIGN3:int = 73;
		public static const PLASTERED_SIGN4:int = 74;
		public static const PLASTERED_SIGN5:int = 75;
		
		// POWERUPS
		public static const TIMES2:int = 60;
		public static const PLUS1:int = 61;
		public static const PLUS2:int = 62;
		public static const PLUS3:int = 63;
		public static const PLUS4:int = 64;
		public static const PLUS5:int = 65;
		public static const PLUS6:int = 66;
		public static const PLUS7:int = 67;
		public static const PLUS8:int = 68;
		public static const PLUS9:int = 69;
		public static const PLUS10:int = 70;
		
		
		/**
		 * 
		 * ENERGY CONSTANTS
		 * 
		 */
		
		public static const NORMAL_JUMP_HEIGHT:int = 1;			// The height of a normal jump 
		
		
		//public static const JUMP_VELOCITIES:Array = new Array(0, -.3, -.375, -.45, -.5, -.56, -.61, -.66, -.7, -.74, -.78);		// Jump velocities
		public static const JUMP_VELOCITIES:Array = new Array(0, -.26, -.35, -.426, -.49, -.546, -.598, -.645, -.689, -.73, -.77);		// Jump velocities
																																// Index in the array indicates the power of the jump (number of blocks the jump with go up)
																																// units are blocks / update
		
		public static const INITIAL_FALL_VELOCITY:Number = .15	// The velocity given to an object when it starts falling
		public static const ENERGY_DOWNGRADE:int = 1;			// How much energy is lost every time you fall.
		public static const TERMINAL_VELOCITY:Number = .7;		// Maximum Velocity (game might break if exceeded)
		public static const GRAVITY:Number = .03;				// change in blocks / update ^2
		
		public static const PLAYER_SPEED:Number = 5.5;
		public static const CRATE_SPEED:Number = 2;
		public static const AIR_SPEED:Number = 5;
		public static const LADDER_UP_SPEED:Number = 8;
		public static const LADDER_DOWN_SPEED:Number = 5;
		
		public static const BASE_SIDE_LENGTH:Number = 46;		// The base pixels / block that will result in the above speeds.

        /**
         * Audio Values
         */
        public static const SFX_VOLUME:Number = 0.2;

		/*
		 * Menu Values
		 * 
		 */
		public static const GAME_TITLE:String = "Spring Pig";

        // Menu state
        public static const STATE_GAME:int = 0;
        public static const STATE_MAIN_MENU:int = 1;
        public static const STATE_CREDITS_MENU:int = 2;
        public static const STATE_LEVEL_SELECT_MENU:int = 3;
        public static const STATE_PAUSE_MENU:int = 4;
        public static const STATE_END_LEVEL_MENU:int = 5;
        public static const STATE_END_GAME_MENU:int = 6;
        public static const STATE_TIME_RECORDS_MENU:int = 7;

		// General menu
		public static const MENU_FONT:String = "breeSerif";
		public static const MENU_TITLE_ALIGNMENT:String = "center";

        public static const MENU_BACKGROUND_COVER_COLOR:uint = 0xFFFFFF;
        public static const MENU_BACKGROUND_COVER_OPACITY:Number = 0.5;
		
		// General menu button
		public static const MENU_BUTTON_COLOR:uint = 0xCCCCCC;
		public static const MENU_BUTTON_WIDTH:int = 130;
		public static const MENU_BUTTON_HEIGHT:int = 18;
		public static const MENU_BUTTON_FONT_SIZE:int = 12;
		public static const MENU_BUTTON_TEXT_TOP_PADDING:int = 1;
		public static const MENU_BUTTON_TEXT_ALIGNMENT:String = "center";
		public static const MENU_BUTTON_BORDER_SIZE:int = 2;
		public static const MENU_BUTTON_BORDER_COLOR:uint = 0x000000;
		public static const MENU_BUTTON_PADDING_BETWEEN:int = 40;
		
		// Mute button
		public static const MUTE_BUTTON_TEXT:String = "Mute: ";
		public static const MUTE_BUTTON_TOP_PADDING:int = 15;
		public static const MUTE_BUTTON_RIGHT_PADDING:int = 15;
		
		// Menus
		public static const CREDITS_BUTTON_TEXT:String = "[C]redits";
		public static const MAIN_MENU_BUTTON_TEXT:String = "[M]ain Menu";
		public static const MAIN_MENU_BUTTON_TOP_PADDING:int = 20;
		public static const MAIN_MENU_BUTTON_LEFT_PADDING:int = 20;

        public static const INSTRUCTIONS_MENU:String = "How to play:\nMove Left\t: Left Arrow\nMove Right\t: Right Arrow\nJump\t\t: Up Arrow\nSpring\t: Space\nRewind\t: R\nReset\t\t: Y\nPause\t\t: Escape";
        public static const INSTRUCTIONS_GAME:String = "Controls:\nLeft\t: Left Arrow\nRight\t: Right Arrow\nJump\t: Up Arrow\nSpring\t: Space\nRewind\t: R\nReset\t: Y\nPause\t: Escape";
        public static const INSTRUCTIONS_MENU_TOP_PADDING:int = 440;
        public static const INSTRUCTIONS_MENU_LEFT_PADDING:int = 30;
        public static const INSTRUCTIONS_GAME_BOTTOM_PADDING:int = 5;
        public static const INSTRUCTIONS_GAME_RIGHT_PADDING:int = 30;
        public static const INSTRUCTIONS_MENU_HEIGHT:int = 150;
        public static const INSTRUCTIONS_MENU_WIDTH:int = 500;
        public static const INSTRUCTIONS_GAME_HEIGHT:int = 100;
        public static const INSTRUCTIONS_GAME_WIDTH:int = 500;
        public static const INSTRUCTIONS_MENU_FONT_SIZE:int = 15;
        public static const INSTRUCTIONS_GAME_FONT_SIZE:int = 9;
        public static const INSTRUCTIONS_ALIGNMENT:String = "left";
		
		// Main menu
		public static const MAIN_TITLE_FONT_SIZE:int = 80;
		public static const MAIN_TITLE_TOP_PADDING:int = 50;

        public static const CONTINUE_BUTTON_TEXT:String = "[Space] Continue";
        public static const CONTINUE_BUTTON_COVER_COLOR:uint = 0xFFFFFF;
        public static const CONTINUE_BUTTON_COVER_OPACITY:Number = 0.5;

        public static const START_BUTTON_TEXT:String = "[S]tart";
        public static const LEVEL_SELECT_BUTTON_TEXT:String = "Select [L]evel";
        public static const TIME_RECORDS_BUTTON_TEXT:String = "[T]ime Records";

		public static const MAIN_CREDITS_BUTTON_RIGHT_PADDING:int = 30;
		public static const MAIN_CREDITS_BUTTON_BOTTOM_PADDING:int = 40;

        public static const MAIN_LOGO_TOP_PADDING:int = 0;
        public static const MAIN_LOGO_LEFT_PADDING:int = 0;
        public static const MAIN_LOGO_RATIO:Number = 0.95839753466872110939907550077042;
        public static const MAIN_LOGO_HEIGHT:int = 570;

        public static const MAIN_MENU_BUTTON_COLOR:uint = 0xCCCCCC;
        public static const MAIN_MENU_BUTTON_WIDTH:int = 198;
        public static const MAIN_MENU_BUTTON_HEIGHT:int = 68;
        public static const MAIN_MENU_BUTTON_TEXT_HEIGHT:int = 28;
        public static const MAIN_MENU_BUTTON_FONT_SIZE:int = 20;
        public static const MAIN_MENU_BUTTON_TEXT_TOP_PADDING:int = 3;
        public static const MAIN_MENU_BUTTON_TEXT_ALIGNMENT:String = "center";
        public static const MAIN_MENU_BUTTON_BORDER_SIZE:int = 2;
        public static const MAIN_MENU_BUTTON_BORDER_COLOR:uint = 0x000000;
        public static const MAIN_MENU_BUTTON_PADDING_BETWEEN:int = 20;

        public static const MAIN_MENU_MUTE_BUTTON_RIGHT_PADDING:int = 20;
        public static const MAIN_MENU_MUTE_BUTTON_BOTTOM_PADDING:int = 40;

		// Level select menu
		public static const LEVEL_SELECT_TITLE_TEXT:String = "Level Select";
		public static const LEVEL_SELECT_TITLE_TOP_PADDING:int = 50;
		public static const LEVEL_SELECT_TITLE_FONT_SIZE:int = 80;
		
		public static const LEVEL_SELECT_ROWS:int = 3;
		public static const LEVEL_SELECT_COLUMNS:int = 3;

        public static const LEVEL_SELECT_BUTTON_COLOR:uint = 0xCCCCCC;
        public static const LEVEL_SELECT_BUTTON_HEIGHT:int = 18;
        public static const LEVEL_SELECT_BUTTON_WIDTH:int = 158;
        public static const LEVEL_SELECT_BUTTON_BORDER_COLOR:uint = 0x000000;
        public static const LEVEL_SELECT_BUTTON_BORDER_SIZE:int = 2;

		public static const LEVEL_SELECT_PREVIOUS_PAGE_BUTTON_TEXT:String = "Previous Page";
		public static const LEVEL_SELECT_NEXT_PAGE_BUTTON_TEXT:String = "Next Page";
		public static const LEVEL_SELECT_PAGE_BUTTON_BOTTOM_PADDING:int = 50;
		
		public static const LEVEL_SELECT_PAGE_TOP_PADDING:int = 200;

        public static const LEVEL_SELECT_TIME_RECORD_TEXT:String = "Personal Best:\n";
        public static const LEVEL_SELECT_TIME_RECORD_TOP_PADDING:int = 3;
        public static const LEVEL_SELECT_TIME_RECORD_FONT_SIZE:int = 15;
        public static const LEVEL_SELECT_TIME_RECORD_HEIGHT:int = 45;
        public static const LEVEL_SELECT_TIME_RECORD_ALIGNMENT:String = "center";

        // Time records menu
        public static const TIME_RECORDS_TITLE_TEXT:String = "Your Best Times";
        public static const TIME_RECORDS_TITLE_TOP_PADDING:int = 50;
        public static const TIME_RECORDS_TITLE_FONT_SIZE:int = 80;

        public static const TIME_RECORDS_ROWS:int = 7;
        public static const TIME_RECORDS_COLUMNS:int = 2;

        public static const TIME_RECORDS_PREVIOUS_PAGE_BUTTON_TEXT:String = "Previous Page";
        public static const TIME_RECORDS_NEXT_PAGE_BUTTON_TEXT:String = "Next Page";
        public static const TIME_RECORDS_PAGE_BUTTON_BOTTOM_PADDING:int = 50;
        public static const TIME_RECORDS_PAGE_BUTTON_COLUMNS:int = 3;

        public static const TIME_RECORDS_PAGE_TOP_PADDING:int = 160;

        public static const TIME_RECORDS_TIME_RECORD_TEXT:String = ": ";
        public static const TIME_RECORDS_TIME_RECORD_HEIGHT:int = 25;
        public static const TIME_RECORDS_TIME_RECORD_WIDTH:int = 300;
        public static const TIME_RECORDS_TIME_RECORD_FONT_SIZE:int = 18;
        public static const TIME_RECORDS_TIME_RECORD_ALIGNMENT:String = "left";
		
		// Credits menu
		public static const CREDITS_TITLE_TEXT:String = "Credits";
		public static const CREDITS_TITLE_TOP_PADDING:int = 20;
		public static const CREDITS_TITLE_FONT_SIZE:int = 80;
		
		public static const CREDITS:String = "A game created for:\n" +
                "\tUW CSE Games Capstone - Spring 2015\n" +
                "By:\n" +
                "- Jack Fancher\n" +
                "- Marc-Antoine Fontenelle\n" +
                "- Panji Wisesa\n" +
                "\n" +
                "Music by:\n" +
                "- Lizzie Seigel\n" +
                "\n" +
                "Art by:\n" +
                "- Barbara Krug\n" +
                "\n" +
                "SFX from:\n" +
                "-http://www.freesfx.co.uk\n" +
                "-http://www.freesound.org\n" +
                "\n"+
                "Game font (Bree Serif) from:\n" +
                "-http://www.fontsquirrel.com/fonts/bree-serif\n" +
                " licensed under the SIL Open Font License, Version 1.1.\n" +
                " available at: http://scripts.sil.org/OFL"/* +
				"\n\n" + 
				"Presented by AlbinoBlackSheep"*/;
		public static const CREDITS_TOP_PADDING:int = 130;
		public static const CREDITS_HEIGHT:int = 500;
		public static const CREDITS_WIDTH:int = 400;
		public static const CREDITS_FONT_SIZE:int = 15;
		public static const CREDITS_ALIGNMENT:String = "left";

        public static const CREDITS_RESET_PROGRESS_BUTTON_TEXT:String = "Reset Progress";
        public static const CREDITS_RESET_PROGRESS_BUTTON_LEFT_PADDING:int = 30;
        public static const CREDITS_RESET_PROGRESS_BUTTON_BOTTOM_PADDING:int = 40;
        public static const CREDITS_RESET_PROGRESS_BUTTON_COVER_OPACITY:Number = 0.5;

		// Pause menu
		public static const PAUSE_TITLE_TEXT:String = "Paused";
		public static const PAUSE_TITLE_TOP_PADDING:int = 50;
		public static const PAUSE_TITLE_FONT_SIZE:int = 80;

        public static const PAUSE_LEVEL_INFO_TEXT:String = "Level #";
        public static const PAUSE_LEVEL_INFO_TOP_PADDING:int = 40;
        public static const PAUSE_LEVEL_INFO_HEIGHT:int = 25;
        public static const PAUSE_LEVEL_INFO_FONT_SIZE:int = 20;
        public static const PAUSE_LEVEL_INFO_ALIGNMENT:String = "center";
		
		public static const PAUSE_BACKGROUND_COLOR:uint = 0xFFFFFF;
		public static const PAUSE_BACKGROUND_OPACITY:Number = 0.5;
		
		public static const PAUSE_RESUME_BUTTON_TEXT:String = "R[e]sume";
        public static const PAUSE_RESTART_LEVEL_BUTTON_TEXT:String = "[Y] Restart Level";
		
		// End level menu
		public static const END_LEVEL_TITLE_TEXT:String = "Level Finished!";
		public static const END_LEVEL_TITLE_TOP_PADDING:int = 50;
		public static const END_LEVEL_TITLE_FONT_SIZE:int = 80;
		
		public static const END_LEVEL_STOPWATCH_TOP_PADDING:int = 430;
		public static const END_LEVEL_STOPWATCH_LEFT_PADDING:int = 0;

        public static const END_LEVEL_CREDITS_BUTTON_TOP_PADDING:int = 50;
		
		public static const END_LEVEL_NEXT_LEVEL_BUTTON_TEXT:String = "[Space] Next Level";
		public static const END_LEVEL_RESTART_LEVEL_BUTTON_TEXT:String = "[Y] Restart Last Level";
		public static const END_LEVEL_MAIN_MENU_BUTTON_TEXT:String = "[M]ain Menu";
		
		// End game menu
		public static const END_GAME_TITLE_TEXT:String = "Congratulations!";
		public static const END_GAME_TITLE_TOP_PADDING:int = 50;
		public static const END_GAME_TITLE_FONT_SIZE:int = 80;
		
		public static const END_GAME_STOPWATCH_TOP_PADDING:int = 430;
		public static const END_GAME_STOPWATCH_LEFT_PADDING:int = 0;
		
		public static const END_GAME_SUBTITLE_TEXT:String = "You have beaten Spring Pig";
		public static const END_GAME_SUBTITLE_TOP_PADDING:int = 300;
		public static const END_GAME_SUBTITLE_FONT_SIZE:int = 50;

        // Full playthrough tip
        public static const TOTAL_TIME_TIP_TEXT:String = "Tip: Play through the whole game with no continue and no restart to see playthrough time.";
        public static const TOTAL_TIME_TIP_BOTTOM_PADDING:int = 40;
        public static const TOTAL_TIME_TIP_HEIGHT:int = 25;
        public static const TOTAL_TIME_TIP_FONT_SIZE:int = 15;
        public static const TOTAL_TIME_TIP_ALIGNMENT:String = "center";

        // Full playthrough time
        public static const TOTAL_TIME_TEXT:String = "Total Playthrough Time: ";
        public static const TOTAL_TIME_BOTTOM_PADDING:int = 45;
        public static const TOTAL_TIME_HEIGHT:int = 30;
        public static const TOTAL_TIME_FONT_SIZE:int = 20;
        public static const TOTAL_TIME_ALIGNMENT:String = "center";

        // Best playthrough time
        public static const BEST_TOTAL_TIME_TEXT:String = "Best Playthrough Time:\n";
        public static const BEST_TOTAL_TIME_BOTTOM_PADDING:int = 45;
        public static const BEST_TOTAL_TIME_HEIGHT:int = 56;
        public static const BEST_TOTAL_TIME_WIDTH:int = 195;
        public static const BEST_TOTAL_TIME_FONT_SIZE:int = 18;
        public static const BEST_TOTAL_TIME_ALIGNMENT:String = "center";

        // Rewind tutorial
        public static const REWIND_INSTRUCTION_TEXT:String = "Rewind: R Reset: Y";
        public static const REWIND_INSTRUCTION_BOTTOM_PADDING:int = 5;
        public static const REWIND_INSTRUCTION_LEFT_PADDING:int = 5;
        public static const REWIND_INSTRUCTION_RIGHT_PADDING:int = 5;
        public static const REWIND_INSTRUCTION_HEIGHT:int = 25;
        public static const REWIND_INSTRUCTION_WIDTH:int = 210;
        public static const REWIND_INSTRUCTION_FONT_SIZE:int = 20;
        public static const REWIND_INSTRUCTION_ALIGNMENT:String = "left";
	}

}