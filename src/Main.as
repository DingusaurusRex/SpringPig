package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import model.levelHandling.Board;
	import model.levelHandling.LevelParser;
	import view.BoardView;
	
	/**
	 * ...
	 * @author Jack
	**/
	
	[SWF(width = "800", height = "600", frameRate = "30")]
	
	public class Main extends Sprite 
	{		
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
		}
		
	}
	
}