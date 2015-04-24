package levelHandling 
{
	/**
	 * The class containing access to the board, including width, height as well as model information on what tiles are where
	 * @author Jack
	 */
	public class Board 
	{
		private var m_width:int;
		private var m_height:int;
		private var m_board:Vector.<int>;
		
		public function Board(level:Object) 
		{
			m_width = level.width;
			m_height = level.height;
			m_board = level.board_array;
		}
		
		public function getTile(x:int, y:int)
		{
			var index:int = y * m_width + x;
			return m_board[index];
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
	}
}