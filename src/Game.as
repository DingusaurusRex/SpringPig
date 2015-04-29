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
	import model.player.Player;
	import util.IntPair;
	import view.BoardView;
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
		
		private var count:int = 0;
		
		/**
		 * Begins the game
		 * @param	p - Player Object (added to stage in main)
		 */
		public function Game(stage:Stage, player:Player, board:Board, playerStart:IntPair) 
		{
			this.player = player;
			this.stage = stage;
			this.board = board;
			
			this.playerStart = playerStart;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Update loop to process keyboard commands
		 * @param	e
		 */
		private function update(e:Event = null):void
		{
			var wasInAir:Boolean = player.inAir;
			player.inAir = isPlayerInAir();
			// Check if the player has started falling. If so, get his starting height in order to later calculate energy gained.
			if (!player.inAir && wasInAir) {
				player.startingHeight = player.character.y / board.tileSideLength;
				//trace("starting: " + player.startingHeight);
			}
			// Check if the player has stopped falling. If so, calculate his energy gained.
			if (player.inAir && !wasInAir) {
				player.energy += (player.character.y / board.tileSideLength) - player.startingHeight - Constants.ENERGY_DOWNGRADE;
				//trace("energy: " + player.energy)
			}
			
			// Process Keyboard controls
			if (keyUp && !player.inAir) {
				if (player.character.y < board.boardHeightInPixels)
					player.character.y -= 1 * board.tileSideLength; // Jump one square
			}
			if (keyRight) {
				if (player.character.x < board.boardWidthInPixels) {
					player.inAir ? player.character.x += player.airSpeedX : player.character.x += player.speedX
					
					// If you ran into a wall, keep the player in the previous square
					for each (var tile:IntPair in getTilesOnPlayerRight()) {
						if (board.getTile(tile.x, tile.y) == Constants.WALL) {
							player.inAir ? player.character.x -= player.airSpeedX : player.character.x -= player.speedX;
							break;
						}
					}
				}
					
			}
			if (keyLeft) {
				if (player.character.x > 0)
					player.inAir ? player.character.x -= player.airSpeedX : player.character.x -= player.speedX;
					
					// If you ran into a wall, keep the player in the previous square
					for each (tile in getTilesOnPlayerLeft()) {
						if (board.getTile(tile.x, tile.y) == Constants.WALL) {
							player.inAir ? player.character.x += player.airSpeedX : player.character.x += player.speedX;
							break;
						}
					}
			}
			if (keySpace && !player.inAir) {
				// Do something
			}
			if (keyR) {
				player.character.x = playerStart.x;
				player.character.y = playerStart.y;
				player.energy = 0;
			}
			
			if (player.inAir) {
				// Fall down, or keep going up based on accel
				// NOTE:  This is actually just updatign the character based on their velocity
				// The velocity never changes, which is not what we want.  In reality, we want the velocity to be changing at a constant rate,
				// and the character's position changes based on what the velocity is at that moment.
				player.character.y += Constants.GRAVITY;
				
				player.inAir = isPlayerInAir();
			}
		}
		
		/**
		 * If player is in air, returns true.
		 * If player is not in air, returns false. Additionally, if player is inside a wall, moves player to border of wall.
		 * @return
		 */
		private function isPlayerInAir():Boolean
		{
			var inAir:Boolean = true;
			for each (var tile:IntPair in getTilesBelowPlayer()) {
				var id:int = board.getTile(tile.x, tile.y);
				// If one of the tiles below player is not empty, then player is not falling
				if (id != Constants.EMPTY && id != Constants.START && id != Constants.END) {
					player.character.y = (int) (tile.y * board.tileSideLength - player.character.height);
					inAir = false;
					break;
				}
			}
			return inAir;
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
			
			// Determines if any of the above values are the same (Whether the player is located inside a square or in between two or more squares)
			var oneX:Boolean = false;
			if (lowX == highX) {
				oneX = true;
			}
			
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			
			// Add the intPairs in which the player is located
			if (oneX) {
				result.push(new IntPair(lowX, lowY));
			} else {
				result.push(new IntPair(lowX, lowY));
				result.push(new IntPair(highX, lowY));
				//var id:int = board.getTile(highX, lowY);
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
		
			// Determines if any of the above values are the same (Whether the player is located inside a square or in between two or more squares)
			var oneY:Boolean = false;
			if (lowY == highY) {
				oneY = true;
			}
			
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			
			// Add the intPairs in which the player is located
			if (oneY) {
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
			
			// Determines if any of the above values are the same (Whether the player is located inside a square or in between two or more squares)
			var oneY:Boolean = false;
			if (lowY == highY) {
				oneY = true;
			}
			
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			
			// Add the intPairs in which the player is located
			if (oneY) {
				result.push(new IntPair(lowX, lowY));
			} else {
				result.push(new IntPair(lowX, lowY));
				result.push(new IntPair(lowX, highY));
			}		
			
			return result;
		}
	}

}