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
			m_levelNames["level1"] = Level1;
			m_levelNames["level2"] = Level2;
			m_levelNames["level3"] = Level3;
			m_levelNames["level4"] = Level4;
			m_levelNames["level5"] = Level5;
			m_levelNames["level6"] = Level6;
			m_levelNames["level7"] = Level7;
			m_levelNames["level8"] = Level8;
			
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