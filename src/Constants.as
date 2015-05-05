package  
{
	/**
	 * ...
	 * @author Jack
	 */
	public class Constants 
	{
	
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
		public static const GAME_STOPWATCH_FONT:String = "arial";
		public static const GAME_STOPWATCH_FONT_SIZE:int = 20;
		public static const GAME_STOPWATCH_TOP_PADDING:int = 10;
		
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
		public static const TERMINAL_VELOCITY:Number = 1;		// Maximum Velocity (game might break if exceeded)
		public static const GRAVITY:Number = .03;				// change in blocks / update ^2
		
		
		/*
		 * Menu Values
		 * 
		 */
		public static const GAME_TITLE:String = "Spring Pig";
		
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
		public static const START_BUTTON_TEXT:String = "Start";
		public static const LEVEL_SELECT_BUTTON_TEXT:String = "Select Level";
		public static const CREDITS_BUTTON_TEXT:String = "Credits";
		public static const MAIN_MENU_BUTTON_TEXT:String = "Main Menu";
		public static const MAIN_MENU_BUTTON_TOP_PADDING:int = 20;
		public static const MAIN_MENU_BUTTON_LEFT_PADDING:int = 20;
		
		// Main menu
		public static const MAIN_TITLE_FONT_SIZE:int = 80;
		public static const MAIN_TITLE_TOP_PADDING:int = 50;
		
		public static const INSTRUCTIONS:String = "How to play:\nMove Left\t: Left Arrow\nMove Right\t: Right Arrow\nJump\t\t: Up Arrow\nSpring\t\t: Space\nReset\t\t: R\nPause\t\t: Escape";
		public static const INSTRUCTIONS_TOP_PADDING:int = 460;
		public static const INSTRUCTIONS_LEFT_PADDING:int = 30;
		public static const INSTRUCTIONS_HEIGHT:int = 500;
		public static const INSTRUCTIONS_WIDTH:int = 400;
		public static const INSTRUCTIONS_FONT_SIZE:int = 15;
		
		public static const MAIN_CREDITS_BUTTON_RIGHT_PADDING:int = 30;
		public static const MAIN_CREDITS_BUTTON_BOTTOM_PADDING:int = 40;
		
		// Level select menu
		public static const LEVEL_SELECT_TITLE_TEXT:String = "Level Select";
		public static const LEVEL_SELECT_TITLE_TOP_PADDING:int = 50;
		public static const LEVEL_SELECT_TITLE_FONT_SIZE:int = 80;
		
		// Credits menu
		public static const CREDITS_TITLE_TEXT:String = "Credits";
		public static const CREDITS_TITLE_TOP_PADDING:int = 50;
		public static const CREDITS_TITLE_FONT_SIZE:int = 80;
		
		public static const CREDITS:String = "A game created for:\n\tUW CSE Games Capstone - Spring 2015\nBy:\n- Jack Fancher\n- Marc-Antoine Fontenelle\n- Panji Wisesa";
		public static const CREDITS_TOP_PADDING:int = 250;
		public static const CREDITS_HEIGHT:int = 500;
		public static const CREDITS_WIDTH:int = 400;
		public static const CREDITS_FONT_SIZE:int = 20;
		
		// Pause menu
		public static const PAUSE_TITLE_TEXT:String = "Paused";
		public static const PAUSE_TITLE_TOP_PADDING:int = 50;
		public static const PAUSE_TITLE_FONT_SIZE:int = 80;
		
		public static const PAUSE_BACKGROUND_COLOR:uint = 0x000000;
		public static const PAUSE_BACKGROUND_OPACITY:Number = 0.5;
		
		public static const PAUSE_RESUME_BUTTON_TEXT:String = "Resume";
		
		// End level menu
		public static const END_LEVEL_TITLE_TEXT:String = "Level Finished!";
		public static const END_LEVEL_TITLE_TOP_PADDING:int = 50;
		public static const END_LEVEL_TITLE_FONT_SIZE:int = 80;
		
		public static const END_LEVEL_NEXT_LEVEL_BUTTON_TEXT:String = "Next Level";
		public static const END_LEVEL_RESTART_LEVEL_BUTTON_TEXT:String = "Restart Last Level";
		public static const END_LEVEL_MAIN_MENU_BUTTON_TEXT:String = "Main Menu";
		
		// End game menu
		public static const END_GAME_TITLE_TEXT:String = "Congratulations!";
		public static const END_GAME_TITLE_TOP_PADDING:int = 50;
		public static const END_GAME_TITLE_FONT_SIZE:int = 80;
		
		public static const END_GAME_SUBTITLE_TEXT:String = "You have beaten Spring Pig";
		public static const END_GAME_SUBTITLE_TOP_PADDING:int = 150;
		public static const END_GAME_SUBTITLE_FONT_SIZE:int = 50;
		
		public static const END_GAME_CREDITS_BUTTON_TEXT:String = "Credits";
		public static const END_GAME_MAIN_MENU_BUTTON_TEXT:String = "Main Menu";
	}

}