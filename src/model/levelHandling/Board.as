package model.levelHandling 
{
	/**
	 * The class containing access to the board, including width, height as well as model information on what tiles are where
	 * @author Jack
	 */
	public class Board 
	{
		private var m_width:int;
		private var m_height:int;
		private var m_board:Array;
		
		private var m_tileSideLength:int;			// The length of the side of a single tile (in pixels)
		private var m_boardWidthInPixels:int;		// The total width of the board portion of the screen (in pixels)
		private var m_boardHeightInPixels:int;	// The total height of the board portion of the screen (in pixels)
		
		public function Board(level:Object) 
		{
			m_width = level.width;
			m_height = level.height;
			m_board = level.board_array;
			
			var tileWidth:int = Constants.BOARD_WIDTH / m_width;
			var tileHeight:int = Constants.BOARD_HEIGHT / m_height;
			m_tileSideLength = Math.min(tileWidth, tileHeight);
			
			m_boardWidthInPixels = m_width * m_tileSideLength;
			m_boardHeightInPixels = m_height * m_tileSideLength;
		}
		
		public function getTile(x:int, y:int):int
		{
			var result:int;
			if (x >= m_width || y >= m_height)
			{
				result = -1;
			}
			var index:int = y * m_width + x;
			result = m_board[index];
			return result;
		}
		
		/**
		 * Return the width of the board (number of tiles horizontally)
		**/
		public function get width():int
		{
			return m_width;
		}
		
		/**
		 * Return the height of the board (number of tiles vertically)
		**/
		public function get height():int
		{
			return m_height;
		}
		
		/**
		 * Returns the number of pixels wide and tall a single tile is based on the provided width and height (in tiles) of the board
		 * 
		 * @param	width	- Number of tiles horizontally on the board
		 * @param	height	- Number of tiles vertically on the board
		 * @return	The largest number of pixels that a tile can be in order to fit all the tiles on the screen
		**/
		public function get tileSideLength():int
		{
			return m_tileSideLength
		}
		
		public function get boardWidthInPixels():int 
		{
			return m_boardWidthInPixels
		}
		
		public function get boardHeightInPixels():int 
		{
			return m_boardHeightInPixels
		}
		
		
	}
}