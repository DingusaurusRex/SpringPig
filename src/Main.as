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
	
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author Jack
	**/
	
	[Frame(factoryClass = "Preloader")]
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
		
		private var kongregate:*;

		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			initKongregateAPI();
			
            var progression:ByteArray;
            var versionID:int;

            // A/B Signs
            progression = new EasyProgression() as ByteArray;
            // Reset selection
            //GameState.clearSaveFile(SHA256.computeDigest(progression));

			var progressionString:String = progression.toString();
			var prog:Object = JSON.parse(progressionString);


            // Initialization
			var game:Game = new Game(stage, prog, null);

            GameState.Init(SHA256.computeDigest(progression), game);

            // A/B Signs
            if (GameState.getPlayerVersion() == Constants.VERSION_NULL) {
				Game.version = Constants.VERSION_B;
				versionID = 302;
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
		
		private function initKongregateAPI():void {
			// Pull the API path from the FlashVars
			var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
					 
			// The API path. The "shadow" API will load if testing locally. 
			var apiPath:String = paramObj.kongregate_api_path || 
			"http://www.kongregate.com/flash/API_AS3_Local.swf";
					 
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);
					 
			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(request);
			this.addChild(loader);          
		}
		
		// This function is called when loading is complete
		private function loadComplete(event:Event):void {
			// Save Kongregate API reference
			kongregate = event.target.content;
				 
			// Connect to the back-end
			kongregate.services.connect();
					 
			// You can now access the API via:
			// kongregate.services
			// kongregate.user
			// kongregate.scores
			// kongregate.stats
			// etc...
		}
	}
}