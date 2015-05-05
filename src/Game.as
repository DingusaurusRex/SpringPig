package 
{
	import flash.display.Bitmap;
	import flash.display.IDrawCommand;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display3D.textures.Texture;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenuClipboardItems;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import model.button.Button;
	import model.button.Gate;
	import model.levelHandling.Board;
	import model.levelHandling.LevelParser;
	import model.player.Player;
	import util.IntPair;
	import util.Stopwatch;
	import view.BoardView;
	import view.MeterView;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Marc
	 */
	public class Game 
	{
		// Keys
		private var keyUp:Boolean;
		private var keyDown:Boolean;
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
		private var boardSprite:BoardView;
		
		// Level Progression Variables
		public var progression:Array;
		public var currLevelIndex:int;
		
		// Gates and Buttons
		public var gates:Vector.<int>;
		public var gateStatus:Dictionary;
		public var buttons:Vector.<int>;
		public var popupButtons:Dictionary;
		public var buttonToGate:Dictionary; // Buttons map to the gate they open
				
		public var pause:Boolean;
		
		private var levelReader:LevelParser;
		
		// Platforms
		private var platforms:Vector.<Bitmap>;
		
		// Signs
		private var signText:TextField;
		
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
			
			
			this.levelReader = new LevelParser();
		}
		
		/**
		 * Starts the level with the given levelName
		 * levelName must match the name of a specific level
		 * @param	levelName
		 */
		public function startLevel(levelName:String):void
		{
			// Get the board for the test level
			board = levelReader.parseLevel(levelName);
			
			// Get the graphics for the test level
			if (boardSprite)
			{
				//stage.removeChild(boardSprite);
			}
			boardSprite = new BoardView(board);
			
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
			
			Stopwatch.stopwatchText.x = meter.x;
			Stopwatch.stopwatchText.y = meter.y + meter.height + Constants.GAME_STOPWATCH_TOP_PADDING;
			
			// Add graphics			
			stage.addChild(boardSprite);
			stage.addChild(meter);
			stage.addChild(Stopwatch.stopwatchText);
			stage.addChild(player.character);
			
			// Create Listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, update);
			
			stage.focus = stage; // Needed to refocus back to the game
			pause = false; // Reset pause
			this.finishTile = boardSprite.getFinishTile();
			
			// Buttons and Gates
			buttons = board.getButtons();
			popupButtons = board.getPopupButtons();
			gates = board.getGates();
			gateStatus = new Dictionary();
			for each (var id:int in gates) {
				gateStatus[id] = 0; // CLOSED
			}
			initButtonGateDict();
			
			// Reset and start timing
			Stopwatch.reset();
			Stopwatch.start();
		}
		
		/**
		 * Update loop to process keyboard commands
		 * @param	e
		 */
		private function update(e:Event = null):void
		{
			if (!pause) {
				// Update the stopwatch
				Stopwatch.updateStopwatchText();
				
				boardSprite.movePlatforms(board);
				platforms = boardSprite.platforms;
				
				popButtonsUp();
				displaySign();
				var wasInAir:Boolean = player.inAir;
				checkCollision(Constants.DOWN); // Sets player.inAir
				// Check if the player has started falling. If so, get his starting height in order to later calculate energy gained.
				if (player.inAir && !wasInAir) {
					player.startingHeight = getYPositionOfPlayer();
					player.velocity = Constants.INITIAL_FALL_VELOCITY;
				}
				
				// Process Keyboard controls
				if (keyUp && !player.inAir) {
					if (collidingWithLadder()) { // Go up the ladder
						player.character.y -= player.upSpeedY;
						checkCollision(Constants.UP);
					} else { // Jump
						player.velocity = Constants.JUMP_VELOCITIES[1];
						player.inAir = true;
						player.startingHeight = getYPositionOfPlayer();
					}
				}
				if (keyDown && ladderBelowPlayer()) {
					player.character.y += player.downSpeedY;
				}
				if (keyRight) {
					if (player.character.x < board.boardWidthInPixels) {
						player.inAir ? player.character.x += player.airSpeedX : player.character.x += player.speedX;
						checkCollision(Constants.RIGHT);
					}						
				}
				if (keyLeft) {
					if (player.character.x > 0) {
						player.inAir ? player.character.x -= player.airSpeedX : player.character.x -= player.speedX;
						checkCollision(Constants.LEFT);
					}
				}
				if (keySpace && !player.inAir && !ladderBelowPlayer()) {
					useEnergy();
				}
				if (keyR) {
					resetPlayer();
				}
				
				if (player.inAir || collidingWithLadder()) {
					player.updatePosition(board.tileSideLength);
					
					if (player.character.y <= 0) {
						player.startingHeight = getYPositionOfPlayer();
						player.character.y = 0;
						player.velocity = Constants.INITIAL_FALL_VELOCITY;
					}
					
					checkCollision(Constants.UP);
					checkCollision(Constants.DOWN); // Sets player.inAir
					if (!player.inAir) { // If player was in air and no longer is, add energy
						player.velocity = 0;
						if (!collidingWithLadder()) { // Dont add energy if you fall on ladder
							var energy:int = player.startingHeight - getYPositionOfPlayer() - Constants.ENERGY_DOWNGRADE;
							player.energy += Math.max(0, energy);
							if (player.energy > 10) 
								player.energy = 10;
							meter.energy = player.energy;
							
							if (trampBelowPlayer()) 
							{
								useEnergy();
								player.updatePosition(board.tileSideLength);
							}
						}
					}
				}
			}
		}
		
		private function checkCollision(direction:int):void
		{
			switch(direction)
			{
				case Constants.RIGHT:
					// If you ran into a wall, keep the player in the previous square
					for each (var tile:IntPair in getTilesOnPlayerRight())
					{
						var id:int = board.getTile(tile.x, tile.y);
						checkLavaHit(id);
						if (isButton(id) && collidingWithButton(tile)) {
							setButtonDown(board, id);
						}
						if (id == Constants.WALL || isClosedGate(id))
						{
							player.character.x = tile.x * board.tileSideLength - player.character.width;
						}
					}
					break;
				case Constants.LEFT:
					// If you ran into a wall, keep the player in the previous square
					for each (tile in getTilesOnPlayerLeft())
					{
						id = board.getTile(tile.x, tile.y);
						checkLavaHit(id);
						if (isButton(id) && collidingWithButton(tile)) {
							setButtonDown(board, id);
						}
						if (id == Constants.WALL || isClosedGate(id))
						{
							player.character.x = (tile.x + 1) * board.tileSideLength;
						}
					}
					break;
				case Constants.UP:
					//Check that the user has not crashed into a wall above him
					for each (tile in getTilesAbovePlayer()) {
						id = board.getTile(tile.x, tile.y);
						if (tile.x * board.tileSideLength != player.character.x + player.character.width) {
							checkLavaHit(id);
							if (id == Constants.WALL || isClosedGate(id)) {
								player.startingHeight = getYPositionOfPlayer()
								player.character.y = (tile.y + 1) * board.tileSideLength;
								player.velocity = Constants.INITIAL_FALL_VELOCITY;
							}
						}
					}
					collideWithPlatform(Constants.UP);
				case Constants.DOWN:
					player.inAir = true;
					for each (tile in getTilesBelowPlayer()) {
						id = board.getTile(tile.x, tile.y);
						if (tile.x * board.tileSideLength != player.character.x + player.character.width) {
							if (checkLavaHit(id)) {
								player.inAir = false;
								break;
							}
							if (isButton(id) && collidingWithButton(tile)) {
								setButtonDown(board, id);
							}
							else if (id == Constants.LADDER) {
								// If at the top of the ladder, make sure player falls back to top of ladder and not slightly inside ladder
								var tileAboveLadder:int = board.getTile(tile.x, tile.y - 1);

								// Check that the player is close to the top of the ladder when they are climbing up
								// Only check if they are close to the top when they are climbing UP the ladder.
								// When player is falling, he should fall on top of ladder every time.
								// When a player is deliberately pressing down, they should not get y position reset
								var closeToTop:Boolean = Math.abs(player.character.y + player.character.height - (tile.y * board.tileSideLength)) <= player.downSpeedY;
								if (player.dy > 0)
									closeToTop = true;
								if ((tileAboveLadder == Constants.EMPTY || tileAboveLadder == Constants.START || tileAboveLadder == Constants.END)
									&& tileAboveLadder != -1 && closeToTop && !keyDown)
								{
									player.character.y = (int) (tile.y * board.tileSideLength - player.character.height);
								}
								player.inAir = false;
							}
							// If one of the tiles below player is not empty, then player is not falling
							else if (id != Constants.EMPTY &&
									 id != Constants.START &&
									 id != Constants.END &&
									 !(id >= Constants.SIGN1 && id <= Constants.SIGN5) &&
									 !isButton(id) && 
									!isOpenGate(id) &&
									!isMovingPlatformStartOrEnd(id)) {
								player.character.y = (int) (tile.y * board.tileSideLength - player.character.height);
								
								player.inAir = false;
							}
						}
					}
					
					if (isPlayerFinished()) {
						pause = true; // So that player position is disregarded
						if (currLevelIndex == progression.length - 1) {
							Menu.createEndGameMenu();
						} else {
							Menu.createEndLevelMenu();
						}
					}
					break;
				default:
					break;
			}
		}
		
		public function startFirstLevel():void {
			startAtLevel(0);
		}
		
		public function restartLevel():void {
			startLevel(progression[currLevelIndex]);
		}
		
		public function startNextLevel():void {
			currLevelIndex++;
			if (currLevelIndex == progression.length) {
				currLevelIndex = 0;
			}
			startLevel(progression[currLevelIndex]);
		}
		
		public function startAtLevel(l:int):void {
			currLevelIndex = l;
			startLevel(progression[currLevelIndex]);
		}
		
		/**
		 * Uses up the player's energy, and makes him jump a value based on that energy.
		 */
		private function useEnergy(removeMeter:Boolean = true):void
		{
			player.velocity = Constants.JUMP_VELOCITIES[player.energy];
			player.inAir = true;
			player.startingHeight = getYPositionOfPlayer() + player.energy;
			player.energy = 0;
			if (removeMeter)
				meter.energy = player.energy;
		}
		
		private function collideWithPlatform(direction:int):void
		{
			for each (var plat:Bitmap in platforms) {
				if (direction == Constants.UP) {
					var topPlat:int = plat.y + plat.height * .35;
					var bottomPlat:int = plat.y + plat.height * .6;
					var rightPlat:int = plat.x + plat.width;
					var leftPlat:int = plat.x;
					trace("player.y: " + player.character.y);
					trace("topPlat: " + topPlat);
					trace("bottomPlat: " + bottomPlat);
					
					if (player.character.y <= bottomPlat && player.character.y >= topPlat && 
						player.character.x >= leftPlat && player.character.x <= rightPlat) {
						// bounce player off
						player.startingHeight = getYPositionOfPlayer()
						player.character.y = plat.y + plat.height * .6;
						player.velocity = Constants.INITIAL_FALL_VELOCITY;
					}
				}
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
		
		/**
		 * Returns true if players is standing on a trampoline
		 * @return
		 */
		private function trampBelowPlayer():Boolean
		{
			for each (var tile:IntPair in getTilesBelowPlayer()) {
				if (board.getTile(tile.x, tile.y) == Constants.TRAMP) 
					return true;
			}
			return false;
		}
		
		/**
		 * Sets the given button down, and if it is a popupButton, sets its value to 0 (DOWN)
		 * @param	board
		 * @param	id
		 */
		public function setButtonDown(board:Board, id:int):void
		{
			boardSprite.setButtonDown(board, id);
			if (isPopupButton(id)) {
				popupButtons[id] = 0;
			}
			
			var gateId:int = buttonToGate[id];
			if (gateStatus[gateId] == 0) 
			{
				boardSprite.openGate(board, gateId);
				gateStatus[gateId] = 1; // OPEN
			}
		}
		
		/**
		 * Sets the given button up, and if it is a popupButton, sets its value to 1 (UP)
		 * @param	board
		 * @param	id
		 */
		public function setButtonUp(board:Board, id:int):void
		{
			boardSprite.setButtonUp(board, id);
			if (isPopupButton(id)) {
				popupButtons[id] = 1;
			}
			
			var gateId:int = buttonToGate[id];
			if (gateStatus[gateId] == 1) 
			{
				boardSprite.closeGate(board, gateId);
				gateStatus[gateId] = 0; // CLOSED
			}
		}
		
		public function displaySign():void
		{
			var found:Boolean = false;
			for each (var tile:IntPair in getPlayerTiles()) {
				var id:int = board.getTile(tile.x, tile.y);
				if (id >= Constants.SIGN1 && id <= Constants.SIGN5)
				{
					found = true;
					if (!signText)
					{
						signText = new TextField();
						signText.text = board.getSignText(id);
						signText.x = tile.x * board.tileSideLength;
						signText.y = (tile.y - 1) * board.tileSideLength;
						signText.background = true;
						signText.backgroundColor = Constants.SIGN_BACKGROUND_COLOR;
						signText.border = true;
						signText.borderColor = Constants.SIGN_BORDER_COLOR;
						signText.wordWrap = true;
						signText.autoSize = TextFieldAutoSize.LEFT
						stage.addChild(signText);
					}
				}
			}
			if (!found && signText)
			{
				stage.removeChild(signText);
				signText = null;
			}
		}
		
		/**
		 * Pops up all the popup buttons that are not collided with by player
		 */
		public function popButtonsUp():void
		{
			var popupButtonsTouched:Vector.<int> = new Vector.<int>();
			for each (var tile:IntPair in getPlayerTiles()) {
				var id:int = board.getTile(tile.x, tile.y);
				if (isPopupButton(id) && collidingWithButton(tile)) {
					popupButtonsTouched.push(id);
				}
			}
			
			for (var key:String in popupButtons) {
				id = int(key);
				if (popupButtons[id] == 0 && popupButtonsTouched.indexOf(id) == -1) { // Buttons is DOWN and not being touched by player
					setButtonUp(board, id);
				}
			}
		}
		
		/**
		 * Returns true if the player is colliding with the button 
		 * (ignoring the white space around the button)
		 * @param	tile
		 * @return
		 */
		private function collidingWithButton(tile:IntPair):Boolean
		{
			var result:Boolean = false;
			var playerLeft:Number = player.character.x + player.character.width * .25;
			var playerRight:Number = player.character.x + player.character.width * .75;
			var playerY:Number = player.character.y + player.character.height;
			var tileLeft:Number = tile.x * board.tileSideLength + board.tileSideLength * .15;
			var tileRight:Number = tile.x * board.tileSideLength + board.tileSideLength * .85;
			var tileTop:Number = tile.y * board.tileSideLength + board.tileSideLength * .85;
			var tileBottom:Number = tile.y * board.tileSideLength + board.tileSideLength;
			if (playerLeft <= tileRight && playerRight >= tileLeft && playerY >= tileTop && playerY <= tileBottom) {
				result = true;
			}
			return result;
		}
		
		/**
		 * Returns whether the user is on top of ONLY a ladder (EMPTY is okay)
		 * @return
		 */
		private function ladderBelowPlayer():Boolean
		{
			var tiles:Vector.<IntPair> = getTilesBelowPlayer();
			var result:Boolean = false;
			for each (var tile:IntPair in tiles) {
				var id:int = board.getTile(tile.x, tile.y);
				if (id == Constants.LADDER) {
					result = true;
				} else if (id != Constants.EMPTY && id != Constants.START && id != Constants.END) {
					result = false;
					break;
				}
			}
			return result;
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
		private function onKeyDown(event:KeyboardEvent):void 
		{
			var key:uint = event.keyCode;
			switch (key) {
				case Keyboard.UP :
					keyUp = true;
					keySpace = false;
					keyDown = false;
					break;
				case Keyboard.DOWN:
					keyDown = true;
					keyUp = false;
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
					keyDown = false;
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
		private function onKeyUp(event:KeyboardEvent):void 
		{
			var key:uint = event.keyCode;
			switch (key) {
				case Keyboard.UP :
					keyUp = false;
					break;
				case Keyboard.DOWN :
					keyDown = false;
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
			// Reset the buttons
			for each (var id:int in buttons) {
				setButtonUp(board, id);
			}
			
			for each (id in gates) {
				boardSprite.closeGate(board, id);
				gateStatus[id] = 0; // CLOSED
			}
			
			Stopwatch.reset();
			Stopwatch.start();
		}
		
		private function isClosedGate(id:int):Boolean
		{
			return id >= Constants.GATE1 && id <= Constants.GATE5 && gateStatus[id] == 0;
		}
		
		private function isOpenGate(id:int):Boolean
		{
			return id >= Constants.GATE1 && id <= Constants.GATE5 && gateStatus[id] == 1;
		}
		
		private function isButton(id:int):Boolean
		{
			return id >= Constants.BUTTON1 && id <= Constants.POPUP_BUTTON5;
		}
		
		private function isPopupButton(id:int):Boolean
		{
			return id >= Constants.POPUP_BUTTON1 && id <= Constants.POPUP_BUTTON5;
		}
		
		private function isMovingPlatformStartOrEnd(id:int):Boolean
		{
			return id >= Constants.MOVING_PLATFORM_START1 && id <= Constants.MOVING_PLATFORM_END5;
		}
		
		/**
		 * Describes relationship between the buttons and which gate they open.
		 */
		private function initButtonGateDict():void
		{
			buttonToGate = new Dictionary();
			
			// Normal buttons
			buttonToGate[Constants.BUTTON1] = Constants.GATE1;
			buttonToGate[Constants.BUTTON2] = Constants.GATE2;
			buttonToGate[Constants.BUTTON3] = Constants.GATE3;
			buttonToGate[Constants.BUTTON4] = Constants.GATE4;
			buttonToGate[Constants.BUTTON5] = Constants.GATE5;
			
			// Popup buttons
			buttonToGate[Constants.POPUP_BUTTON1] = Constants.GATE1;
			buttonToGate[Constants.POPUP_BUTTON2] = Constants.GATE2;
			buttonToGate[Constants.POPUP_BUTTON3] = Constants.GATE3;
			buttonToGate[Constants.POPUP_BUTTON4] = Constants.GATE4;
			buttonToGate[Constants.POPUP_BUTTON5] = Constants.GATE5;
		}
	}

}