package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.ContextMenuClipboardItems;
	import flash.ui.Keyboard;
	import model.levelHandling.Board;
	import model.levelHandling.LevelParser;
	import model.player.Player;
	import util.IntPair;
	import view.BoardView;
	import view.MeterView;
	/**
	 * ...
	 * @author Marc
	 */
	public class Game 
	{
		// Keys
		private var keyUp:Boolean;
		private var keyRight:Boolean;
		private var keyLeft:Boolean;
		private var keySpace:Boolean;
		private var keyR:Boolean;
		
		// Player
		private var player:Player;
		private var playerStart:IntPair;
		
		// Stage
		private var stage:Stage;
		private var board:Board;
		private var meter:MeterView;
		private var finishTile:IntPair;
		
		// Level Progression Variables
		private var progression:Array;
		public var currLevelIndex:int;
		
		private var count:int = 0;
		
		public var pause:Boolean;
		
		private static const RIGHT:int = 0;
		private static const LEFT:int = 1;
		private static const UP:int = 2;
		private static const DOWN:int = 3;
		
		/**
		 * Begins the game
		 * @param	p - Player Object (added to stage in main)
		 */
		public function Game(stage:Stage, progObj:Object) 
		{
			
			// Get the graphics for the meter
			meter = new MeterView();
			meter.x = Constants.METER_X;
			meter.y = Constants.METER_Y;
			
			// Create the Player
			player = new Player();
			
			this.stage = stage;
			this.progression = progObj.progression;
			currLevelIndex = 0;
			
			this.pause = false;		
		}
		
		public function getCurrentLevelName():String
		{
			return progression[currLevelIndex];
		}
		
		/**
		 * Starts the level with the given levelName
		 * levelName must match the name of a specific level
		 * @param	levelName
		 */
		public function startLevel(levelName:String):void
		{
			// Get the board for the test level
			var levelReader:LevelParser = new LevelParser();
			board = levelReader.parseLevel(levelName);
			
			// Get the graphics for the test level
			var boardSprite:BoardView = new BoardView(board);
			
			// Position the player
			var playerStart:IntPair = boardSprite.getPlayerStart(); // Top right of the square
			player.character.height = (int) (board.tileSideLength * 3.0 / 4.0);
			player.character.width = (int) (board.tileSideLength * 3.0 / 4.0);
			player.character.x = playerStart.x;
			player.character.y = playerStart.y + board.tileSideLength - player.character.height;
			playerStart.y = player.character.y;
			player.energy = 0;
			meter.energy = player.energy;
			
			this.playerStart = playerStart;
			
			// Add graphics
			stage.addChild(boardSprite);
			stage.addChild(meter);
			stage.addChild(player.character);
			
			// Create Listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, update);
			
			stage.focus = stage; // Needed to refocus back to the game
			pause = false; // Reset pause
			this.finishTile = boardSprite.getFinishTile();
		}
		
		/**
		 * Update loop to process keyboard commands
		 * @param	e
		 */
		private function update(e:Event = null):void
		{
			if (!pause) {
				var wasInAir:Boolean = player.inAir;
				checkCollision(DOWN); // Sets player.inAir
				// Check if the player has started falling. If so, get his starting height in order to later calculate energy gained.
				if (player.inAir && !wasInAir) {
					player.startingHeight = getYPositionOfPlayer();
					player.velocity = Constants.INITIAL_FALL_VELOCITY;
				}
				
				// Process Keyboard controls
				if (keyUp && !player.inAir) {
					player.velocity = Constants.JUMP_VELOCITIES[1];
					player.inAir = true;
					player.startingHeight = getYPositionOfPlayer();
				}
				if (keyRight) {
					if (player.character.x < board.boardWidthInPixels) {
						player.inAir ? player.character.x += player.airSpeedX : player.character.x += player.speedX;
						checkCollision(RIGHT);
					}						
				}
				if (keyLeft) {
					if (player.character.x > 0)
						player.inAir ? player.character.x -= player.airSpeedX : player.character.x -= player.speedX;
						checkCollision(LEFT);
				}
				if (keySpace && !player.inAir) {
					player.velocity = Constants.JUMP_VELOCITIES[player.energy];
					player.inAir = true;
					player.startingHeight = getYPositionOfPlayer() + player.energy;
					trace(player.energy);
					player.energy = 0;
					meter.energy = player.energy;
				}
				if (keyR) {
					resetPlayer();
				}
				
				if (player.inAir) {
					player.updatePosition(board.tileSideLength);
					
					if (player.character.y <= 0) {
						player.startingHeight = getYPositionOfPlayer();
						player.character.y = 0;
						player.velocity = Constants.INITIAL_FALL_VELOCITY;
					}
					
					checkCollision(UP);
					checkCollision(DOWN); // Sets player.inAir
					if (!player.inAir) {
						player.velocity = 0;
						if (!collidingWithLadder()) { // Dont add energy if you fall on ladder
							var energy:int = player.startingHeight - getYPositionOfPlayer() - Constants.ENERGY_DOWNGRADE;
							player.energy += Math.max(0, energy);
							if (player.energy > 10) 
								player.energy = 10;
							meter.energy = player.energy;
						}
					}
				}
			}
		}
		
		private function checkCollision(direction:int):void {
			switch(direction)
			{
				case RIGHT:
					// If you ran into a wall, keep the player in the previous square
					for each (var tile:IntPair in getTilesOnPlayerRight())
					{
						var id:int = board.getTile(tile.x, tile.y);
						checkLavaHit(id);
						if (id == Constants.WALL)
						{
							player.character.x = tile.x * board.tileSideLength - player.character.width;
						}
					}
					break;
				case LEFT:
					// If you ran into a wall, keep the player in the previous square
					for each (tile in getTilesOnPlayerLeft())
					{
						id = board.getTile(tile.x, tile.y);
						checkLavaHit(id);
						if (id == Constants.WALL)
						{
							player.character.x = (tile.x + 1) * board.tileSideLength;
						}
					}
					break;
				case UP:
					//Check that the user has not crashed into a wall above him
					for each (tile in getTilesAbovePlayer()) {
						id = board.getTile(tile.x, tile.y);
						if (tile.x * board.tileSideLength != player.character.x + player.character.width) {
							checkLavaHit(id);
							if (id == Constants.WALL) {
								player.startingHeight = getYPositionOfPlayer()
								player.character.y = (tile.y + 1) * board.tileSideLength;
								player.velocity = Constants.INITIAL_FALL_VELOCITY;
							}
						}
					}
				case DOWN:
					player.inAir = true;
					for each (tile in getTilesBelowPlayer()) {
						id = board.getTile(tile.x, tile.y);
						if (tile.x * board.tileSideLength != player.character.x + player.character.width) {
							if (checkLavaHit(id)) {
								player.inAir = false;
								break;
							}
							// If one of the tiles below player is not empty, then player is not falling
							if (id != Constants.EMPTY && id != Constants.START && id != Constants.END) {
								player.character.y = (int) (tile.y * board.tileSideLength - player.character.height);
								
								player.inAir = false;
							}
						}
					}
					
					if (isPlayerFinished()) {
						pause = true;
						Menu.createPauseMenu();
					}
					break;
				default:
					break;
			}
		}
		
		/**
		 * Returns whether the user is colliding with a ladder
		 * @return
		 */
		private function collidingWithLadder():Boolean
		{
			for each (var tile:IntPair in getPlayerTiles()) {
				if (board.getTile(tile.x, tile.y) == Constants.LADDER) 
					return true;
			}
			return false;
		}
		
		private function isPlayerFinished():Boolean
		{
			var midX:int = player.character.x + board.tileSideLength / 2;
			var midY:int = player.character.y + board.tileSideLength / 2;
			return midX >= finishTile.x &&
			midX <= finishTile.x + board.tileSideLength &&
			midY >= finishTile.y &&
			midY <= finishTile.y + board.tileSideLength;
		}
		
		private function getYPositionOfPlayer():int
		{
			return (board.boardHeightInPixels - player.character.y - player.character.height ) / board.tileSideLength;
		}
		
		/**
		 * Test if keys are pressed down
		 * @param	event
		 */
		private function onKeyDown(event:KeyboardEvent):void {
			var key:uint = event.keyCode;
			switch (key) {
				case Keyboard.UP :
					keyUp = true;
					keySpace = false;
					break;
				case Keyboard.RIGHT :
					keyRight = true;
					keyLeft = false;
					break;
				case Keyboard.LEFT :
					keyLeft = true;
					keyRight = false;
					break;
				case Keyboard.SPACE :
					keySpace = true;
					keyUp = false;
					break;
				case Keyboard.R :
					keyR = true;
					break;
				case Keyboard.ESCAPE :
					pause = !pause;
					if (pause) {
						Menu.createPauseMenu();
					} else {
						Menu.removePauseMenu();
					}
					break;
			}
		}
		
		/**
		 * Test if keys are up
		 * @param	event
		 */
		private function onKeyUp(event:KeyboardEvent):void {
			var key:uint = event.keyCode;
			switch (key) {
				case Keyboard.UP :
					keyUp = false;
					break;
				case Keyboard.RIGHT :
					keyRight = false;
					break;
				case Keyboard.LEFT :
					keyLeft = false;
					break;
				case Keyboard.SPACE :
					keySpace = false;
					break;
				case Keyboard.R :
					keyR = false;
					break;
			}
		}
		
		
		/**
		 * Returns the tile(s) in which the player is located in terms of intpairs
		 * @return
		 */
		private function getPlayerTiles():Vector.<IntPair>
		{
			var lowX:int = (int) (player.character.x / board.tileSideLength);
			var highX:int = (int) ((player.character.x + player.character.width) / board.tileSideLength);
			var highY:int = (int) (player.character.y / board.tileSideLength);
			var lowY:int = (int) ((player.character.y + player.character.height - 1) / board.tileSideLength);
			
			// Determines if any of the above values are the same (Whether the player is located inside a square or in between two or more squares)
			var oneX:Boolean = false; 
			var oneY:Boolean = false; 
			if (lowX == highX) {
				oneX = true;
			}
			if (lowY == highY) {
				oneY = true;
			}
			
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			
			// Add the intPairs in which the player is located
			if (oneX && oneY) {
				result.push(new IntPair(lowX, lowY));
			} else if (oneX) {
				result.push(new IntPair(lowX, lowY));
				result.push(new IntPair(lowX, highY));
			} else if (oneY) {
				result.push(new IntPair(lowX, lowY));
				result.push(new IntPair(highX, lowY));
			} else {
				result.push(new IntPair(lowX, lowY));
				result.push(new IntPair(highX, lowY));
				result.push(new IntPair(lowX, highY));
				result.push(new IntPair(highX, highY));				
			}			
			
			return result;
		}
		
		/**
		 * Gets the tile(s) below the player, in the form of IntPairs
		 * @return
		 */
		private function getTilesBelowPlayer():Vector.<IntPair>
		{
			var lowX:int = (int) (player.character.x / board.tileSideLength);
			var highX:int = (int) ((player.character.x + player.character.width) / board.tileSideLength);
			var lowY:int = (int) ((player.character.y + player.character.height) / board.tileSideLength);
			
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			
			// Add the intPairs in which the player is located
			if (lowX == highX) {
				result.push(new IntPair(lowX, lowY));
			} else {
				result.push(new IntPair(lowX, lowY));
				result.push(new IntPair(highX, lowY));
			}		
			
			return result;
		}
		
		/**
		 * Gets the tile(s) to the right of the player, in the form of IntPairs
		 * @return
		 */
		private function getTilesAbovePlayer():Vector.<IntPair>
		{
			var lowX:int = (int) (player.character.x / board.tileSideLength);
			var highX:int = (int) ((player.character.x + player.character.width) / board.tileSideLength);
			var highY:int = (int) (player.character.y / board.tileSideLength);
			
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			
			// Add the intPairs in which the player is located
			if (lowX == highX) {
				result.push(new IntPair(lowX, highY));
			} else {
				result.push(new IntPair(lowX, highY));
				result.push(new IntPair(highX, highY));
			}		
			
			return result;
		}
		
		/**
		 * Gets the tile(s) to the right of the player, in the form of IntPairs
		 * @return
		 */
		private function getTilesOnPlayerRight():Vector.<IntPair>
		{
			var highX:int = (int) ((player.character.x + player.character.width) / board.tileSideLength);
			var lowY:int = (int) ((player.character.y + player.character.height - 1) / board.tileSideLength);
			var highY:int = (int) (player.character.y / board.tileSideLength);
		
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			
			// Add the intPairs in which the player is located
			if (lowY == highY) {
				result.push(new IntPair(highX, lowY));
			} else {
				result.push(new IntPair(highX, lowY));
				result.push(new IntPair(highX, highY));
			}		
			
			return result;
		}
		
		/**
		 * Gets the tile(s) to the left of the player, in the form of IntPairs
		 * @return
		 */
		private function getTilesOnPlayerLeft():Vector.<IntPair>
		{
			var lowX:int = (int) (player.character.x / board.tileSideLength);
			var lowY:int = (int) ((player.character.y + player.character.height - 1) / board.tileSideLength);
			var highY:int = (int) (player.character.y / board.tileSideLength);
			
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			
			// Add the intPairs in which the player is located
			if (lowY == highY) {
				result.push(new IntPair(lowX, lowY));
			} else {
				result.push(new IntPair(lowX, lowY));
				result.push(new IntPair(lowX, highY));
			}		
			
			return result;
		}
		
		private function checkLavaHit(id:int):Boolean
		{
			if (id == Constants.LAVA) {
				resetPlayer();
			}
			return id == Constants.LAVA;
		}
		
		private function resetPlayer():void
		{
			player.character.x = playerStart.x;
			player.character.y = playerStart.y;
			player.energy = 0;
			player.velocity = 0;
			meter.energy = player.energy;
		}
	}

}