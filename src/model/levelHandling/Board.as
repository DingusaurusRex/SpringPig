package model.levelHandling 
{
	import flash.utils.Dictionary;
	import model.button.Button;
	import model.button.Gate;
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
			if (x >= m_width || y >= m_height || x < 0 || y < 0)
			{
				return -1;				
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
		
		/**
		 * Returns all the gates' ids
		 * @return
		 */
		public function getGates():Vector.<int>
		{
			var gates:Vector.<int> = new Vector.<int>();
			for (var y:int = 0; y < height; y++)
			{
				for (var x:int = 0; x < width; x++)
				{
					var id:int = getTile(x, y);
					if (id >= Constants.GATE1 && id <= Constants.GATE5) {
						gates.push(id);
					}
				}
			}
			return gates;
			
		}
		
		/**
		 * Returns all the buttons' ids
		 * @return
		 */
		public function getButtons():Vector.<int>
		{
			var buttons:Vector.<int> = new Vector.<int>();
			for (var y:int = 0; y < height; y++)
			{
				for (var x:int = 0; x < width; x++)
				{
					var id:int = getTile(x, y);
					if (id >= Constants.BUTTON1 && id <= Constants.POPUP_BUTTON5) {
						buttons.push(id);
					}
				}
			}
			return buttons;
		}
		
		/**
		 * Returns a dictionary of popup buttons to their state (Up (1) or Down (0))
		 * @return
		 */
		public function getPopupButtons():Dictionary
		{
			var buttons:Dictionary = new Dictionary();
			for (var y:int = 0; y < height; y++)
			{
				for (var x:int = 0; x < width; x++)
				{
					var id:int = getTile(x, y);
					if (id >= Constants.POPUP_BUTTON1 && id <= Constants.POPUP_BUTTON5) {
						buttons[id] = 1;
					}
				}
			}
			return buttons;
		}
	}
}