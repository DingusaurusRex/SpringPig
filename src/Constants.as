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
		
		/**
		 *
		 * Tile Values
		 * 
		**/
		
		public static const EMPTY:int = 0;
		public static const WALL:int = 1;
		public static const LAVA:int = 2;
		
		public static const START:int = 10;
		public static const END:int = 11;
		
		/**
		 * 
		 * ENERGY CONSTANTS
		 * 
		 */
		// -.3
		public static const JUMP_VELOCITIES:Array = new Array(-.3, -.375, -.45, -.5, -.56, -.61, -.66, -.7, -.74, -.78);
		
		public static const INITIAL_FALL_VELOCITY = .15	// The velocity given to an object when it starts falling
		public static const ENERGY_DOWNGRADE:int = 1;	// How much energy is lost every time you fall.
		public static const TERMINAL_VELOCITY:int = 1;	// Maximum Velocity (game might break if exceeded)
		public static const GRAVITY:Number = .03;		// change in blocks / updates ^2
	}

}