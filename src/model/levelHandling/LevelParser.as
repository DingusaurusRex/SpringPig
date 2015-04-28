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
		
		[Embed(source="../../../assets/levels/testlevel.json", mimeType="application/octet-stream")]
		private var testLevel:Class;
		
		public function LevelParser() 
		{
			
		}
		
		public function parseLevel():Board
		{
			var levelString:String = (new testLevel() as ByteArray).toString();
			return new Board(JSON.parse(levelString));
		}
		
	}

}