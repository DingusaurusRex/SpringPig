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
		
		public function Board(level:Object) 
		{
			m_width = level.width;
			m_height = level.height;
			m_board = level.board_array;
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
		public function getTileDimensions():int
		{
			var tileWidth:int = Constants.BOARD_WIDTH / width;
			var tileHeight:int = Constants.BOARD_HEIGHT / height;
			return Math.min(tileWidth, tileHeight);
		}
		
		public function getBoardHeightInPixels():int 
		{
			var tileLength:int = getTileDimensions();
			return height * tileLength;
		}
		
		public function getBoardWidthInPixels():int 
		{
			var tileLength:int = getTileDimensions();
			return width * tileLength;
		}
	}
}