package 
{
	import cgs.Audio.Audio;

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

import mx.utils.ObjectUtil;

import util.Audio;
	import util.IntPair;
import util.PlayState;
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
		private var m_keyUp:Boolean;
		private var m_keyDown:Boolean;
		private var m_keyRight:Boolean;
		private var m_keyLeft:Boolean;
		private var m_keySpace:Boolean;
		private var m_keyR:Boolean;

		// Player
		private var m_player:Player;
		private var m_playerStart:IntPair;
		
		// Stage
		private var m_stage:Stage;
		private var m_board:Board;
		private var m_meter:MeterView;
		private var m_finishTile:IntPair;
		private var m_boardSprite:BoardView;
		
		
		private var m_jumpHeightRects:Vector.<Sprite>;
		private var m_prevPlayerX:int;
		
		// Level Progression Variables
		public var progression:Array;
		public var currLevelIndex:int;
		
		// Gates and Buttons
		public var gates:Vector.<int>;
		public var gateStatus:Object;
		public var buttons:Vector.<int>;
        public var buttonStatus:Object;
		public var popupButtons:Dictionary;
		public var buttonToGate:Dictionary; // Buttons map to the gate they open
				
		public var pause:Boolean;
		
		private var m_levelReader:LevelParser;
		
		// Platforms
		private var platforms:Vector.<Sprite>;
		
		// Signs
		private var m_signText:TextField;

        // Logger
        private var m_logger:Logger;

        private var ps:PlayState;
		
		/**
		 * Begins the game
		 * @param	p - Player Object (added to stage in main)
		 */
		public function Game(stage:Stage, progObj:Object, logger:Logger)
		{
			
			// Get the graphics for the meter
			m_meter = new MeterView();
			m_meter.x = Constants.METER_X;
			m_meter.y = Constants.METER_Y;
			
			this.m_stage = stage;
			this.progression = progObj.progression;
			currLevelIndex = 0;
			
			this.pause = false;

			
			this.m_levelReader = new LevelParser();

            this.m_logger = logger;
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
				
				if (m_player.bounce) {
					useEnergy();
					m_player.updatePosition(m_board.tileSideLength);
					m_player.bounce = false;
				}
				
				var playerDir:int = m_boardSprite.movePlatforms(m_player, m_board);
				checkPlayerCollision(playerDir);
				platforms = m_boardSprite.platforms;
				
				updateButtons();
				displaySign();
				updateCrates();
				var wasInAir:Boolean = m_player.inAir;
				checkPlayerCollision(Constants.DOWN); // Sets player.inAir
				// Check if the player has started falling. If so, get his starting height in order to later calculate energy gained.
				if (m_player.inAir && !wasInAir) {
					m_player.startingHeight = getYPositionOfPlayer();
					m_player.velocity = Constants.INITIAL_FALL_VELOCITY;
				}
				
				// Process Keyboard controls
				if (m_keyUp && !m_player.inAir) {
					if (collidingWithLadder()) { // Go up the ladder
						m_player.asset.y -= m_player.upSpeedY;
						checkPlayerCollision(Constants.UP);
					} else { // Jump
                        util.Audio.playJumpSFX();
						m_player.velocity = Constants.JUMP_VELOCITIES[1];
						m_player.inAir = true;
						m_player.startingHeight = getYPositionOfPlayer();
					}
				}
				if (m_keyDown && ladderBelowPlayer()) {
					m_player.asset.y += m_player.downSpeedY;
				}
				if (m_keyRight) {
					if (m_player.asset.x < m_board.boardWidthInPixels - m_player.width - 5) {
						m_player.inAir ? m_player.asset.x += m_player.airSpeedX : m_player.asset.x += m_player.speedX;
						checkPlayerCollision(Constants.RIGHT);
					}						
				}
				if (m_keyLeft) {
					if (m_player.asset.x > 0) {
						m_player.inAir ? m_player.asset.x -= m_player.airSpeedX : m_player.asset.x -= m_player.speedX;
						checkPlayerCollision(Constants.LEFT);
					}
				}
				if (m_keySpace && !m_player.inAir) {
					// Check that player is on top of ladder
					if (ladderBelowPlayer && isPlayerAtTopOfLadder() || !ladderBelowPlayer()) {
						useEnergy();
					}
				}
				if (m_keyR) {
                    var logData:Object = {x:m_player.asset.x, y:m_player.asset.y};
                    m_logger.logAction(Constants.AID_RESET, logData);
                    util.Audio.playResetSFX();
					resetPlayer();
					resetCrates();
				}
				if (m_player.inAir || collidingWithLadder()) {
					m_player.updatePosition(m_board.tileSideLength);
					
					if (m_player.asset.y <= 0) {
						m_player.startingHeight = getYPositionOfPlayer();
						m_player.asset.y = 0;
						m_player.velocity = Constants.INITIAL_FALL_VELOCITY;
					}
					
					var hitLava:Boolean = checkPlayerCollision(Constants.UP);
					var hitLava2:Boolean = checkPlayerCollision(Constants.DOWN); // Sets player.inAir
					if (!m_player.inAir && !hitLava && !hitLava2) { // If player was in air and no longer is, add energy
						m_player.velocity = 0;
						if (!collidingWithLadder()) { // Dont add energy if you fall on ladder
							var energy:int = m_player.startingHeight - getYPositionOfPlayer() - Constants.ENERGY_DOWNGRADE;
							incrementEnergy(energy);
							
							if (trampBelowPlayer()) 
							{
								m_player.bounce = true;
								
								// Allows for buttons on top of trampolines.
								var id:int = playerOnButton();
								if (id != -1) {
									setButtonDown(m_board, id);
								}
							}
						}
						else
						{
							m_player.startingHeight = getYPositionOfPlayer();
						}
					}
				}
				for each (var crate:Crate in m_board.crates)
				{
					//if (!crate.wasBeingPushed && crate.beingPushed)
					//{
						//trace("push");
					//}
					//else if (crate.wasBeingPushed && !crate.beingPushed)
					//{
						//trace("not push");
						//var crateTile:IntPair = getCentralTile(crate);
						//crate.asset.x = crateTile.x * m_board.tileSideLength;
					//}
					if (crate.inAir && !standingOnCrate(crate))
					{
						var crateTile:IntPair = getCentralTile(crate);
						crate.asset.x = crateTile.x * m_board.tileSideLength;
					}
				}
				
				if (Constants.SHOW_JUMP_HEIGHT) {
					if (!m_player.inAir) 
					{
						showJumpHeight();
					} else {
						removePlayerJumpHeight();
					}
				}
			}
		}
		
		/**
		 * 
		 *	Level Management
		 * 
		**/
		
		/**
		 * Starts the level with the given levelName
		 * levelName must match the name of a specific level
		 * @param	levelName
		 */
		public function startLevel(levelName:String):void
		{
			// Get the board for the test level
			m_board = m_levelReader.parseLevel(levelName);
			
			// Get the graphics for the test level
			if (m_boardSprite)
			{
				//stage.removeChild(boardSprite);
			}
			m_boardSprite = new BoardView(m_board);
			
			// Create the Player
			m_player = new Player(m_board.tileSideLength);
			
			// Position the player
			var playerStart:IntPair = m_boardSprite.getPlayerStart(); // Top right of the square
			m_player.height = (int) (m_board.tileSideLength * 3.0 / 4.0);
			m_player.width = (int) (m_board.tileSideLength * 3.0 / 4.0);
			m_player.asset.x = playerStart.x;
			m_player.asset.y = playerStart.y + m_board.tileSideLength - m_player.height;
			playerStart.y = m_player.asset.y;
			m_player.energy = 0;
			m_meter.energy = m_player.energy;
			m_jumpHeightRects = new Vector.<Sprite>();
			
			this.m_playerStart = playerStart;
			
			Stopwatch.stopwatchText.x = m_meter.x;
			Stopwatch.stopwatchText.y = m_meter.y + m_meter.height + Constants.GAME_STOPWATCH_TOP_PADDING;

            var previousRecord:TextField = GameState.getPlayerRecordGameTextField(currLevelIndex);
            previousRecord.x = Stopwatch.stopwatchText.x;
            previousRecord.y = Stopwatch.stopwatchText.y + Constants.PLAYER_RECORD_TIME_GAME_TOP_PADDING;

            Menu.gameInstructions.x = previousRecord.x;

			// Add graphics			
			m_stage.addChild(m_boardSprite);
			m_stage.addChild(m_meter);
			m_stage.addChild(Stopwatch.stopwatchText);
            m_stage.addChild(previousRecord);
            m_stage.addChild(Menu.gameInstructions);
			m_stage.addChild(m_player.asset);
			
			// Create Listeners
			m_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			m_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			m_stage.addEventListener(Event.ENTER_FRAME, update);
			
			m_stage.focus = m_stage; // Needed to refocus back to the game
			pause = false; // Reset pause
			this.m_finishTile = m_boardSprite.getFinishTile();
			
			// Buttons and Gates
			buttons = m_board.getButtons();
            buttonStatus = new Object();
            for each (var id:int in buttons) {
                buttonStatus[id] = 1; // UP
            }
			popupButtons = m_board.getPopupButtons();
			gates = m_board.getGates();
			gateStatus = new Dictionary();
			for each (id in gates) {
				gateStatus[id] = 0; // CLOSED
			}
			initButtonGateDict();

            m_logger.logLevelStart(currLevelIndex + 1, null);

            Menu.setPauseMenuLevelInfo(currLevelIndex + 1, getCurrentLevelName())
			GameState.currentLevelSave();
			// Reset and start timing
			Stopwatch.reset();
			Stopwatch.start();
		}

        public function getCurrentLevelName():String
        {
            return progression[currLevelIndex];
        }
		
		public function startFirstLevel():void
		{
			startAtLevel(0);
		}
		
		public function restartLevel():void
		{
			startLevel(progression[currLevelIndex]);
		}
		
		public function startNextLevel():void
		{
			currLevelIndex++;
			if (currLevelIndex == progression.length)
			{
				currLevelIndex = 0;
			}
			startLevel(progression[currLevelIndex]);
		}
		
		public function startAtLevel(l:int):void
		{
			currLevelIndex = l;
			startLevel(progression[currLevelIndex]);
		}
		
		/**
		 * 
		 *	Player Functions
		 * 
		**/
		
		/**
		 * Checks collision with the player in a given direction
		 * Returns true if player collided with lava
		 * @param	direction
		 */
		private function checkPlayerCollision(direction:int):Boolean
		{
			switch(direction)
			{
				case Constants.RIGHT: 
					// If colliding with a crate, move the crate
					if (collidingWithCrate(m_player))
					{
						var crates:Vector.<Crate> = getCollidingCrates(m_player)
						var playerTile:IntPair = getCentralTile(m_player);
						for each (var temp:Crate in crates)
						{
							var crateTile:IntPair = getCentralTile(temp);
							if (crateTile.x >= playerTile.x && crateTile.y == playerTile.y)
							{
								var crate:Crate = temp;
								break;
							}
						}
						if (crate)
						{
							crate.beingPushed = true;
							crate.oldX = crate.asset.x;
							var oldPlayerX:Number = m_player.asset.x;
							crate.asset.x += m_player.cratePushSpeed;
							m_player.asset.x = crate.asset.x - m_player.width;
							if (checkCrateCollision(crate, Constants.RIGHT) || (crate.inAir && !standingOnCrate(crate)))
							{
								//crate.asset.x = oldCrateX;
								m_player.inAir ? m_player.asset.x = m_player.asset.x - m_player.airSpeedX : m_player.asset.x = m_player.asset.x - m_player.speedX;
							}
						}
					}
					// If you ran into a wall, keep the playeoh fur in the previous square
					for each (var tile:IntPair in getTilesInDirection(m_player, Constants.RIGHT))
					{
						var id:int = m_board.getTile(tile.x, tile.y);
						if (isPowerUp(id) && m_boardSprite.isPowerupVisible(tile) && 
							m_player.asset.x + m_player.width != tile.x * m_board.tileSideLength)  // Check that the player does not collide by a simple pixel
						{
							handlePowerUp(id, tile);
						}
						if (checkLavaHit(id, tile))
							return true;
						//if (isButton(id) && collidingWithButton(player, tile)) {
							//setButtonDown(board, id);
						//}
						if (id == Constants.WALL || isClosedGate(id) || id == Constants.TRAMP)
						{
							m_player.asset.x = tile.x * m_board.tileSideLength - m_player.width;
						}
					}
					break;
				case Constants.LEFT:
					// If colliding with a crate, move the crate
					if (collidingWithCrate(m_player))
					{
						crates = getCollidingCrates(m_player)
						playerTile = getCentralTile(m_player);
						for each (temp in crates)
						{
							crateTile = getCentralTile(temp);
							if (crateTile.x <= playerTile.x && crateTile.y == playerTile.y)
							{
								crate = temp;
								break;
							}
						}
						if (crate)
						{
							crate.beingPushed = true;
							crate.oldX = crate.asset.x;
							oldPlayerX = m_player.asset.x;
							crate.asset.x -= m_player.cratePushSpeed;
							m_player.asset.x = crate.asset.x + crate.width;
							if (checkCrateCollision(crate, Constants.LEFT) || (crate.inAir && !standingOnCrate(crate)))
							{
								//crate.asset.x = oldCrateX;
								m_player.inAir ? m_player.asset.x = m_player.asset.x + m_player.airSpeedX : m_player.asset.x = m_player.asset.x + m_player.speedX;
							}
						}
					}
					// If you ran into a wall, keep the player in the previous square
					for each (tile in getTilesInDirection(m_player, Constants.LEFT))
					{
						id = m_board.getTile(tile.x, tile.y);
						if (checkLavaHit(id, tile))
							return true;
						if (isPowerUp(id) && m_boardSprite.isPowerupVisible(tile) &&
							m_player.asset.x != (tile.x + 1) * m_board.tileSideLength)  // Check that the player does not collide by a simple pixel) 
						{
							handlePowerUp(id, tile);
						}
						//if (isButton(id) && collidingWithButton(player, tile)) {
							//setButtonDown(board, id);
						//}
						if (id == Constants.WALL || isClosedGate(id) || id == Constants.TRAMP)
						{
							m_player.asset.x = (tile.x + 1) * m_board.tileSideLength;
						}
					}
					break;
				case Constants.UP:
					//Check that the user has not crashed into a wall above him
					for each (tile in getTilesInDirection(m_player, Constants.UP)) {
						id = m_board.getTile(tile.x, tile.y);
						if (tile.x * m_board.tileSideLength != m_player.asset.x + m_player.width) {
							if (checkLavaHit(id, tile))
								return true;
							if (isPowerUp(id) && m_boardSprite.isPowerupVisible(tile)) {
								handlePowerUp(id, tile);
							}
							if (id == Constants.WALL ||
								id == Constants.TRAMP ||
								isClosedGate(id)) {
								m_player.startingHeight = getYPositionOfPlayer()
								m_player.asset.y = (tile.y + 1) * m_board.tileSideLength;
								m_player.velocity = Constants.INITIAL_FALL_VELOCITY;
							}
						}
					}
					collideWithPlatform(m_player, direction);
					break;
				case Constants.DOWN:
					m_player.inAir = true;
					if (collideWithPlatform(m_player, direction))
						break;
					else if (standingOnCrate(m_player))
					{
 						crates = getCollidingCrates(m_player)
						playerTile = getCentralTile(m_player);
						for each (temp in crates)
						{
							crateTile = getCentralTile(temp);
							if (crateTile.y > playerTile.y)
							{
								crate = temp;
								break;
							}
						}
						if (crate)
						{
							m_player.asset.y = (int) (crate.asset.y - m_player.height);
							m_player.velocity = 0;
							m_player.inAir = false;
						}
					}
					for each (tile in getTilesInDirection(m_player, Constants.DOWN)) {
						id = m_board.getTile(tile.x, tile.y);
						if (tile.x * m_board.tileSideLength != m_player.asset.x + m_player.width) {
							if (checkLavaHit(id, tile, true)) {
								m_player.inAir = false;
								return true;
							}
							//if (isButton(id) && collidingWithButton(player, tile)) {
								//setButtonDown(board, id);
							//}
							else if (id == Constants.LADDER) {
								// If at the top of the ladder, make sure player falls back to top of ladder and not slightly inside ladder
								var tileAboveLadder:int = m_board.getTile(tile.x, tile.y - 1);

								// Check that the player is close to the top of the ladder when they are climbing up
								// Only check if they are close to the top when they are climbing UP the ladder.
								// When player is falling, he should fall on top of ladder every time.
								// When a player is deliberately pressing down, they should not get y position reset
								var closeToTop:Boolean = Math.abs(m_player.asset.y + m_player.height - (tile.y * m_board.tileSideLength)) <= m_player.downSpeedY;
								if (m_player.dy > 0.1) {
									closeToTop = true;
								}
								if ((tileAboveLadder == Constants.EMPTY || tileAboveLadder == Constants.START || tileAboveLadder == Constants.END)
									&& tileAboveLadder != -1 && closeToTop && !m_keyDown)
								{
									m_player.asset.y = (int) (tile.y * m_board.tileSideLength - m_player.height);
								}
								//m_player.velocity = 0;
								m_player.inAir = false;
							}
							else if (isPowerUp(id) && m_boardSprite.isPowerupVisible(tile)) 
							{
								handlePowerUp(id, tile);
							}
							// If one of the tiles below player is not empty, then player is not falling
							else if (id != Constants.EMPTY &&
									 id != Constants.START &&
									 id != Constants.END &&
									 id != Constants.CRATE &&
									 id != Constants.LAVA &&
									 !(id >= Constants.SIGN1 && id <= Constants.SIGN5) &&
									 !isButton(id) && 
									 !isOpenGate(id) &&
									 !isMovingPlatformStartOrEnd(id) &&
									 !isPowerUp(id)) 
							{
								m_player.asset.y = (int) (tile.y * m_board.tileSideLength - m_player.height);
								m_player.velocity = 0;
								m_player.inAir = false;								
							}
						}
					}

					if (isPlayerFinished()) {
						pause = true; // So that player position is disregarded
                        Stopwatch.pause();
                        util.Audio.playWinSFX();
                        var logData:Object = {time:Stopwatch.getCurrentTiming()};
                        m_logger.logLevelEnd(logData);
                        Menu.updatePlaythroughTime();
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
			return false;
		}
		
		private function isPlayerFinished():Boolean
		{
			var midX:int = m_player.asset.x + m_board.tileSideLength / 2;
			var midY:int = m_player.asset.y + m_board.tileSideLength / 2;
			return midX >= m_finishTile.x &&
			midX <= m_finishTile.x + m_board.tileSideLength &&
			midY >= m_finishTile.y &&
			midY <= m_finishTile.y + m_board.tileSideLength;
		}
		
		private function getYPositionOfPlayer():int
		{
			return (m_board.boardHeightInPixels - m_player.asset.y - m_player.height ) / m_board.tileSideLength;
		}
		
		/**
		 * Uses up the player's energy, and makes him jump a value based on that energy.
		 */
		private function useEnergy(removeMeter:Boolean = true):void
		{
            var logData:Object = {x:m_player.asset.x, y:m_player.asset.y, power:m_player.energy};
            if (m_player.energy > 0) {
                util.Audio.playSpringSFX();
            }
            m_logger.logAction(Constants.AID_SPRING, logData);
			m_player.velocity = Constants.JUMP_VELOCITIES[m_player.energy];
			m_player.inAir = true;
			m_player.startingHeight = getYPositionOfPlayer() + m_player.energy;
			m_player.energy = 0;
			if (removeMeter)
				m_meter.energy = m_player.energy;
		}
		
		/**
		 * Add x to energy
		 * @param	energy
		 */
		private function incrementEnergy(energy:int):void
		{
			if (m_player.times2) {
				energy *= 2;
				m_player.times2 = false;
			}
			m_player.energy += Math.max(0, energy);
			if (m_player.energy > 10) 
				m_player.energy = 10;
			m_meter.energy = m_player.energy;
		}
		
		private function resetPlayer():void
		{
			m_player.asset.x = m_playerStart.x;
			m_player.asset.y = m_playerStart.y;
			m_player.energy = 0;
			m_player.velocity = 0;
			m_player.bounce = false;
			m_player.times2 = false;
			m_meter.energy = m_player.energy;
			// Reset the buttons
			for each (var id:int in buttons) {
				setButtonUp(m_board, id);
			}
			
			for each (id in gates) {
				m_boardSprite.closeGate(m_board, id);
				gateStatus[id] = 0; // CLOSED
			}
			
			m_boardSprite.setPowerupsVisible();

			Stopwatch.start();
		}
		
				/**
		 * Highlights the squares above the player to show how high the player can jump
		 * based on his energy
		 */
		private function showJumpHeight():void
		{
			// Pick x value (low or high) on which to show the jump height
			var x:Number = (m_player.asset.x / m_board.tileSideLength);
			if (x != m_prevPlayerX) 
			{
				removePlayerJumpHeight(x);
				
				var y:int = (int) (m_player.asset.y / m_board.tileSideLength);
				var startingHeight:int = y - 1;
				var endingHeight:int = y - (m_player.energy - 1);
				if (Constants.JUMP_HEIGHT_ONE_HIGHER) 
				{
					endingHeight = y - m_player.energy;
				}
				if (Constants.HIGHLIGHT_PLAYER_SQUARE || Constants.HIGHLIGHT_SMALL_PLAYER_SQUARE) 
				{
					startingHeight = y;
				}
				
				for (var i:int = startingHeight; i >= endingHeight; i--) 
				{
					var id:int = m_board.getTile(x, i);
					if ((id != Constants.WALL && id != Constants.LADDER && !isClosedGate(id) && id != Constants.LAVA) ||
						Constants.HIGHLIGHT_NON_EMPTY) 
					{
						var size:int = m_board.tileSideLength;
						
						// Highlight the top 1/4 of the player's square
						if (Constants.HIGHLIGHT_SMALL_PLAYER_SQUARE && i == y) 
						{
							var rect:Sprite = new Sprite();
							rect.graphics.beginFill(0xFF0000);
							rect.graphics.drawRect(x * size, i * size, m_player.width, size - m_player.height);
							rect.alpha = .25;
							rect.graphics.endFill();
							
							m_jumpHeightRects.push(rect);
							m_boardSprite.addChild(rect);
						} else {
							rect = new Sprite();
							rect.graphics.beginFill(0xFF0000);
							rect.graphics.drawRect(x * size, i * size, m_player.width, size);
							rect.alpha = .25;
							rect.graphics.endFill();
							
							m_jumpHeightRects.push(rect);
							m_boardSprite.addChild(rect);
						}
					} else {
						break;
					}
				}
			}
		}
		
		private function removePlayerJumpHeight(prevX:int = -1):void
		{
			m_prevPlayerX = prevX;
			for each (var rect:Sprite in m_jumpHeightRects) {
				m_boardSprite.removeChild(rect);
			}
			m_jumpHeightRects = new Vector.<Sprite>();
		}
		
		/**
		 * 
		 *	Button Functions
		 * 
		**/
		
		/**
		 * Sets the given button down, and if it is a popupButton, sets its value to 0 (DOWN)
		 * @param	board
		 * @param	id
		 */
		public function setButtonDown(board:Board, id:int):void
		{
			m_boardSprite.setButtonDown(board, id);
			if (isPopupButton(id)) {
				popupButtons[id] = 0;
			} else {
                buttonStatus[id] = 0; // DOWN
            }
			
			var gateId:int = buttonToGate[id];
			if (gateStatus[gateId] == 0) 
			{
				m_boardSprite.openGate(board, gateId);
				gateStatus[gateId] = 1; // OPEN
			}
		}
		
		public function updateButtons():void
		{
			// Go through and set every button down that is being touched
			var popupButtonsTouched:Vector.<int> = new Vector.<int>();
			for (var x:int = 0; x < m_board.width; x++ )
			{
				for (var y:int = 0; y < m_board.height; y++)
				{
					var tile:IntPair = new IntPair(x, y)
					var id:int = m_board.getTile(x, y)
					if (isButton(id))
					{	
						var touched:Boolean = false;
						if (collidingWithButton(m_player, tile))
						{
							setButtonDown(m_board, id);
							touched = true;
						}
						for each (var crate:Crate in m_board.crates)
						{
							if (collidingWithButton(crate, tile))
							{
								setButtonDown(m_board, id);
								touched = true;
							}
						}
						if (isPopupButton(id) && touched)
						{
							popupButtonsTouched.push(id);
						}
					}
				}
			}
			
			// Go through and set all popup buttons not being touched to up
			for (var key:String in popupButtons)
			{
				id = int(key);
				if (popupButtons[id] == 0 && popupButtonsTouched.indexOf(id) == -1) { // Buttons is DOWN and not being touched by player
					setButtonUp(m_board, id);
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
			var objLeft:Number = obj.asset.x + obj.width * .25;
			var objRight:Number = obj.asset.x + obj.width * .75;
			var objY:Number = obj.asset.y + obj.height;
			var tileLeft:Number = tile.x * m_board.tileSideLength + m_board.tileSideLength * .15;
			var tileRight:Number = tile.x * m_board.tileSideLength + m_board.tileSideLength * .85;
			var tileTop:Number = tile.y * m_board.tileSideLength + m_board.tileSideLength * .85;
			var tileBottom:Number = tile.y * m_board.tileSideLength + m_board.tileSideLength;
			
			if (objLeft <= tileRight && objRight >= tileLeft && objY >= tileTop && objY <= tileBottom) {
				result = true;
			}
			return result;
		}
		
		/**
		 * Sets the given button up, and if it is a popupButton, sets its value to 1 (UP)
		 * @param	board
		 * @param	id
		 */
		public function setButtonUp(board:Board, id:int):void
		{
			m_boardSprite.setButtonUp(board, id);
			if (isPopupButton(id)) {
				popupButtons[id] = 1;
			} else {
                buttonStatus[id] = 1; // UP
            }
			
			var gateId:int = buttonToGate[id];
			if (gateStatus[gateId] == 1) 
			{
				m_boardSprite.closeGate(board, gateId);
				gateStatus[gateId] = 0; // CLOSED
			}
		}
		
		/**
		 * Returns true if the id is a button or popup-button
		 * @param	id
		 * @return
		**/
		private function isButton(id:int):Boolean
		{
			return id >= Constants.BUTTON1 && id <= Constants.POPUP_BUTTON5;
		}
		
		private function isPopupButton(id:int):Boolean
		{
			return id >= Constants.POPUP_BUTTON1 && id <= Constants.POPUP_BUTTON5;
		}
		
		/**
		 * 
		 * Gate Functions
		 * 
		**/
		
		private function isClosedGate(id:int):Boolean
		{
			return id >= Constants.GATE1 && id <= Constants.GATE5 && gateStatus[id] == 0;
		}
		
		private function isOpenGate(id:int):Boolean
		{
			return id >= Constants.GATE1 && id <= Constants.GATE5 && gateStatus[id] == 1;
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
		
		/**
		 * 
		 *	Crate Functions
		 * 
		**/
		
		/**
		 * Updates all crates for falling and beingPushed
		**/
		public function updateCrates():void
		{
			for each (var crate:Crate in m_board.crates)
			{
				crate.updatePosition(m_board.tileSideLength);
				checkCrateCollision(crate, Constants.DOWN);
				crate.wasBeingPushed = crate.beingPushed;
				crate.beingPushed = false;
			}
		}
		
		/**
		 * Handles collisions on the given crate in the given direction
		 * Returns whether there was a collision
		 * @param	crate
		 * @param	direction
		 * @return
		 */
		public function checkCrateCollision(crate:Crate, direction:int):Boolean
		{
			switch (direction)
			{
				case Constants.RIGHT:
					// If colliding with a crate, move the crate
					if (crateAbove(crate) || crate.asset.x + crate.width >= m_board.boardWidthInPixels)
					{
						crate.asset.x = crate.oldX;
						return true;
					}
					// If you ran into a wall, keep the player in the previous square
					var tiles:Vector.<IntPair> = getTilesInDirection(crate, Constants.RIGHT)
					for each (var tile:IntPair in tiles)
					{
						var id:int = m_board.getTile(tile.x, tile.y);
						if (isButton(id) && collidingWithButton(crate, tile))
						{
							setButtonDown(m_board, id);
						}
						if (id == Constants.WALL ||
						    id == Constants.LADDER ||
							id == Constants.LAVA ||
							id == Constants.END ||
							id == Constants.TRAMP ||
							isClosedGate(id))
						{
							crate.asset.x = (tile.x - 1) * m_board.tileSideLength
							return true;
						}
					}
					break;
				case Constants.LEFT:
					// If colliding with a crate, move the crate
					if (crateAbove(crate) || crate.asset.x < 0)
					{
						crate.asset.x = crate.oldX;
						return true;
					}
					// If you ran into a wall, keep the player in the previous square
					for each (tile in getTilesInDirection(crate, Constants.LEFT))
					{
						id = m_board.getTile(tile.x, tile.y);
						if (isButton(id) && collidingWithButton(crate, tile))
						{
							setButtonDown(m_board, id);
						}
						if (id == Constants.WALL ||
						    id == Constants.LADDER ||
							id == Constants.LAVA ||
							id == Constants.END ||
							id == Constants.TRAMP ||
							isClosedGate(id))
						{
							crate.asset.x = (tile.x + 1) * m_board.tileSideLength
							return true;
						}
					}
					break;
				case Constants.DOWN:
					crate.inAir = true;
					if (collideWithPlatform(crate, direction))
						break;
					tiles = getTilesInDirection(crate, Constants.DOWN)
					for each (tile in tiles)
					{
						id = m_board.getTile(tile.x, tile.y);
						if (tile.x * m_board.tileSideLength != crate.asset.x + crate.width) {
							if (isButton(id) && collidingWithButton(crate, tile)) {
								setButtonDown(m_board, id);
							}
							else if (collidingWithCrate(crate))
							{
								crate.asset.y = (int) (tile.y * m_board.tileSideLength - crate.height);
								crate.velocity = 0;
								crate.inAir = false;
							}
							// If one of the tiles below player is not empty, then player is not falling
							else if (id != Constants.EMPTY &&
									 id != Constants.START &&
									 id != Constants.CRATE &&
									 !isButton(id) && 
									!isOpenGate(id) &&
									!isMovingPlatformStartOrEnd(id)) {
								crate.asset.y = (int) (tile.y * m_board.tileSideLength - crate.height);
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
		 * Returns whether the given object is standing on a crate
		 * @param	obj
		 * @return
		 */
		private function standingOnCrate(obj:PhysicsObject):Boolean
		{
			var objLeft:Number = obj.asset.x + m_player.airSpeedX;
			var objRight:Number = obj.asset.x + obj.width - m_player.airSpeedX;
			var objTop:Number = obj.asset.y;
			var objBottom:Number = obj.asset.y + obj.height;
			
			for each (var crate:Crate in m_board.crates)
			{
				if (obj != crate)
				{
					var crateLeft:Number = crate.asset.x;
					var crateRight:Number = crate.asset.x + crate.width;
					var crateTop:Number = crate.asset.y;
					var crateBottom:Number = crate.asset.y + crate.height;
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
			var objRight:Number = obj.asset.x + obj.width - 1;
			var objTop:Number = obj.asset.y;
			var objBottom:Number = obj.asset.y + obj.height - 1;
			
			for each (var crate:Crate in m_board.crates)
			{
				if (obj != crate)
				{
					var crateLeft:Number = crate.asset.x;
					var crateRight:Number = crate.asset.x + crate.width;
					var crateTop:Number = crate.asset.y;
					var crateBottom:Number = crate.asset.y + crate.height;
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
			var objRight:Number = obj.asset.x + obj.width - 1;
			var objTop:Number = obj.asset.y + 1;
			var objBottom:Number = obj.asset.y + obj.height - 1;
			
			for each (var crate:Crate in m_board.crates)
			{
				if (obj != crate)
				{
					var crateLeft:Number = crate.asset.x;
					var crateRight:Number = crate.asset.x + crate.width;
					var crateTop:Number = crate.asset.y;
					var crateBottom:Number = crate.asset.y + crate.height;
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
		private function getCollidingCrates(obj:PhysicsObject):Vector.<Crate>
		{
			var objLeft:Number = obj.asset.x;
			var objRight:Number = obj.asset.x + obj.width;
			var objTop:Number = obj.asset.y;
			var objBottom:Number = obj.asset.y + obj.height;
			
			var result:Vector.<Crate> = new Vector.<Crate>();
			
			for each (var crate:Crate in m_board.crates)
			{
				if (obj != crate)
				{
					var crateLeft:Number = crate.asset.x;
					var crateRight:Number = crate.asset.x + crate.width;
					var crateTop:Number = crate.asset.y;
					var crateBottom:Number = crate.asset.y + crate.height;
					if ((objLeft >= crateLeft && objLeft <= crateRight ||
						objRight >= crateLeft && objRight <= crateRight) &&
						(objTop >= crateTop && objTop <= crateBottom ||
						objBottom >= crateTop && objBottom <= crateBottom))
						{
							result.push(crate);
						}
				}
			}
			return result;
		}
		
		private function resetCrates():void
		{
			for each (var crate:Crate in m_board.crates)
			{
				crate.reset();
			}
		}
		
		/**
		 * 
		 *	Platform Functions
		 * 
		**/
		
		/**
		 * Collide with a platform, given a direction
		 * @param	direction
		 */
		private function collideWithPlatform(obj:PhysicsObject, direction:int):void
		{
			obj.onPlatform = false;
			if (isPlatformInObjectTile(obj)) { // Check that a platform is in an object's tile
				for each (var plat:Sprite in platforms) {
					var topPlat:int = plat.y;
					var bottomPlat:int = plat.y + plat.height * .35;
					var rightPlat:int = plat.x + plat.width;
					var leftPlat:int = plat.x;
					
					var playerLeft:int = obj.asset.x + obj.width * .25;
					var playerRight:int = obj.asset.x + obj.width * .75;
					var playerTop:int = obj.asset.y;
					var playerBottom:int = obj.asset.y + obj.height;
					
					if (obj is Crate) {
						playerLeft = obj.asset.x;
						playerRight = obj.asset.x + obj.width;
					}
					
					if (direction == Constants.UP && obj == m_player)
					{
						if (m_player.asset.y <= bottomPlat && m_player.asset.y >= topPlat && 
							playerRight >= leftPlat && playerLeft <= rightPlat) {
							// bounce player off
							m_player.startingHeight = getYPositionOfPlayer()
							m_player.asset.y = plat.y + plat.height * .6;
							m_player.velocity = Constants.INITIAL_FALL_VELOCITY;
						}
					} 
					else if (direction == Constants.DOWN)
					{
						if (playerBottom >= topPlat && playerTop <= bottomPlat &&
							playerRight >= leftPlat && playerLeft <= rightPlat) {
							obj.asset.y = topPlat - obj.height;
							obj.inAir = false;
							
							if (obj is Player || (obj.asset.x + obj.width / 2 <= rightPlat && obj.asset.x + obj.width / 2 >= leftPlat)) 
							{
								obj.onPlatform = true;
							}
						}
					}
				}
			}
		}
		
		private function isPlatformInObjectTile(obj:PhysicsObject):Boolean
		{
			for each (var tile:IntPair in getObjectTiles(obj))
			{
				for each (var platform:Sprite in platforms) {					
					if ((platform.x >= tile.x * m_board.tileSideLength || platform.x <= (tile.x + 1) * m_board.tileSideLength) &&
						platform.y >= tile.y * m_board.tileSideLength && platform.y <= (tile.y + 1) * m_board.tileSideLength)
						return true;
				}
			}
			return false;
		}
		
		private function isMovingPlatformStartOrEnd(id:int):Boolean
		{
			return id >= Constants.MOVING_PLATFORM_START1 && id <= Constants.LONG_MOVING_PLATFORM_END2;
		}
		
		/**
		 * 
		 *	Tile Functions
		 * 
		**/
		
		/**
		 * Returns whether the user is colliding with a ladder
		 * @return
		 */
		private function collidingWithLadder():Boolean
		{
			for each (var tile:IntPair in getObjectTiles(m_player)) {
				if (m_board.getTile(tile.x, tile.y) == Constants.LADDER) 
					return true;
			}
			return false;
		}
		
		private function isPlayerAtTopOfLadder():Boolean
		{
			var result:Boolean = false;
			for each (var tile:IntPair in getTilesInDirection(m_player, Constants.DOWN)) {
				var id:int = m_board.getTile(tile.x, tile.y);
				if (id == Constants.LADDER) {
					if (m_player.asset.y + m_player.height == tile.y * m_board.tileSideLength) {
						result = true;
					} else {
						result = false;
					}
				}
			}
			return result;
		}
		
		/**
		 * Returns true if players is standing on a trampoline
		 * @return
		 */
		private function trampBelowPlayer():Boolean
		{
			for each (var tile:IntPair in getTilesInDirection(m_player, Constants.DOWN)) {
				if (m_board.getTile(tile.x, tile.y) == Constants.TRAMP && m_player.asset.y + m_player.height == tile.y * m_board.tileSideLength) 
					return true;
			}
			return false;
		}
		
		/**
		 * Returns the button below the player, if it exists
		 * @return id: -1 if does not exist.
		 */
		private function playerOnButton():int
		{
			for each (var tile:IntPair in getTilesInDirection(m_player, Constants.UP)) {
				var id:int = m_board.getTile(tile.x, tile.y);
				if (isButton(id)) 
					return id;
			}
			return -1;
		}
		
		/**
		 * Determines if the player is on any signs and displays thier text if so.
		 * Removes the displayed text if there is one and the player is not on a sign.
		**/
		public function displaySign():void
		{
			var found:Boolean = false;
			for each (var tile:IntPair in getObjectTiles(m_player)) {
				var id:int = m_board.getTile(tile.x, tile.y);
				if (id >= Constants.SIGN1 && id <= Constants.SIGN5)
				{
					found = true;
					if (!m_signText)
					{
						m_signText = new TextField();
						m_signText.text = m_board.getSignText(id);
						m_signText.x = tile.x * m_board.tileSideLength;
						m_signText.y = (tile.y - 1) * m_board.tileSideLength;
						m_signText.background = true;
						m_signText.backgroundColor = Constants.SIGN_BACKGROUND_COLOR;
						m_signText.border = true;
						m_signText.borderColor = Constants.SIGN_BORDER_COLOR;
						m_signText.wordWrap = true;
						m_signText.autoSize = TextFieldAutoSize.LEFT
						var format:TextFormat = m_signText.getTextFormat()
						format.size = Constants.SIGN_FONT_SIZE;
						m_signText.setTextFormat(format);
						m_stage.addChild(m_signText);
					}
				}
			}
			if (!found && m_signText)
			{
				if (m_stage.contains(m_signText))
				{
					m_stage.removeChild(m_signText);
				}
				m_signText = null;
			}
		}
		
		/**
		 * Returns whether the user is on top of ONLY a ladder (EMPTY is okay)
		 * @return
		 */
		private function ladderBelowPlayer():Boolean
		{
			var tiles:Vector.<IntPair> = getTilesInDirection(m_player, Constants.DOWN);
			var result:Boolean = false;
			for each (var tile:IntPair in tiles) {
				var id:int = m_board.getTile(tile.x, tile.y);
				if (id == Constants.LADDER) {
					result = true;
				} else if (id != Constants.EMPTY && id != Constants.START && id != Constants.END) {
					result = false;
					break;
				}
			}
			return result;
		}
		
		/**
		 * Returns true if player is colliding with lava. False otherwise
		 * @param	id - id of tile colliding with
		 * @param	tile - tile colliding with
		 * @param	playerBottom - True if bottom of player is hitting lava, false if top of player is hitting lava
		 * @return
		 */
		private function checkLavaHit(id:int, tile:IntPair, playerBottom:Boolean = false):Boolean
		{
			var playerRight:int = m_player.asset.x + m_player.width * .75;
			var playerLeft:int = m_player.asset.x + m_player.width * .25;
			var tileRight:int = (tile.x + 1) * m_board.tileSideLength;
			var tileLeft:int = tile.x * m_board.tileSideLength;
			
			// Check if top or bottom of player is hitting lava
			if (id == Constants.LAVA && !m_player.onPlatform) {
				if (!playerBottom || (playerBottom && playerLeft <= tileRight && playerRight >= tileLeft)) {
					var logData:Object = {x:m_player.asset.x, y:m_player.asset.y};
					m_logger.logAction(Constants.AID_DEATH, logData);
                    util.Audio.playDeathSFX();
					resetPlayer();
					resetCrates();
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Returns an IntPair representing the tile that the center of the provided PhysicsObject falls in
		 * @param	obj
		 * @return
		 */
		public function getCentralTile(obj:PhysicsObject):IntPair
		{
			var centerX:Number = obj.asset.x + obj.width / 2;
			var centerY:Number = obj.asset.y;
			
			var tileX:Number = centerX / m_board.tileSideLength;
			var tileY:Number = centerY / m_board.tileSideLength;
			
			return new IntPair(Math.floor(tileX), Math.floor(tileY));
		}
		
		/**
		 * Returns the tile(s) in which the object is located in terms of intpairs
		 * @return
		 */
		private function getObjectTiles(obj:PhysicsObject):Vector.<IntPair> 		
		{			
			var lowX:int = (int) (obj.asset.x / m_board.tileSideLength);
			var highX:int = (int) ((obj.asset.x + obj.width) / m_board.tileSideLength);
			var highY:int = (int) (obj.asset.y / m_board.tileSideLength);
			var lowY:int = (int) ((obj.asset.y + obj.height - 1) / m_board.tileSideLength);
			
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
			var lowX:int = (int) (obj.asset.x / m_board.tileSideLength);
			var highX:int = (int) ((obj.asset.x + obj.width) / m_board.tileSideLength);
			var lowY:int = (int) ((obj.asset.y + obj.height) / m_board.tileSideLength);
			
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
			var lowX:int = (int) (obj.asset.x / m_board.tileSideLength);
			var highX:int = (int) ((obj.asset.x + obj.width) / m_board.tileSideLength);
			var highY:int = (int) (obj.asset.y / m_board.tileSideLength);
			
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
			var highX:int = (int) ((obj.asset.x + obj.width) / m_board.tileSideLength);
			var lowY:int = (int) ((obj.asset.y + obj.height - 1) / m_board.tileSideLength);
			var highY:int = (int) (obj.asset.y / m_board.tileSideLength);
		
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
			var lowX:int = (int) (obj.asset.x / m_board.tileSideLength);
			var lowY:int = (int) ((obj.asset.y + obj.height - 1) / m_board.tileSideLength);
			var highY:int = (int) (obj.asset.y / m_board.tileSideLength);
			
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
		
		/**
		 *
		 * Key Functions
		 * 
		**/
		
		public function onKeyDown(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			switch (key) {
				case Keyboard.UP :
					m_keyUp = true;
					m_keySpace = false;
					m_keyDown = false;
					break;
				case Keyboard.DOWN:
					m_keyDown = true;
					m_keyUp = false;
					m_keySpace = false;
					break;
				case Keyboard.RIGHT :
					m_keyRight = true;
					m_keyLeft = false;
					break;
				case Keyboard.LEFT :
					m_keyLeft = true;
					m_keyRight = false;
					break;
				case Keyboard.SPACE :
					m_keySpace = true;
					m_keyUp = false;
					m_keyDown = false;
					break;
				case Keyboard.R :
					m_keyR = true;
					break;
				case Keyboard.T :
                    ps = new PlayState(m_player, gateStatus, buttonStatus, m_board.crates);
					break;
				case Keyboard.Y :
                    m_player.replace(ps.player);
                    gateStatus = ObjectUtil.copy(ps.gateStatus);
                    for each (var id:int in gates) {
                        if (gateStatus[id] == 1) {
                            m_boardSprite.openGate(m_board, id);
                        } else {
                            m_boardSprite.closeGate(m_board, id);
                        }
                    }
                    buttonStatus = ObjectUtil.copy(ps.buttonStatus);
                    for each (id in buttons) {
                        if (buttonStatus[id] == 1) {
                            setButtonUp(m_board, id);
                        } else {
                            setButtonDown(m_board, id);
                        }
                    }
                    for each (var c:Crate in m_board.crates) {
                        c.asset.x = ps.crates[c].x;
                        c.asset.y = ps.crates[c].y;
                        c.dy = ps.crates[c].dy;
                    }
					break;
				case Keyboard.ESCAPE :
                    if (Menu.state == Constants.STATE_GAME || Menu.state == Constants.STATE_PAUSE_MENU) {
                        pause = !pause;
                        if (pause) {
                            Menu.createPauseMenu();
                        } else {
                            Menu.removePauseMenu();
                        }
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
					m_keyUp = false;
					break;
				case Keyboard.DOWN :
					m_keyDown = false;
					break;
				case Keyboard.RIGHT :
					m_keyRight = false;
					break;
				case Keyboard.LEFT :
					m_keyLeft = false;
					break;
				case Keyboard.SPACE :
					m_keySpace = false;
					break;
				case Keyboard.R :
					m_keyR = false;
					break;
			}
		}
		
		/**
		 * 
		 * PowerUp Functions
		 * 
		**/
		
		private function isPowerUp(id:int):Boolean
		{
			return id >= Constants.TIMES2 && id <= Constants.PLUS10;
		}
		
		private function handlePowerUp(id:int, tile:IntPair):void
		{
			switch (id)
			{
				case Constants.TIMES2:
					m_player.times2 = true;
					break;
				case Constants.PLUS1:
					incrementEnergy(1);
					break;
				case Constants.PLUS2:
					incrementEnergy(2);
					break;
				case Constants.PLUS3:
					incrementEnergy(3);
					break;
				case Constants.PLUS4:
					incrementEnergy(4);
					break;
				case Constants.PLUS5:
					incrementEnergy(5);
					break;
				case Constants.PLUS6:
					incrementEnergy(6);
					break;
				case Constants.PLUS7:
					incrementEnergy(7);
					break;
				case Constants.PLUS8:
					incrementEnergy(8);
					break;
				case Constants.PLUS9:
					incrementEnergy(9);
					break;
				case Constants.PLUS10:
					incrementEnergy(10);
					break;
			}
			
			m_boardSprite.setPowerupInvisible(tile);
		}
	}
}