package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import model.levelHandling.Board;
	import model.levelHandling.LevelParser;
	import util.IntPair;
	import view.BoardView;
	import model.player.Player;
	
	/**
	 * ...
	 * @author Jack
	**/
	
	[SWF(width = "800", height = "600", frameRate = "30")]
	
	public class Main extends Sprite 
	{
		private var player:Player = new Player();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// Get the board for the test level
			var levelReader:LevelParser = new LevelParser();
			var level:Board = levelReader.parseLevel();
			
			// Get the graphics for the test level
			var boardSprite:BoardView = new BoardView(level);
			stage.addChild(boardSprite);
			
			// Add the player to the board
			var player:Player = new Player();
			var playerStart:IntPair = boardSprite.getPlayerStart(); // Top right of the square
			player.character.height = level.tileSideLength * 3.0 / 4.0;
			player.character.width = level.tileSideLength * 3.0 / 4.0;
			player.character.x = playerStart.x;
			player.character.y = playerStart.y;
			
			
			/*
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(0x000000);
			circle.graphics.drawCircle(player.character.x, player.character.y, 5);
			circle.graphics.endFill();
			stage.addChild(circle);
			
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(0x000000);
			circle.graphics.drawCircle(player.character.x, player.character.y + player.character.height, 5);
			circle.graphics.endFill();
			stage.addChild(circle);
			*/
			
			stage.addChild(player.character);
			
			// start the game
			new Game(stage, player, level, playerStart);
		}
		
	}
	
}