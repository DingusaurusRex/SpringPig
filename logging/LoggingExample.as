package
{
	import cse481d.Logger;
	
	import flash.display.Sprite;
	
	public class LoggingExample extends Sprite
	{
		public function LoggingExample()
		{
			var gid:uint = 0; //INSERT TEAM GID HERE
			var gname:String = "INSERT TEAM GAME NAME HERE";
			var skey:String = "INSERT TEAM SKEY HERE";
			var cid:int = 1; //category id; treat this like a "version id" or "release number" to help differentiate data from different versions
			var logger:Logger = Logger.initialize(gid, gname, skey, 1, null); //automatically logs a page load; don't need any parameters
			
			logger.logLevelStart(1, null); //start level 1
			logger.logAction(10, {"mouseX":151}); //action 10 is performed; the parameters allow us to track mouse position
			logger.logAction(11); //action 11 is performed; the parameters allow us to track mouse position
			logger.logLevelEnd(null); //end level 1
			logger.logLevelStart(1, null); //start level 2
			logger.logAction(15, null); //action 15 is performed; no parameters are needed
			//player quits before finishing level 2
		}
	}
}