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
	import view.MeterView;
	
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
			
			// Menu Stuff Here!!!!!!!!!!!!!
			var game:Game = new Game(stage);
			Menu.Init(stage, game);
			Menu.createMainMenu();
			// Parse LevelProgression JSON, determine the first level, pass that string into startLevel()
			
			
			// start the game
			//var game:Game = new Game(stage);
			//game.startLevel("");
		}
		
	}
	
}