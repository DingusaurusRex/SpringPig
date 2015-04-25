package view 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import model.levelHandling.Board;
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
		var WallArt:Class;
		
		[Embed(source = "../../assets/art/tiles/lava.png")]
		var LavaArt:Class;
		
		[Embed(source = "../../assets/art/tiles/end.png")]
		var EndArt:Class;
		
		protected var m_boardViewWidth:int;		// The actual total width of the BoardView
		protected var m_boardViewHeight:int;	// The actual total height of the BoardView
		
		public function BoardView(board:Board) 
		{
			draw(board);
		}
		
		public function draw(board:Board):void
		{
			// Determine the dimensions of a tile
			var tileSideLength:int = getTileDimensions(board.width, board.height);
			
			
			m_boardViewWidth = board.width * tileSideLength;
			m_boardViewHeight = board.height * tileSideLength;
			
			// Draw Tiles
			for (var y:int = 0; y < board.height; y++)
			{
				for (var x:int = 0; x < board.width; x++)
				{
					var id:int = board.getTile(x, y);
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
		public function getAssetBitmap(id:int):Bitmap
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
		 * Returns the number of pixels wide and tall a single tile is based on the provided width and height (in tiles) of the board
		 * 
		 * @param	width	- Number of tiles horizontally on the board
		 * @param	height	- Number of tiles vertically on the board
		 * @return	The largest number of pixels that a tile can be in order to fit all the tiles on the screen
		**/
		public function getTileDimensions(width:int, height:int):int
		{
			var tileWidth:int = Constants.BOARD_WIDTH / width;
			var tileHeight:int = Constants.BOARD_HEIGHT / height;
			return Math.min(tileWidth, tileHeight);
		}
	}

}