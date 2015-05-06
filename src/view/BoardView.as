package view 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import model.button.Button;
	import model.levelHandling.Board;
	import model.player.Crate;
	import model.player.Player;
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
		/**
		 * Embedded Assets
		**/
		
		[Embed(source = "../../assets/art/tiles/wall.png")]
		private var WallArt:Class;
		
		[Embed(source = "../../assets/art/tiles/lava.png")]
		private var LavaArt:Class;
		
		[Embed(source = "../../assets/art/tiles/end.png")]
		private var EndArt:Class;
		
		[Embed(source="../../assets/art/tiles/ladder.png")]
		private var LadderArt:Class;
		
		[Embed(source = "../../assets/art/tiles/trampoline.png")]
		private var TrampolineArt:Class;
		
		[Embed(source = "../../assets/art/tiles/gate.png")]
		private var ClosedGateArt:Class;
		
		[Embed(source = "../../assets/art/tiles/openGate.png")]
		private var OpenGateArt:Class;
		
		[Embed(source = "../../assets/art/tiles/buttonUP.png")]
		private var ButtonUpArt:Class;
		
		[Embed(source = "../../assets/art/tiles/buttonDown.png")]
		private var ButtonDownArt:Class;
		
		[Embed(source = "../../assets/art/tiles/platform.png")]
		private var PlatformArt:Class;
		
		[Embed(source = "../../assets/art/tiles/sign.png")]
		private var SignArt:Class;
		
		
		
		

		protected var m_boardViewWidth:int;		// The actual total width of the BoardView
		protected var m_boardViewHeight:int;	// The actual total height of the BoardView
		
		private var m_playerStart:IntPair;
		
		private var m_finishTile:IntPair;
		
		private var m_buttonArts:Dictionary;
		private var m_gateArts:Dictionary;
		
		private var m_platformArts:Dictionary; // Start ID -> bitmap
		private var m_platformStart:Dictionary; // Start ID -> intPair
		private var m_platformEnd:Dictionary; // End ID -> intPair
		private var m_platformDirs:Dictionary; // Start ID -> direction 
		private var m_platformStartToEnd:Dictionary; // Start IDs -> End IDs
		
		public function BoardView(board:Board) 
		{
			m_buttonArts = new Dictionary();
			m_gateArts = new Dictionary();
			for (var i:int = Constants.GATE1; i <= Constants.GATE5; i++) {
				m_gateArts[i] = new Vector.<Bitmap>();
			}
			
			m_platformArts = new Dictionary();
			m_platformStart = new Dictionary();
			m_platformEnd = new Dictionary();
			m_platformDirs = new Dictionary();
			initPlatformStartToEnd();
			
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
					else if (id == Constants.END)
						m_finishTile = new IntPair(x * tileSideLength, y * tileSideLength);
					else if (isMovingPlatformStart(id))
					{
						m_platformStart[id] = new IntPair(x, y);
					} 
					else if (isMovingPlatformEnd(id)) 
					{
						m_platformEnd[id] = new IntPair(x, y);
					}
					if (id == Constants.CRATE)
					{
						var crate:Crate = new Crate();
						crate.startingPos = new IntPair(x * tileSideLength, y * tileSideLength);
						board.crates.push(crate);
						var asset:Bitmap = crate.asset;
					}
					else
					{
						asset = getAssetBitmap(id);
					}
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
			addChild(grid);
			
			// Figure out platform directions
			setInitialPlatformDirections();
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
			if (id >= Constants.GATE1 && id <= Constants.GATE5) {
				result = new ClosedGateArt();
				m_gateArts[id].push(result);
			} 
			else if (id >= Constants.BUTTON1 && id <= Constants.POPUP_BUTTON5)
			{
				result = new ButtonUpArt();
				m_buttonArts[id] = result;
			}
			else if (id >= Constants.MOVING_PLATFORM_START1 && id <= Constants.MOVING_PLATFORM_START5)
			{
				result = new PlatformArt();
				m_platformArts[id] = result;
			}
			else if (id >= Constants.SIGN1 && id <= Constants.SIGN5)
			{
				result = new SignArt();
			}
			else {
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
					case Constants.LADDER:
						result = new LadderArt();
						break;
					case Constants.TRAMP:
						result = new TrampolineArt();
						break;
					default:
						result = null;
						break;
				}
			}
			
			return result;
		}
		
		public function get platforms():Vector.<Bitmap>
		{
			var plats:Vector.<Bitmap> = new Vector.<Bitmap>();
			for each (var plat:Bitmap in m_platformArts) {
				plats.push(plat);
			}
			return plats;
		}
		
		/**
		 * Returns the tile on which the player starts
		 * @return
		 */
		public function getPlayerStart():IntPair
		{
			return m_playerStart;
		}
		
		/**
		 * Returns the tile on which the player ends
		 * @return
		 */
		public function getFinishTile():IntPair
		{
			return m_finishTile;
		}
		
		/**
		 * Set the initial platform directions based on the start and end values
		 */
		private function setInitialPlatformDirections():void
		{
			for (var key:Object in m_platformStart) 
			{
				var platformId:int = int(key);
				var start:IntPair = m_platformStart[platformId];
				var endId:int = m_platformStartToEnd[platformId];
				var end:IntPair = m_platformEnd[endId];
				
				var dir:int;
				if (start.x > end.x) 
					dir = Constants.LEFT;
				else if (start.x < end.x) 
					dir = Constants.RIGHT;
				m_platformDirs[platformId] = dir;
			}
		}
		
		/**
		 * Move the platforms in the direction they are supposed to move in.
		 * Moves player if he is on a platform
		 * @param	id
		 */
		public function movePlatforms(player:Player, board:Board):void
		{
			for (var key:Object in m_platformArts) {
				var id:int = int(key);
				var platform:Bitmap = m_platformArts[id];
				var dir:int = m_platformDirs[id];
				var start:IntPair = m_platformStart[id];
				var endId:int = m_platformStartToEnd[id];
				var end:IntPair = m_platformEnd[endId];
				
				if (dir == Constants.RIGHT && platform.x < (end.x * board.tileSideLength)) 
				{
					platform.x += Constants.PLATFORM_SPEED;
					if (player.onPlatform) {
						player.asset.x += Constants.PLATFORM_SPEED;
					}
					if (platform.x >= (end.x * board.tileSideLength)) {
						m_platformDirs[id] = Constants.LEFT;
					}
				}
				else if (dir == Constants.LEFT && platform.x > (start.x * board.tileSideLength)) 
				{
					platform.x -= Constants.PLATFORM_SPEED;
					if (player.onPlatform) {
						player.asset.x -= Constants.PLATFORM_SPEED;
					}
					if (platform.x <= (start.x * board.tileSideLength)) {
						m_platformDirs[id] = Constants.RIGHT;
					}
				}
			}
		}
		
		/**
		 * Takes a button, and changes its art to be down
		 * @param	board
		 * @param	id - ID of the button (Constants #)
		 */
		public function setButtonDown(board:Board, id:int):void
		{
			var prevX:Number = m_buttonArts[id].x;
			var prevY:Number = m_buttonArts[id].y;
			
			removeChild(m_buttonArts[id]);
			m_buttonArts[id] = new ButtonDownArt();
			
			m_buttonArts[id].width = board.tileSideLength;
			m_buttonArts[id].height = board.tileSideLength;
			m_buttonArts[id].x = prevX;
			m_buttonArts[id].y = prevY;
			addChild(m_buttonArts[id]);
		}
		
		/**
		 * Takes a button and changes its art to be up
		 * @param	board
		 * @param	id - ID of the button (Constants #)
		 */
		public function setButtonUp(board:Board, id:int):void
		{
			var prevX:Number = m_buttonArts[id].x;
			var prevY:Number = m_buttonArts[id].y;
			
			removeChild(m_buttonArts[id]);
			m_buttonArts[id] = new ButtonUpArt();
			
			m_buttonArts[id].width = board.tileSideLength;
			m_buttonArts[id].height = board.tileSideLength;
			m_buttonArts[id].x = prevX;
			m_buttonArts[id].y = prevY;
			addChild(m_buttonArts[id]);
		}
		
		/**
		 * Sets gate with given id visible
		 * @param	board
		 * @param	id
		 */
		public function openGate(board:Board, id:int):void
		{
			replaceGate(board, id, OpenGateArt);
		}
		
		/**
		 * Sets gate with given id invisible
		 * @param	board
		 * @param	id
		 */
		public function closeGate(board:Board, id:int):void
		{
			replaceGate(board, id, ClosedGateArt);
		}
		
		private function replaceGate(board:Board, id:int, art:Class):void
		{
			var newGates:Vector.<Bitmap> = new Vector.<Bitmap>();
			for each (var gate:Bitmap in m_gateArts[id]) 
			{
				var prevX:Number = gate.x;
				var prevY:Number = gate.y;
				
				try {
					removeChild(gate);
				} 
				catch (error:Error) {
					trace(error);
				}
				var newGate:Bitmap = new art();
				
				newGate.width = board.tileSideLength;
				newGate.height = board.tileSideLength;
				newGate.x = prevX;
				newGate.y = prevY;
				newGates.push(newGate);		
				
				addChild(newGate);
			}
			
			m_gateArts[id] = newGates;
		}
		
		private function isMovingPlatformStart(id:int):Boolean
		{	
			return id >= Constants.MOVING_PLATFORM_START1 && id <= Constants.MOVING_PLATFORM_START5;
		}
		
		private function isMovingPlatformEnd(id:int):Boolean
		{
			return id >= Constants.MOVING_PLATFORM_END1 && id <= Constants.MOVING_PLATFORM_END5;
		}
		
		/**
		 * Describes relationship between the start and end platforms.
		 */
		private function initPlatformStartToEnd():void
		{
			m_platformStartToEnd = new Dictionary();
			
			// Normal buttons
			m_platformStartToEnd[Constants.MOVING_PLATFORM_START1] = Constants.MOVING_PLATFORM_END1;
			m_platformStartToEnd[Constants.MOVING_PLATFORM_START2] = Constants.MOVING_PLATFORM_END2;
			m_platformStartToEnd[Constants.MOVING_PLATFORM_START3] = Constants.MOVING_PLATFORM_END3;
			m_platformStartToEnd[Constants.MOVING_PLATFORM_START4] = Constants.MOVING_PLATFORM_END4;
			m_platformStartToEnd[Constants.MOVING_PLATFORM_START5] = Constants.MOVING_PLATFORM_END5;
		}
	}

}