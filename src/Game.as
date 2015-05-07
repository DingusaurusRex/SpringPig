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
	import model.player.Crate;
	import model.player.PhysicsObject;
	import model.player.Player;
	import util.IntPair;
	import util.Stopwatch;
	import view.BoardView;
	import view.MeterView;
	import flash.text.TextFieldAutoSize;
	import util.GameState;
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
			player.asset.height = (int) (board.tileSideLength * 3.0 / 4.0);
			player.asset.width = (int) (board.tileSideLength * 3.0 / 4.0);
			player.asset.x = playerStart.x;
			player.asset.y = playerStart.y + board.tileSideLength - player.asset.height;
			playerStart.y = player.asset.y;
			player.energy = 0;
			meter.energy = player.energy;
			
			this.playerStart = playerStart;
			
			Stopwatch.stopwatchText.x = meter.x;
			Stopwatch.stopwatchText.y = meter.y + meter.height + Constants.GAME_STOPWATCH_TOP_PADDING;
			
			// Add graphics			
			stage.addChild(boardSprite);
			stage.addChild(meter);
			stage.addChild(Stopwatch.stopwatchText);
			stage.addChild(player.asset);
			
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
			GameState.currentLevelSave();
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
				
				boardSprite.movePlatforms(player, board);
				platforms = boardSprite.platforms;
				
				popButtonsUp();
				displaySign();
				updateCrates();
				var wasInAir:Boolean = player.inAir;
				checkPlayerCollision(Constants.DOWN); // Sets player.inAir
				// Check if the player has started falling. If so, get his starting height in order to later calculate energy gained.
				if (player.inAir && !wasInAir) {
					player.startingHeight = getYPositionOfPlayer();
					player.velocity = Constants.INITIAL_FALL_VELOCITY;
				}
				
				// Process Keyboard controls
				if (keyUp && !player.inAir) {
					if (collidingWithLadder()) { // Go up the ladder
						player.asset.y -= player.upSpeedY;
						checkPlayerCollision(Constants.UP);
					} else { // Jump
						player.velocity = Constants.JUMP_VELOCITIES[1];
						player.inAir = true;
						player.startingHeight = getYPositionOfPlayer();
					}
				}
				if (keyDown && ladderBelowPlayer()) {
					player.asset.y += player.downSpeedY;
				}
				if (keyRight) {
					if (player.asset.x < board.boardWidthInPixels - player.asset.width - 5) {
						player.inAir ? player.asset.x += player.airSpeedX : player.asset.x += player.speedX;
						checkPlayerCollision(Constants.RIGHT);
					}						
				}
				if (keyLeft) {
					if (player.asset.x > 0) {
						player.inAir ? player.asset.x -= player.airSpeedX : player.asset.x -= player.speedX;
						checkPlayerCollision(Constants.LEFT);
					}
				}
				if (keySpace && !player.inAir && !ladderBelowPlayer()) {
					useEnergy();
				}
				if (keyR) {
					resetPlayer();
					resetCrates();
				}
				for each (var tile:IntPair in getPlayerTiles())
				{
					var id:int = board.getTile(tile.x, tile.y)
					if (isButton(id) && collidingWithButton(player, tile))
					{
						setButtonDown(board, id);
					}
				}
				if (player.inAir || collidingWithLadder()) {
					player.updatePosition(board.tileSideLength);
					
					if (player.asset.y <= 0) {
						player.startingHeight = getYPositionOfPlayer();
						player.asset.y = 0;
						player.velocity = Constants.INITIAL_FALL_VELOCITY;
					}
					
					checkPlayerCollision(Constants.UP);
					checkPlayerCollision(Constants.DOWN); // Sets player.inAir
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
		
		private function checkPlayerCollision(direction:int):void
		{
			switch(direction)
			{
				case Constants.RIGHT:
					// If colliding with a crate, move the crate
					if (collidingWithCrate(player))
					{
						var crate:Crate = getCollidingCrate(player);
						crate.asset.x += Constants.CRATEX;
						player.inAir ? player.asset.x -= player.airSpeedX - Constants.CRATEX : player.asset.x -= player.speedX - Constants.CRATEX;
						if (checkCrateCollision(crate, Constants.RIGHT))
						{
							crate.asset.x -= Constants.CRATEX;
							player.asset.x -= Constants.CRATEX;
						}
					}
					// If you ran into a wall, keep the player in the previous square
					for each (var tile:IntPair in getTilesInDirection(player, Constants.RIGHT))
					{
						var id:int = board.getTile(tile.x, tile.y);
						checkLavaHit(id);
						//if (isButton(id) && collidingWithButton(player, tile)) {
							//setButtonDown(board, id);
						//}
						if (id == Constants.WALL || isClosedGate(id))
						{
							player.asset.x = tile.x * board.tileSideLength - player.asset.width;
						}
					}
					break;
				case Constants.LEFT:
					// If colliding with a crate, move the crate
					if (collidingWithCrate(player))
					{
						crate = getCollidingCrate(player);
						crate.asset.x -= Constants.CRATEX;
						player.inAir ? player.asset.x += player.airSpeedX - Constants.CRATEX : player.asset.x += player.speedX - Constants.CRATEX;
						if (checkCrateCollision(crate, Constants.LEFT))
						{
							crate.asset.x += Constants.CRATEX;
							player.asset.x += Constants.CRATEX;
						}
					}
					// If you ran into a wall, keep the player in the previous square
					for each (tile in getTilesInDirection(player, Constants.LEFT))
					{
						id = board.getTile(tile.x, tile.y);
						checkLavaHit(id);
						//if (isButton(id) && collidingWithButton(player, tile)) {
							//setButtonDown(board, id);
						//}
						if (id == Constants.WALL || isClosedGate(id))
						{
							player.asset.x = (tile.x + 1) * board.tileSideLength;
						}
					}
					break;
				case Constants.UP:
					//Check that the user has not crashed into a wall above him
					for each (tile in getTilesInDirection(player, Constants.UP)) {
						id = board.getTile(tile.x, tile.y);
						if (tile.x * board.tileSideLength != player.asset.x + player.asset.width) {
							checkLavaHit(id);
							if (id == Constants.WALL || isClosedGate(id)) {
								player.startingHeight = getYPositionOfPlayer()
								player.asset.y = (tile.y + 1) * board.tileSideLength;
								player.velocity = Constants.INITIAL_FALL_VELOCITY;
							}
						}
					}
					collideWithPlatform(direction);
					break;
				case Constants.DOWN:
					player.inAir = true;
					if (collideWithPlatform(direction))
						break;
					else if (standingOnCrate(player))
					{
						crate = getCollidingCrate(player);
						player.asset.y = (int) (crate.asset.y - player.asset.height);
						player.velocity = 0;
						player.inAir = false;
					}
					for each (tile in getTilesInDirection(player, Constants.DOWN)) {
						id = board.getTile(tile.x, tile.y);
						if (tile.x * board.tileSideLength != player.asset.x + player.asset.width) {
							if (checkLavaHit(id)) {
								player.inAir = false;
								break;
							}
							//if (isButton(id) && collidingWithButton(player, tile)) {
								//setButtonDown(board, id);
							//}
							else if (id == Constants.LADDER) {
								// If at the top of the ladder, make sure player falls back to top of ladder and not slightly inside ladder
								var tileAboveLadder:int = board.getTile(tile.x, tile.y - 1);

								// Check that the player is close to the top of the ladder when they are climbing up
								// Only check if they are close to the top when they are climbing UP the ladder.
								// When player is falling, he should fall on top of ladder every time.
								// When a player is deliberately pressing down, they should not get y position reset
								var closeToTop:Boolean = Math.abs(player.asset.y + player.asset.height - (tile.y * board.tileSideLength)) <= player.downSpeedY;
								if (player.dy > 0)
									closeToTop = true;
								if ((tileAboveLadder == Constants.EMPTY || tileAboveLadder == Constants.START || tileAboveLadder == Constants.END)
									&& tileAboveLadder != -1 && closeToTop && !keyDown)
								{
									player.asset.y = (int) (tile.y * board.tileSideLength - player.asset.height);
								}
								player.inAir = false;
							}
							// If one of the tiles below player is not empty, then player is not falling
							else if (id != Constants.EMPTY &&
									 id != Constants.START &&
									 id != Constants.END &&
									 id != Constants.CRATE &&
									 !(id >= Constants.SIGN1 && id <= Constants.SIGN5) &&
									 !isButton(id) && 
									!isOpenGate(id) &&
									!isMovingPlatformStartOrEnd(id)) {
								player.asset.y = (int) (tile.y * board.tileSideLength - player.asset.height);
								player.velocity = 0;
								player.inAir = false;
							}
						}
					}
					
					if (isPlayerFinished()) {
						pause = true; // So that player position is disregarded
                        GameState.openNextLevelSave();
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
			for each (var tile:IntPair in getTilesInDirection(player, Constants.DOWN)) {
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
		
		public function updateCrates():void
		{
			for each (var crate:Crate in board.crates)
			{
				crate.updatePosition(board.tileSideLength);
				checkCrateCollision(crate, Constants.DOWN);
			}
		}
		
		public function checkCrateCollision(crate:Crate, direction:int):Boolean
		{
			switch (direction)
			{
				case Constants.RIGHT:
					// If colliding with a crate, move the crate
					if (crateAbove(crate) || crate.asset.x + crate.asset.width >= board.boardWidthInPixels)
					{
						return true;
					}
					// If you ran into a wall, keep the player in the previous square
					for each (var tile:IntPair in getTilesInDirection(crate, Constants.RIGHT))
					{
						var id:int = board.getTile(tile.x, tile.y);
						if (isButton(id) && collidingWithButton(crate, tile))
						{
							setButtonDown(board, id);
						}
						if (id == Constants.WALL ||
						    id == Constants.LADDER ||
							id == Constants.LAVA ||
							id == Constants.END ||
							id == Constants.TRAMP ||
							isClosedGate(id))
						{
							return true;
						}
					}
					break;
				case Constants.LEFT:
					// If colliding with a crate, move the crate
					if (crateAbove(crate) || crate.asset.x <= 0)
					{
						return true;
					}
					// If you ran into a wall, keep the player in the previous square
					for each (tile in getTilesInDirection(crate, Constants.LEFT))
					{
						id = board.getTile(tile.x, tile.y);
						if (isButton(id) && collidingWithButton(crate, tile))
						{
							setButtonDown(board, id);
						}
						if (id == Constants.WALL ||
						    id == Constants.LADDER ||
							id == Constants.LAVA ||
							id == Constants.END ||
							id == Constants.TRAMP ||
							isClosedGate(id))
						{
							return true;
						}
					}
					break;
				case Constants.DOWN:
					crate.inAir = true;
					//if (collideWithPlatform(direction))
						//break;
					for each (tile in getTilesInDirection(crate, Constants.DOWN)) {
						id = board.getTile(tile.x, tile.y);
						if (tile.x * board.tileSideLength != crate.asset.x + crate.asset.width) {
							if (isButton(id) && collidingWithButton(crate, tile)) {
								setButtonDown(board, id);
							}
							else if (collidingWithCrate(crate))
							{
								crate.asset.y = (int) (tile.y * board.tileSideLength - crate.asset.height);
								crate.velocity = 0;
								crate.inAir = false;
							}
							// If one of the tiles below player is not empty, then player is not falling
							else if (id != Constants.EMPTY &&
									 id != Constants.START &&
									 id != Constants.END &&
									 !isButton(id) && 
									!isOpenGate(id) &&
									!isMovingPlatformStartOrEnd(id)) {
								crate.asset.y = (int) (tile.y * board.tileSideLength - crate.asset.height);
								crate.velocity = 0;
								crate.inAir = false;
							}
						}
					}
					break;
				default:
					break;
			}
			return false;
		}
		
		/**
		 * Determines if the player is on any signs and displays thier text if so.
		 * Removes the displayed text if there is one and the player is not on a sign.
		**/
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
						var format:TextFormat = signText.getTextFormat()
						format.size = Constants.SIGN_FONT_SIZE;
						signText.setTextFormat(format);
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
				if (isPopupButton(id))
				{
					if (collidingWithButton(player, tile)) {
						popupButtonsTouched.push(id);
					}
					else
					{
						for each (var crate:Crate in board.crates)
						{
							if (collidingWithButton(crate, tile))
							{
								popupButtonsTouched.push(id);
								break;
							}
						}
					}
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
		private function collidingWithButton(obj:PhysicsObject, tile:IntPair):Boolean
		{
			var result:Boolean = false;
			var objLeft:Number = obj.asset.x + obj.asset.width * .25;
			var objRight:Number = obj.asset.x + obj.asset.width * .75;
			var objY:Number = obj.asset.y + obj.asset.height;
			var tileLeft:Number = tile.x * board.tileSideLength + board.tileSideLength * .15;
			var tileRight:Number = tile.x * board.tileSideLength + board.tileSideLength * .85;
			var tileTop:Number = tile.y * board.tileSideLength + board.tileSideLength * .85;
			var tileBottom:Number = tile.y * board.tileSideLength + board.tileSideLength;
			if (objLeft <= tileRight && objRight >= tileLeft && objY >= tileTop && objY <= tileBottom) {
				result = true;
			}
			return result;
		}
		
		/**
		 * Returns whether the given object is standing on a crate
		 * @param	obj
		 * @return
		 */
		private function standingOnCrate(obj:PhysicsObject):Boolean
		{
			var objLeft:Number = obj.asset.x + 1;
			var objRight:Number = obj.asset.x + obj.asset.width - 1;
			var objTop:Number = obj.asset.y;
			var objBottom:Number = obj.asset.y + obj.asset.height;
			
			for each (var crate:Crate in board.crates)
			{
				if (obj != crate)
				{
					var crateLeft:Number = crate.asset.x;
					var crateRight:Number = crate.asset.x + crate.asset.width;
					var crateTop:Number = crate.asset.y;
					var crateBottom:Number = crate.asset.y + crate.asset.height;
					if ((objLeft >= crateLeft && objLeft <= crateRight ||
						objRight >= crateLeft && objRight <= crateRight) &&
						(objTop >= crateTop && objTop <= crateBottom ||
						objBottom >= crateTop && objBottom <= crateBottom))
						{
							return true;
						}
				}
			}
			return false;
		}
		
		private function crateAbove(obj:PhysicsObject):Boolean
		{
			var objLeft:Number = obj.asset.x + 1;
			var objRight:Number = obj.asset.x + obj.asset.width - 1;
			var objTop:Number = obj.asset.y;
			var objBottom:Number = obj.asset.y + obj.asset.height - 1;
			
			for each (var crate:Crate in board.crates)
			{
				if (obj != crate)
				{
					var crateLeft:Number = crate.asset.x;
					var crateRight:Number = crate.asset.x + crate.asset.width;
					var crateTop:Number = crate.asset.y;
					var crateBottom:Number = crate.asset.y + crate.asset.height;
					if ((objLeft >= crateLeft && objLeft <= crateRight ||
						objRight >= crateLeft && objRight <= crateRight) &&
						(objTop >= crateTop && objTop <= crateBottom ||
						objBottom >= crateTop && objBottom <= crateBottom))
						{
							return true;
						}
				}
			}
			return false;
		}
		
		/**
		 * Returns whether the given object is colliding with a crate
		 * @param	obj
		 * @return
		 */
		private function collidingWithCrate(obj:PhysicsObject):Boolean
		{
			var objLeft:Number = obj.asset.x + 1;
			var objRight:Number = obj.asset.x + obj.asset.width - 1;
			var objTop:Number = obj.asset.y + 1;
			var objBottom:Number = obj.asset.y + obj.asset.height - 1;
			
			for each (var crate:Crate in board.crates)
			{
				if (obj != crate)
				{
					var crateLeft:Number = crate.asset.x;
					var crateRight:Number = crate.asset.x + crate.asset.width;
					var crateTop:Number = crate.asset.y;
					var crateBottom:Number = crate.asset.y + crate.asset.height;
					if ((objLeft >= crateLeft && objLeft <= crateRight ||
						objRight >= crateLeft && objRight <= crateRight) &&
						(objTop >= crateTop && objTop <= crateBottom ||
						objBottom >= crateTop && objBottom <= crateBottom))
						{
							return true;
						}
				}
			}
			return false;
		}
		
		/**
		 * Returns the crate that the object is colliding with
		 * returns null if not colliding with a crate
		 * @param	obj
		 * @return
		 */
		private function getCollidingCrate(obj:PhysicsObject):Crate
		{
			var objLeft:Number = obj.asset.x;
			var objRight:Number = obj.asset.x + obj.asset.width;
			var objTop:Number = obj.asset.y;
			var objBottom:Number = obj.asset.y + obj.asset.height;
			
			for each (var crate:Crate in board.crates)
			{
				if (obj != crate)
				{
					var crateLeft:Number = crate.asset.x;
					var crateRight:Number = crate.asset.x + crate.asset.width;
					var crateTop:Number = crate.asset.y;
					var crateBottom:Number = crate.asset.y + crate.asset.height;
					if ((objLeft >= crateLeft && objLeft <= crateRight ||
						objRight >= crateLeft && objRight <= crateRight) &&
						(objTop >= crateTop && objTop <= crateBottom ||
						objBottom >= crateTop && objBottom <= crateBottom))
						{
							return crate;
						}
				}
			}
			return null;
		}
		
		/**
		 * Collide with a platform, given a direction
		 * @param	direction
		 */
		private function collideWithPlatform(direction:int):void
		{
			player.onPlatform = false;
			if (isPlatformInPlayerTile()) { // Check that a platform is in a player's tile
				for each (var plat:Bitmap in platforms) {
					var topPlat:int = plat.y;
					var bottomPlat:int = plat.y + plat.height * .35;
					var rightPlat:int = plat.x + plat.width;
					var leftPlat:int = plat.x;
					var playerLeft:int = player.asset.x + player.asset.width * .25;
					var playerRight:int = player.asset.x + player.asset.width * .75;
					var playerTop:int = player.asset.y;
					var playerBottom:int = player.asset.y + player.asset.height;
					
					if (direction == Constants.UP)
					{
						if (player.asset.y <= bottomPlat && player.asset.y >= topPlat && 
							playerRight >= leftPlat && playerLeft <= rightPlat) {
							// bounce player off
							player.startingHeight = getYPositionOfPlayer()
							player.asset.y = plat.y + plat.height * .6;
							player.velocity = Constants.INITIAL_FALL_VELOCITY;
						}
					} 
					else if (direction == Constants.DOWN)
					{
						if (playerBottom >= topPlat && playerTop <= bottomPlat &&
							playerRight >= leftPlat && playerLeft <= rightPlat) {
							player.asset.y = topPlat - player.asset.height;
							player.inAir = false;
							player.onPlatform = true;
						}
					}
				}
			}
		}
		
		/**
		 * Returns whether the user is on top of ONLY a ladder (EMPTY is okay)
		 * @return
		 */
		private function ladderBelowPlayer():Boolean
		{
			var tiles:Vector.<IntPair> = getTilesInDirection(player, Constants.DOWN);
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
			var midX:int = player.asset.x + board.tileSideLength / 2;
			var midY:int = player.asset.y + board.tileSideLength / 2;
			return midX >= finishTile.x &&
			midX <= finishTile.x + board.tileSideLength &&
			midY >= finishTile.y &&
			midY <= finishTile.y + board.tileSideLength;
		}
		
		private function getYPositionOfPlayer():int
		{
			return (board.boardHeightInPixels - player.asset.y - player.asset.height ) / board.tileSideLength;
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
			switch (key)
			{
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
			var lowX:int = (int) (player.asset.x / board.tileSideLength);
			var highX:int = (int) ((player.asset.x + player.asset.width) / board.tileSideLength);
			var highY:int = (int) (player.asset.y / board.tileSideLength);
			var lowY:int = (int) ((player.asset.y + player.asset.height - 1) / board.tileSideLength);
			
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
		
		private function getTilesInDirection(obj:PhysicsObject, direction:int):Vector.<IntPair>
		{
			var result:Vector.<IntPair> = new Vector.<IntPair>();
			switch (direction)
			{
				case Constants.UP:
					result = getTilesAboveObject(obj);
					break;
				case Constants.DOWN:
					result = getTilesBelowObject(obj);
					break;
				case Constants.RIGHT:
					result = getTilesOnObjectRight(obj);
					break;
				case Constants.LEFT:
					result = getTilesOnObjectLeft(obj);
					break;
				default:
					break;
			}
			return result;
		}
		
		/**
		 * Gets the tile(s) below the player, in the form of IntPairs
		 * @return
		 */
		private function getTilesBelowObject(obj:PhysicsObject):Vector.<IntPair>
		{
			var lowX:int = (int) (obj.asset.x / board.tileSideLength);
			var highX:int = (int) ((obj.asset.x + obj.asset.width) / board.tileSideLength);
			var lowY:int = (int) ((obj.asset.y + obj.asset.height) / board.tileSideLength);
			
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
		private function getTilesAboveObject(obj:PhysicsObject):Vector.<IntPair>
		{
			var lowX:int = (int) (obj.asset.x / board.tileSideLength);
			var highX:int = (int) ((obj.asset.x + obj.asset.width) / board.tileSideLength);
			var highY:int = (int) (obj.asset.y / board.tileSideLength);
			
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
		private function getTilesOnObjectRight(obj:PhysicsObject):Vector.<IntPair>
		{
			var highX:int = (int) ((obj.asset.x + obj.asset.width) / board.tileSideLength);
			var lowY:int = (int) ((obj.asset.y + obj.asset.height - 1) / board.tileSideLength);
			var highY:int = (int) (obj.asset.y / board.tileSideLength);
		
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
		private function getTilesOnObjectLeft(obj:PhysicsObject):Vector.<IntPair>
		{
			var lowX:int = (int) (obj.asset.x / board.tileSideLength);
			var lowY:int = (int) ((obj.asset.y + obj.asset.height - 1) / board.tileSideLength);
			var highY:int = (int) (obj.asset.y / board.tileSideLength);
			
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
		
		private function isPlatformInPlayerTile():Boolean
		{
			for each (var tile:IntPair in getPlayerTiles())
			{
				for each (var platform:Bitmap in platforms) {					
					if ((platform.x >= tile.x * board.tileSideLength || platform.x <= (tile.x + 1) * board.tileSideLength) &&
						platform.y >= tile.y * board.tileSideLength && platform.y <= (tile.y + 1) * board.tileSideLength)
						return true;
				}
			}
			return false;
		}
		
		private function checkLavaHit(id:int):Boolean
		{
			if (id == Constants.LAVA) {
				resetPlayer();
				resetCrates();
			}
			return id == Constants.LAVA;
		}
		
		private function resetPlayer():void
		{
			player.asset.x = playerStart.x;
			player.asset.y = playerStart.y;
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
		
		private function resetCrates():void
		{
			for each (var crate:Crate in board.crates)
			{
				crate.reset();
			}
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