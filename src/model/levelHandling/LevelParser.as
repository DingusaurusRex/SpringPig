package model.levelHandling 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	

	/**
	 * ...
	 * @author Jack
	 */
	public class LevelParser 
	{
		
		/**
		 * 
		 * Embedded Levels
		 * 
		**/
		
		[Embed(source="../../../assets/levels/testlevel1.json", mimeType="application/octet-stream")]
		private var TestLevel1:Class;
		
		[Embed(source = "../../../assets/levels/testlevel2.json", mimeType = "application/octet-stream")]
		private var TestLevel2:Class;
		
		[Embed(source = "../../../assets/levels/crateTest.json", mimeType = "application/octet-stream")]
		private var CrateTest:Class;
		
		[Embed(source = "../../../assets/levels/level1.json", mimeType = "application/octet-stream")]
		private var Level1:Class;
		
		[Embed(source = "../../../assets/levels/level2.json", mimeType = "application/octet-stream")]
		private var Level2:Class;
		
		[Embed(source = "../../../assets/levels/level3.json", mimeType = "application/octet-stream")]
		private var Level3:Class;
		
		[Embed(source = "../../../assets/levels/level4.json", mimeType = "application/octet-stream")]
		private var Level4:Class;
		
		[Embed(source = "../../../assets/levels/level5.json", mimeType = "application/octet-stream")]
		private var Level5:Class;
		
		[Embed(source = "../../../assets/levels/level6.json", mimeType = "application/octet-stream")]
		private var Level6:Class;
		
		[Embed(source = "../../../assets/levels/level7.json", mimeType = "application/octet-stream")]
		private var Level7:Class;
		
		[Embed(source = "../../../assets/levels/level8.json", mimeType = "application/octet-stream")]
		private var Level8:Class;
		
		[Embed(source = "../../../assets/levels/level8B.json", mimeType = "application/octet-stream")]
		private var Level8B:Class;
		
		[Embed(source = "../../../assets/levels/level9.json", mimeType = "application/octet-stream")]
		private var Level9:Class;
		
		[Embed(source = "../../../assets/levels/level10.json", mimeType = "application/octet-stream")]
		private var Level10:Class;
		
		[Embed(source = "../../../assets/levels/level11.json", mimeType = "application/octet-stream")]
		private var Level11:Class;
		
		[Embed(source = "../../../assets/levels/level12.json", mimeType = "application/octet-stream")]
		private var Level12:Class;
		
		[Embed(source = "../../../assets/levels/level13.json", mimeType = "application/octet-stream")]
		private var Level13:Class;

		[Embed(source = "../../../assets/levels/level14.json", mimeType = "application/octet-stream")]
		private var Level14:Class;
		
		[Embed(source = "../../../assets/levels/level15.json", mimeType = "application/octet-stream")]
		private var Level15:Class;
		
		[Embed(source = "../../../assets/levels/level16.json", mimeType = "application/octet-stream")]
		private var Level16:Class;
		
		[Embed(source = "../../../assets/levels/level19.json", mimeType = "application/octet-stream")]
		private var Level19:Class;
		
		[Embed(source = "../../../assets/levels/level22.json", mimeType = "application/octet-stream")]
		private var Level22:Class;
		
		[Embed(source = "../../../assets/levels/level25.json", mimeType = "application/octet-stream")]
		private var Level25:Class;
		
		[Embed(source = "../../../assets/levels/level25B.json", mimeType = "application/octet-stream")]
		private var Level25B:Class;
		
		[Embed(source = "../../../assets/levels/level28.json", mimeType = "application/octet-stream")]
		private var Level28:Class;
		
		[Embed(source = "../../../assets/levels/level31.json", mimeType = "application/octet-stream")]
		private var Level31:Class;

        [Embed(source = "../../../assets/levels/level0.json", mimeType = "application/octet-stream")]
        private var Level0:Class;

        [Embed(source = "../../../assets/levels/level17.json", mimeType = "application/octet-stream")]
        private var Level17:Class;

        [Embed(source = "../../../assets/levels/level20.json", mimeType = "application/octet-stream")]
        private var Level20:Class;

        [Embed(source = "../../../assets/levels/level23.json", mimeType = "application/octet-stream")]
        private var Level23:Class;
		
		[Embed(source = "../../../assets/levels/level18.json", mimeType = "application/octet-stream")]
		private var Level18:Class;
		
		[Embed(source = "../../../assets/levels/level21.json", mimeType = "application/octet-stream")]
		private var Level21:Class;
		
		[Embed(source = "../../../assets/levels/level24.json", mimeType = "application/octet-stream")]
		private var Level24:Class;

		[Embed(source = "../../../assets/levels/resetTutorial.json", mimeType = "application/octet-stream")]
		private var ResetTutorial:Class;
		
		[Embed(source = "../../../assets/levels/ladderTutorial.json", mimeType = "application/octet-stream")]
		private var LadderTutorial:Class;
		
		[Embed(source = "../../../assets/levels/levelA1.json", mimeType = "application/octet-stream")]
		private var LevelA1:Class;
		
		[Embed(source = "../../../assets/levels/levelA2.json", mimeType = "application/octet-stream")]
		private var LevelA2:Class;
		
		[Embed(source = "../../../assets/levels/levelA3.json", mimeType = "application/octet-stream")]
		private var LevelA3:Class;
		
		[Embed(source = "../../../assets/levels/levelA4.json", mimeType = "application/octet-stream")]
		private var LevelA4:Class;
		
		[Embed(source = "../../../assets/levels/levelA5.json", mimeType = "application/octet-stream")]
		private var LevelA5:Class;
		
		
		/**
		 *	Level Names Dictionary
		**/
		
		private var m_levelNames:Dictionary;
		
		public function LevelParser() 
		{
			m_levelNames = new Dictionary();
			
			/**
			 * Add new level names here
			**/
			m_levelNames["test1"] = TestLevel1;
			m_levelNames["test2"] = TestLevel2;
			m_levelNames["crateTest"] = CrateTest;
			m_levelNames["level1"] = Level1;
			m_levelNames["level2"] = Level2;
			m_levelNames["level3"] = Level3;
			m_levelNames["level4"] = Level4;
			m_levelNames["level5"] = Level5;
			m_levelNames["level6"] = Level6;
			m_levelNames["level7"] = Level7;
			m_levelNames["level8"] = Level8;
			m_levelNames["level9"] = Level9;
			m_levelNames["level10"] = Level10;
			m_levelNames["level11"] = Level11;
			m_levelNames["level12"] = Level12;
			m_levelNames["level13"] = Level13;
			m_levelNames["level14"] = Level14;
			m_levelNames["level15"] = Level15;
			m_levelNames["level16"] = Level16;
			m_levelNames["level19"] = Level19;
			m_levelNames["level22"] = Level22;
			m_levelNames["level25"] = Level25;
			m_levelNames["level25B"] = Level25B;
			m_levelNames["level28"] = Level28;
			m_levelNames["level31"] = Level31;
			m_levelNames["level0"] = Level0;
			m_levelNames["level17"] = Level17;
			m_levelNames["level20"] = Level20;
			m_levelNames["level23"] = Level23;
			m_levelNames["level18"] = Level18;
			m_levelNames["level21"] = Level21;
			m_levelNames["level24"] = Level24;
			m_levelNames["resetTutorial"] = ResetTutorial;
			m_levelNames["ladderTutorial"] = LadderTutorial;
			m_levelNames["level8B"] = Level8B;
			m_levelNames["levelA1"] = LevelA1;
			m_levelNames["levelA2"] = LevelA2;
			m_levelNames["levelA3"] = LevelA3;
			m_levelNames["levelA4"] = LevelA4;
			m_levelNames["levelA5"] = LevelA5;
		}
		
		/**
		 * Parses the level JSON for the level with the given levelName
		 * levelName must correspond to a valid level class embedded above
		 * 
		 * TODO: Currently ignores the levelName String and always displays the testLevel
		 * 		 Make it so that it can display the level specified by the levelName
		 * 
		 * @param	levelName - The name of the level to parse
		 * @return	An object containing the fields of the level JSON
		 */
		public function parseLevel(levelName:String):Board
		{
			var levelClass:Class = m_levelNames[levelName];
			var levelString:String = (new levelClass() as ByteArray).toString();
			return new Board(JSON.parse(levelString));
		}
		
	}

}