package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import com.adobe.serialization.json.JSON;
	

	/**
	 * ...
	 * @author Jack
	 */
	public class FileParser 
	{
		
		[Embed(source = "../assets/levels/testlevel.json", mimeType = "application/octet-stream")]
		var testLevel:Class;
		
		public function FileParser() 
		{
			
		}
		
		public function parseFile():Object
		{
			var levelString:String = (new testLevel() as ByteArray).toString();
			return JSON.parse(levelString);
		}
		
	}

}