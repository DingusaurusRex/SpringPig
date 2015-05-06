package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import model.levelHandling.Board;
	import model.levelHandling.LevelParser;

import util.GameState;
import util.IntPair;
	import util.Audio;
	import util.Stopwatch;
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
		/**
		 * Embedded Progressions
		 */
		
		[Embed(source = "../assets/progressions/testProgression.json", mimeType = "application/octet-stream")]
		private var TestProgression:Class;
		
		[Embed(source = "../assets/progressions/progression1.json", mimeType = "application/octet-stream")]
		private var Progression1:Class;
		
		[Embed(source = "../assets/progressions/progression2.json", mimeType = "application/octet-stream")]
		private var Progression2:Class;
		
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
			
			// Parse LevelProgression JSON
			//var progressionString:String = (new Progression1() as ByteArray).toString();
			var progressionString:String = (new Progression1() as ByteArray).toString();
			var prog:Object = JSON.parse(progressionString);
			
			// Menu Stuff Here!!!!!!!!!!!!!
			var game:Game = new Game(stage, prog);
			Audio.Init();
			Stopwatch.Init();
            GameState.Init("Progression1", game);
			Menu.Init(stage, game);
			Menu.createMainMenu();
			

			// start the game
			//var game:Game = new Game(stage);
			//game.startLevel("");
		}
		
	}
	
}