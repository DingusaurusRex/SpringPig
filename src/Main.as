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

            // A/B Signs
            progression = new EasyProgression() as ByteArray;
            // Reset selection
            //GameState.clearSaveFile(SHA256.computeDigest(progression));

            // A/B Progression
            /*
            var progression1:ByteArray = new Progression1() as ByteArray;
            var progression2:ByteArray = new EasyProgression() as ByteArray;

            // Reset selection
            //GameState.clearSaveFile(SHA256.computeDigest(progression1));
            //GameState.clearSaveFile(SHA256.computeDigest(progression2));

            if (GameState.checkSaveFile(SHA256.computeDigest(progression1))) {
                progression = progression1;
                versionID = 303;
            } else if (GameState.checkSaveFile(SHA256.computeDigest(progression2))) {
                progression = progression2;
                versionID = 302;
            } else {
                var num:Number = Math.random();
                var useHardProg:Boolean = true;
                if (num >= .5) {
                    useHardProg = false;
                }
                trace(useHardProg);

                if (useHardProg) {
                    progression = progression1;
                    versionID = 303;
                } else {
                    progression = progression2;
                    versionID = 302;
                }
            }
            */

            // No A/B
            /*
			progression = new EasyProgression(); // Change this for progression
			versionID = 302; // This is cid in the wiki
			*/

			var progressionString:String = progression.toString();
			var prog:Object = JSON.parse(progressionString);


            // Initialization
			var game:Game = new Game(stage, prog, null);

            GameState.Init(SHA256.computeDigest(progression), game);

            // A/B Signs
            if (GameState.getPlayerVersion() == Constants.VERSION_NULL) {
                var num:Number = Math.random();
                var useA:Boolean = true;
                if (num >= .5) {
                    useA = false;
                }
                //trace("rand");
                if (useA) {
                    Game.version = Constants.VERSION_A;
                    versionID = 303;
                } else {
                    Game.version = Constants.VERSION_B;
                    versionID = 302;
                }
                GameState.savePlayerVersion(Game.version);
            } else {
                Game.version = GameState.getPlayerVersion();
            }

            var logger:Logger = Logger.initialize(Constants.GID, Constants.DB_NAME, Constants.SKEY, versionID, null, false);
            game.m_logger = logger;

			Audio.Init(GameState.getPlayerMuteOption());
			Stopwatch.Init();
			Menu.Init(stage, game);
			Menu.createMainMenu();

		}		
	}	
}