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
		
		public static const GRID_THICKNESS:Number = 1;
		public static const GRID_COLOR:uint = 0x000000;
		public static const GRID_ALPHA:Number = 0.25;
		
		/**
		 * Screen Values
		**/
		
		public static const SCREEN_WIDTH:int = 800;
		public static const SCREEN_HEIGHT:int = 600;
		
		public static const SIDEBAR_WIDTH:int = 50;
		
		public static const BOARD_WIDTH:int = SCREEN_WIDTH - SIDEBAR_WIDTH;
		public static const BOARD_HEIGHT:int = SCREEN_HEIGHT;
		
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
		
		// How much energy is lost every time you fall.
		public static const ENERGY_DOWNGRADE:int = 1;
		public static const GRAVITY:int = 5;
	}

}