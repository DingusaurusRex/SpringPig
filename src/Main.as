package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
    import mx.utils.SHA256;
	import model.levelHandling.Board;
	import model.levelHandling.LevelParser;

	import util.GameState;
	import util.IntPair;
	import util.Audio;
	import util.Stopwatch;
	import view.BoardView;
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

		[Embed(source = "../assets/progressions/testProgression2.json", mimeType = "application/octet-stream")]
		private var TestProgression2:Class;
		
		[Embed(source = "../assets/progressions/progression1.json", mimeType = "application/octet-stream")]
		private var Progression1:Class;
		
		[Embed(source = "../assets/progressions/progression2.json", mimeType = "application/octet-stream")]
		private var Progression2:Class;
		
		[Embed(source = "../assets/progressions/easyProgression.json", mimeType = "application/octet-stream")]
		private var EasyProgression:Class;

		[Embed(source = "../assets/progressions/signsProgression.json", mimeType = "application/octet-stream")]
		private var signsProgression:Class;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
            var progression:ByteArray;
            var versionID:int;

            var progression1:ByteArray = new Progression1() as ByteArray;
            var progression2:ByteArray = new EasyProgression() as ByteArray;

            //GameState.clearSaveFile(SHA256.computeDigest(progression1));
            //GameState.clearSaveFile(SHA256.computeDigest(progression2));
            if (GameState.checkSaveFile(SHA256.computeDigest(progression1))) {
                progression = progression1;
                versionID = 300;
                //trace("1");
            } else if (GameState.checkSaveFile(SHA256.computeDigest(progression2))) {
                progression = progression2;
                versionID = 302;
                //trace("2");
            } else {
                var num:Number = Math.random();
                var useHardProg:Boolean = true;
                if (num >= .5) {
                    useHardProg = false;
                }
                //trace("3");
                trace(useHardProg);

                if (useHardProg) {
                    progression = new EasyProgression() as ByteArray;
                    versionID = 302;
                } else {
                    progression = new Progression1() as ByteArray;
                    versionID = 300;
                }
            }
			/*
			var num:Number = Math.random();
			var useHardProg:Boolean = true;
			if (num >= .5) {
				useHardProg = false;
			}
			trace(useHardProg);
			
			// Parse LevelProgression JSON
			if (useHardProg) {
				progression = new EasyProgression() as ByteArray;
				versionID = 302;
			} else {
				progression = new Progression1() as ByteArray;
				versionID = 300;
			}*/
			//var progression:ByteArray = new EasyProgression(); // Change this for progression
			//var versionID:int = 302; // This is cid in the wiki
			var progressionString:String = progression.toString();
			var prog:Object = JSON.parse(progressionString);

           
            var logger:Logger = Logger.initialize(Constants.GID, Constants.DB_NAME, Constants.SKEY, versionID, null, false);
			
            // Initialization
			var game:Game = new Game(stage, prog, logger);
            GameState.Init(SHA256.computeDigest(progression), game);
			Audio.Init(GameState.getPlayerMuteOption());
			Stopwatch.Init();
			Menu.Init(stage, game);
			Menu.createMainMenu();

		}		
	}	
}