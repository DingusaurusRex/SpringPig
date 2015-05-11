package view 
{
	import adobe.utils.CustomActions;
	import cgs.fractionVisualization.fractionAnimators.grid.GridCompareSizeAnimator;
	import flash.display.Bitmap;
	import flash.display.InterpolationMethod;
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
		
		/**
		 * Powerups
		 */
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus1.png")]
		private var Plus1Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus2.png")]
		private var Plus2Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus3.png")]
		private var Plus3Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus4.png")]
		private var Plus4Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus5.png")]
		private var Plus5Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus6.png")]
		private var Plus6Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus7.png")]
		private var Plus7Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus8.png")]
		private var Plus8Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus9.png")]
		private var Plus9Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpPlus10.png")]
		private var Plus10Art:Class;
		
		[Embed(source = "../../assets/art/tiles/PowerUpTimes2.png")]
		private var Time2Art:Class;
		
		/**
		 * Button Assets
		**/
		
		[Embed(source = "../../assets/art/tiles/buttons/blue_down.png")]
		private var BlueDownArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/red_down.png")]
		private var RedDownArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/yellow_down.png")]
		private var YellowDownArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/green_down.png")]
		private var GreenDownArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/purple_down.png")]
		private var PurpleDownArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/blue_up.png")]
		private var BlueUpArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/red_up.png")]
		private var RedUpArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/yellow_up.png")]
		private var YellowUpArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/green_up.png")]
		private var GreenUpArt:Class
		
		[Embed(source = "../../assets/art/tiles/buttons/purple_up.png")]
		private var PurpleUpArt:Class
		
		/**
		 * Gate Assets
		**/
		
		[Embed(source = "../../assets/art/tiles/gates/blue_closed.png")]
		private var BlueClosedArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/blue_open.png")]
		private var BlueOpenArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/green_closed.png")]
		private var GreenClosedArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/green_open.png")]
		private var GreenOpenArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/purple_closed.png")]
		private var PurpleClosedArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/purple_open.png")]
		private var PurpleOpenArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/red_closed.png")]
		private var RedClosedArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/red_open.png")]
		private var RedOpenArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/yellow_closed.png")]
		private var YellowClosedArt:Class
		
		[Embed(source = "../../assets/art/tiles/gates/yellow_open.png")]
		private var YellowOpenArt:Class
		
		

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
		
		private var m_powerUps:Dictionary; // Tile intpair (x/y) -> powerup bitmap
		
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
			m_powerUps = new Dictionary();
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
					var tile:IntPair = new IntPair(x, y);
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
						asset = getAssetBitmap(id, tile);
					}
					if (asset)
					{
						if (id >= Constants.LONG_MOVING_PLATFORM_START1 && id <= Constants.LONG_MOVING_PLATFORM_START2) {
							asset.width = 2 * tileSideLength;
						} else {
							asset.width = tileSideLength;
						}
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
		private function getAssetBitmap(id:int, tile:IntPair):Bitmap
		{
			var result:Bitmap = null;
			if (id >= Constants.MOVING_PLATFORM_START1 && id <= Constants.LONG_MOVING_PLATFORM_START1)
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
					case Constants.GATE1:
						result = new RedClosedArt();
						m_gateArts[id].push(result);
						break;
					case Constants.GATE2:
						result = new BlueClosedArt();
						m_gateArts[id].push(result);
						break;
					case Constants.GATE3:
						result = new GreenClosedArt();
						m_gateArts[id].push(result);
						break;
					case Constants.GATE4:
						result = new PurpleClosedArt();
						m_gateArts[id].push(result);
						break;
					case Constants.GATE5:
						result = new YellowClosedArt();
						m_gateArts[id].push(result);
						break;
					case Constants.BUTTON1:
						result = new RedUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.BUTTON2:
						result = new BlueUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.BUTTON3:
						result = new GreenUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.BUTTON4:
						result = new PurpleUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.BUTTON5:
						result = new YellowUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.POPUP_BUTTON1:
						result = new RedUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.POPUP_BUTTON2:
						result = new BlueUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.POPUP_BUTTON3:
						result = new GreenUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.POPUP_BUTTON4:
						result = new PurpleUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.POPUP_BUTTON5:
						result = new YellowUpArt();
						m_buttonArts[id] = result;
						break;
					case Constants.TIMES2:
						result = new Time2Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS1:
						result = new Plus1Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS2:
						result = new Plus2Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS3:
						result = new Plus3Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS4:
						result = new Plus4Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS5:
						result = new Plus5Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS6:
						result = new Plus6Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS7:
						result = new Plus7Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS8:
						result = new Plus8Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS9:
						result = new Plus9Art();
						m_powerUps[tile] = result;
						break;
					case Constants.PLUS10:
						result = new Plus10Art();
						m_powerUps[tile] = result;
						break;
					default:
						result = null;
						break;
				}
			}
			return result;
		}
		
		/**
		 * Set given powerup invisible
		 * @param	tile
		 */
		public function setPowerupInvisible(tile:IntPair):void
		{
			var powerup:Bitmap = getPowerupBitmap(tile);
			if (powerup)
				powerup.visible = false;
		}
		
		/**
		 * Set given powerup visible
		 * @param	tile
		 */
		public function setPowerupVisible(tile:IntPair):void
		{
			var powerup:Bitmap = getPowerupBitmap(tile);
			if (powerup)
				powerup.visible = true;
		}
		
		/**
		 * Sets ALL powerups visible
		 */
		public function setPowerupsVisible():void
		{
			for each (var pu:Bitmap in m_powerUps) 
			{
				pu.visible = true;
			}
		}		
		
		/**
		 * Returns whether a powerup is visible
		 * @param	tile
		 * @return
		 */
		public function isPowerupVisible(tile:IntPair):Boolean 
		{
			var powerup:Bitmap = getPowerupBitmap(tile);
			if (powerup)
				return powerup.visible;
			else 
				return false;
		}
		
		private function getPowerupBitmap(tile:IntPair):Bitmap
		{
			for (var key:Object in m_powerUps) 
			{
				if ((key as IntPair).isEqualTo(tile)) {
					return (m_powerUps[key] as Bitmap);
				}
			}
			return null;
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
			switch(id)
			{
				case Constants.BUTTON1:
					m_buttonArts[id] = new RedDownArt();
					break;
				case Constants.BUTTON2:
					m_buttonArts[id] = new BlueDownArt();
					break;
				case Constants.BUTTON3:
					m_buttonArts[id] = new GreenDownArt();
					break;
				case Constants.BUTTON4:
					m_buttonArts[id] = new PurpleDownArt();
					break;
				case Constants.BUTTON5:
					m_buttonArts[id] = new YellowDownArt();
					break;
				case Constants.POPUP_BUTTON1:
					m_buttonArts[id] = new RedDownArt();
					break
				case Constants.POPUP_BUTTON2:
					m_buttonArts[id] = new BlueDownArt();
					break
				case Constants.POPUP_BUTTON3:
					m_buttonArts[id] = new GreenDownArt();
					break
				case Constants.POPUP_BUTTON4:
					m_buttonArts[id] = new PurpleDownArt();
					break
				case Constants.POPUP_BUTTON5:
					m_buttonArts[id] = new YellowDownArt();
					break
				default:
					m_buttonArts[id] = new ButtonDownArt();
					break;
			}
			
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
			switch(id)
			{
				case Constants.BUTTON1:
					m_buttonArts[id] = new RedUpArt();
					break;
				case Constants.BUTTON2:
					m_buttonArts[id] = new BlueUpArt();
					break;
				case Constants.BUTTON3:
					m_buttonArts[id] = new GreenUpArt();
					break;
				case Constants.BUTTON4:
					m_buttonArts[id] = new PurpleUpArt();
					break;
				case Constants.BUTTON5:
					m_buttonArts[id] = new YellowUpArt();
					break;
				case Constants.POPUP_BUTTON1:
					m_buttonArts[id] = new RedUpArt();
					break
				case Constants.POPUP_BUTTON2:
					m_buttonArts[id] = new BlueUpArt();
					break
				case Constants.POPUP_BUTTON3:
					m_buttonArts[id] = new GreenUpArt();
					break
				case Constants.POPUP_BUTTON4:
					m_buttonArts[id] = new PurpleUpArt();
					break
				case Constants.POPUP_BUTTON5:
					m_buttonArts[id] = new YellowUpArt();
					break
				default:
					m_buttonArts[id] = new ButtonUpArt();
					break;
			}
			
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
			switch(id)
			{
				case Constants.GATE1:
					var gateArt:Class = RedOpenArt;
					break;
				case Constants.GATE2:
					gateArt = BlueOpenArt;
					break;
				case Constants.GATE3:
					gateArt = GreenOpenArt;
					break;
				case Constants.GATE4:
					gateArt = PurpleOpenArt;
					break;
				case Constants.GATE5:
					gateArt = YellowOpenArt;
					break;
				default:
					gateArt = OpenGateArt;
					break;
			}
			replaceGate(board, id, gateArt);
		}
		
		/**
		 * Sets gate with given id invisible
		 * @param	board
		 * @param	id
		 */
		public function closeGate(board:Board, id:int):void
		{
			switch(id)
			{
				case Constants.GATE1:
					var gateArt:Class = RedClosedArt;
					break;
				case Constants.GATE2:
					gateArt = BlueClosedArt;
					break;
				case Constants.GATE3:
					gateArt = GreenClosedArt;
					break;
				case Constants.GATE4:
					gateArt = PurpleClosedArt;
					break;
				case Constants.GATE5:
					gateArt = YellowClosedArt;
					break;
				default:
					gateArt = ClosedGateArt;
					break;
			}
			replaceGate(board, id, gateArt);
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
			return id >= Constants.MOVING_PLATFORM_START1 && id <= Constants.LONG_MOVING_PLATFORM_START2;
		}
		
		private function isMovingPlatformEnd(id:int):Boolean
		{
			return id >= Constants.MOVING_PLATFORM_END1 && id <= Constants.LONG_MOVING_PLATFORM_END2;
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
			
			m_platformStartToEnd[Constants.LONG_MOVING_PLATFORM_START1] = Constants.LONG_MOVING_PLATFORM_END1;
			m_platformStartToEnd[Constants.LONG_MOVING_PLATFORM_START2] = Constants.LONG_MOVING_PLATFORM_END2;
		}
	}

}