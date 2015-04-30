package model.levelHandling 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	

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
		
		[Embed(source="../../../assets/levels/testlevel.json", mimeType="application/octet-stream")]
		private var testLevel:Class;
		
		public function LevelParser() 
		{
			
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
			var levelString:String = (new testLevel() as ByteArray).toString();
			return new Board(JSON.parse(levelString));
		}
		
	}

}