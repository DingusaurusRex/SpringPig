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
		private var testLevel1:Class;
		
		[Embed(source = "../../../assets/levels/testlevel2.json", mimeType = "application/octet-stream")]
		private var testLevel2:Class;
		
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
			m_levelNames["test1"] = testLevel1;
			m_levelNames["test2"] = testLevel2;
			
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