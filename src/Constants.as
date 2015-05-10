package  
{
	/**
	 * ...
	 * @author Jack
	 */
	public class Constants 
	{
		public static const SHOW_JUMP_HEIGHT:Boolean = true;
		
		// A/B TESTING
		public static const JUMP_HEIGHT_ONE_HIGHER:Boolean = true;
		public static const HIGHLIGHT_PLAYER_SQUARE:Boolean = true;
		
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

		/**
		 * Colors
		**/
		
		public static const BACKGROUND_COLOR:uint = 0xcceaff;
		
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
		public static const SIGN_BORDER_COLOR:uint = 0x000000;
		public static const SIGN_BACKGROUND_COLOR:uint = 0xffffff;
		public static const SIGN_FONT_SIZE:int = 15;
		
		/**
		 * Screen Values
		**/
		
		public static const SCREEN_WIDTH:int = 800;
		public static const SCREEN_HEIGHT:int = 600;
		
		public static const SIDEBAR_WIDTH:int = 100;
		
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
		
		public static const GAME_STOPWATCH_FONT:String = "arial";
		public static const GAME_STOPWATCH_FONT_SIZE:int = 20;
		public static const GAME_STOPWATCH_TOP_PADDING:int = 10;
		
		public static const MENU_STOPWATCH_TEXT:String = "Your Time: ";
		public static const MENU_STOPWATCH_HEIGHT:int = 30;
		public static const MENU_STOPWATCH_FONT_SIZE:int = 25;
		public static const MENU_STOPWATCH_TEXT_ALIGNMENT:String = "center";
		
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
		
		public static const MOVING_PLATFORM_END1:int = 45;
		public static const MOVING_PLATFORM_END2:int = 46;
		public static const MOVING_PLATFORM_END3:int = 47;
		public static const MOVING_PLATFORM_END4:int = 48;
		public static const MOVING_PLATFORM_END5:int = 49;
		
		// Signs
		public static const SIGN1:int = 50;
		public static const SIGN2:int = 51;
		public static const SIGN3:int = 52;
		public static const SIGN4:int = 53;
		public static const SIGN5:int = 54;
		
		
		/**
		 * 
		 * ENERGY CONSTANTS
		 * 
		 */
		
		public static const NORMAL_JUMP_HEIGHT:int = 1;			// The height of a normal jump 
		
		public static const JUMP_VELOCITIES:Array = new Array(0, -.3, -.375, -.45, -.5, -.56, -.61, -.66, -.7, -.74, -.78);		// Jump velocities
																																// Index in the array indicates the power of the jump (number of blocks the jump with go up)
																																// units are blocks / update
		
		public static const INITIAL_FALL_VELOCITY:Number = .15	// The velocity given to an object when it starts falling
		public static const ENERGY_DOWNGRADE:int = 1;			// How much energy is lost every time you fall.
		public static const TERMINAL_VELOCITY:Number = .75;		// Maximum Velocity (game might break if exceeded)
		public static const GRAVITY:Number = .03;				// change in blocks / update ^2
		
		public static const PLAYER_SPEED:Number = 5;
		public static const CRATE_SPEED:Number = 2;
		public static const AIR_SPEED:Number = 5;
		public static const LADDER_UP_SPEED:Number = 8;
		public static const LADDER_DOWN_SPEED:Number = 5;
		
		public static const BASE_SIDE_LENGTH:Number = 46;		// The base pixels / block that will result in the above speeds.
		
		
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

		// General menu
		public static const MENU_FONT:String = "arial";
		public static const MENU_TITLE_ALIGNMENT:String = "center";
		
		// General menu button
		public static const MENU_BUTTON_COLOR:uint = 0xCCCCCC;
		public static const MENU_BUTTON_WIDTH:int = 118;
		public static const MENU_BUTTON_HEIGHT:int = 18;
		public static const MENU_BUTTON_FONT_SIZE:int = 12;
		public static const MENU_BUTTON_TEXT_ALIGNMENT:String = "center";
		public static const MENU_BUTTON_BORDER_SIZE:int = 2;
		public static const MENU_BUTTON_BORDER_COLOR:uint = 0x000000;
		public static const MENU_BUTTON_PADDING_BETWEEN:int = 40;
		
		// Mute button
		public static const MUTE_BUTTON_TEXT:String = "Mute: ";
		public static const MUTE_BUTTON_TOP_PADDING:int = 20;
		public static const MUTE_BUTTON_RIGHT_PADDING:int = 20;
		
		// Menus
		public static const CREDITS_BUTTON_TEXT:String = "[C]redits";
		public static const MAIN_MENU_BUTTON_TEXT:String = "[M]ain Menu";
		public static const MAIN_MENU_BUTTON_TOP_PADDING:int = 20;
		public static const MAIN_MENU_BUTTON_LEFT_PADDING:int = 20;
		
		// Main menu
		public static const MAIN_TITLE_FONT_SIZE:int = 80;
		public static const MAIN_TITLE_TOP_PADDING:int = 50;

        public static const CONTINUE_BUTTON_TEXT:String = "[Space] Continue";
        public static const CONTINUE_BUTTON_COVER_COLOR:uint = 0xFFFFFF;
        public static const CONTINUE_BUTTON_COVER_OPACITY:Number = 0.5;

        public static const START_BUTTON_TEXT:String = "[S]tart";
        public static const LEVEL_SELECT_BUTTON_TEXT:String = "Select [L]evel";
		
		public static const INSTRUCTIONS:String = "How to play:\nMove Left\t: Left Arrow\nMove Right\t: Right Arrow\nJump\t\t: Up Arrow\nSpring\t\t: Space\nReset\t\t: R\nPause\t\t: Escape";
		public static const INSTRUCTIONS_TOP_PADDING:int = 460;
		public static const INSTRUCTIONS_LEFT_PADDING:int = 30;
		public static const INSTRUCTIONS_HEIGHT:int = 500;
		public static const INSTRUCTIONS_WIDTH:int = 400;
		public static const INSTRUCTIONS_FONT_SIZE:int = 15;
		public static const INSTRUCTIONS_ALIGNMENT:String = "left";
		
		public static const MAIN_CREDITS_BUTTON_RIGHT_PADDING:int = 30;
		public static const MAIN_CREDITS_BUTTON_BOTTOM_PADDING:int = 40;
		
		// Level select menu
		public static const LEVEL_SELECT_TITLE_TEXT:String = "Level Select";
		public static const LEVEL_SELECT_TITLE_TOP_PADDING:int = 50;
		public static const LEVEL_SELECT_TITLE_FONT_SIZE:int = 80;
		
		public static const LEVEL_SELECT_ROWS:int = 3;
		public static const LEVEL_SELECT_COLUMNS:int = 3;
		
		public static const LEVEL_SELECT_PREVIOUS_PAGE_BUTTON_TEXT:String = "Previous Page";
		public static const LEVEL_SELECT_NEXT_PAGE_BUTTON_TEXT:String = "Next Page";
		public static const LEVEL_SELECT_PAGE_BUTTON_BOTTOM_PADDING:int = 50;
		
		public static const LEVEL_SELECT_PAGE_TOP_PADDING:int = 200;
		
		// Credits menu
		public static const CREDITS_TITLE_TEXT:String = "Credits";
		public static const CREDITS_TITLE_TOP_PADDING:int = 50;
		public static const CREDITS_TITLE_FONT_SIZE:int = 80;
		
		public static const CREDITS:String = "A game created for:\n\tUW CSE Games Capstone - Spring 2015\nBy:\n- Jack Fancher\n- Marc-Antoine Fontenelle\n- Panji Wisesa\n\nMusic By:\n- Lizzie Siegel";
		public static const CREDITS_TOP_PADDING:int = 250;
		public static const CREDITS_HEIGHT:int = 500;
		public static const CREDITS_WIDTH:int = 400;
		public static const CREDITS_FONT_SIZE:int = 20;
		public static const CREDITS_ALIGNMENT:String = "left";
		
		// Pause menu
		public static const PAUSE_TITLE_TEXT:String = "Paused";
		public static const PAUSE_TITLE_TOP_PADDING:int = 50;
		public static const PAUSE_TITLE_FONT_SIZE:int = 80;
		
		public static const PAUSE_BACKGROUND_COLOR:uint = 0x000000;
		public static const PAUSE_BACKGROUND_OPACITY:Number = 0.5;
		
		public static const PAUSE_RESUME_BUTTON_TEXT:String = "R[e]sume";
		
		// End level menu
		public static const END_LEVEL_TITLE_TEXT:String = "Level Finished!";
		public static const END_LEVEL_TITLE_TOP_PADDING:int = 50;
		public static const END_LEVEL_TITLE_FONT_SIZE:int = 80;
		
		public static const END_LEVEL_STOPWATCH_TOP_PADDING:int = 150;
		public static const END_LEVEL_STOPWATCH_LEFT_PADDING:int = 0;
		
		public static const END_LEVEL_NEXT_LEVEL_BUTTON_TEXT:String = "[Space] Next Level";
		public static const END_LEVEL_RESTART_LEVEL_BUTTON_TEXT:String = "[R]estart Last Level";
		public static const END_LEVEL_MAIN_MENU_BUTTON_TEXT:String = "[M]ain Menu";
		
		// End game menu
		public static const END_GAME_TITLE_TEXT:String = "Congratulations!";
		public static const END_GAME_TITLE_TOP_PADDING:int = 50;
		public static const END_GAME_TITLE_FONT_SIZE:int = 80;
		
		public static const END_GAME_STOPWATCH_TOP_PADDING:int = 220;
		public static const END_GAME_STOPWATCH_LEFT_PADDING:int = 0;
		
		public static const END_GAME_SUBTITLE_TEXT:String = "You have beaten Spring Pig";
		public static const END_GAME_SUBTITLE_TOP_PADDING:int = 150;
		public static const END_GAME_SUBTITLE_FONT_SIZE:int = 50;
	}

}