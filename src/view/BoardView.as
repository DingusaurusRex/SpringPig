package view 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import model.levelHandling.Board;
	import util.IntPair;
	/**
	 * A Sprite containing all the static tiles
	 * 
	 * Contains the graphics for things such as walls, lava, start and end
	 * Does not contain graphics for changing tiles such as crates, buttons, gates
	 * @author Jack
	 */
	public class BoardView extends Sprite
	{
		// Embedded Assets
		[Embed(source = "../../assets/art/tiles/wall.png")]
		private var WallArt:Class;
		
		[Embed(source = "../../assets/art/tiles/lava.png")]
		private var LavaArt:Class;
		
		[Embed(source = "../../assets/art/tiles/end.png")]
		private var EndArt:Class;
		
		protected var m_boardViewWidth:int;		// The actual total width of the BoardView
		protected var m_boardViewHeight:int;	// The actual total height of the BoardView
		
		private var m_playerStart:IntPair;
		
		public function BoardView(board:Board) 
		{
			draw(board);
		}
		
		private function draw(board:Board):void
		{
			// Determine the dimensions of a tile
			var tileSideLength:int = board.tileSideLength;
			
			
			m_boardViewWidth = board.width * tileSideLength;
			m_boardViewHeight = board.height * tileSideLength
			
			// Draw background
			graphics.beginFill(Constants.BACKGROUND_COLOR);
			graphics.drawRect(0, 0, m_boardViewWidth, m_boardViewHeight);
			graphics.endFill();
			
			// Draw Tiles
			for (var y:int = 0; y < board.height; y++)
			{
				for (var x:int = 0; x < board.width; x++)
				{
					var id:int = board.getTile(x, y);
					if (id == Constants.START)
						m_playerStart = new IntPair(x * tileSideLength, y * tileSideLength);
					var asset:Bitmap = getAssetBitmap(id);
					if (asset)
					{
						asset.width = tileSideLength;
						asset.height = tileSideLength;
						asset.x = x * tileSideLength;
						asset.y = y * tileSideLength;
						addChild(asset);
					}
				}
			}
			
			var grid:Sprite = new Sprite();
			grid.graphics.lineStyle(Constants.GRID_THICKNESS, Constants.GRID_COLOR, Constants.GRID_ALPHA);
			grid.graphics.beginFill(Constants.GRID_COLOR)
			
			// Draw Horizontal Gridlines
			for (var i:int = 0; i <= board.height; i++)
			{
				grid.graphics.moveTo(0, i * tileSideLength);
				grid.graphics.lineTo(m_boardViewWidth, i * tileSideLength);
			}
			
			// Draw Vertical Gridlines
			for (i = 0; i <= board.width; i++)
			{
				grid.graphics.moveTo(i * tileSideLength, 0);
				grid.graphics.lineTo(i * tileSideLength, m_boardViewHeight)
			}
			grid.graphics.endFill();
			addChild(grid)
		}
		
		/**
		 * Returns the tile asset identified by the id
		 * Returns Null if we shouldn't draw that asset or unknown asset
		 * 
		 * @param	id - the ID of the tile to return the asset of
		 * @return
		**/
		private function getAssetBitmap(id:int):Bitmap
		{
			var result:Bitmap = null;
			switch (id)
			{
				case Constants.WALL:
					result = new WallArt();
					break;
				case Constants.LAVA:
					result = new LavaArt();
					break;
				case Constants.END:
					result = new EndArt();
					break;
				default:
					result = null;
					break;
			}
			
			return result;
				
		}
		
		/**
		 * Returns the tile on which the player starts
		 * @return
		 */
		public function getPlayerStart():IntPair
		{
			return m_playerStart;
		}
	}

}