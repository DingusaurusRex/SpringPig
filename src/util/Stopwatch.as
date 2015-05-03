package util 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Panji Wisesa
	 */
	public class Stopwatch 
	{
		private static var totalTime:int;
		private static var splitStartTime:int;
		private static var started:Boolean;
		private static var paused:Boolean;
		
		public static var stopwatchText:TextField = new TextField();
		private static var stopwatchDefaultTextFormat:TextFormat = new TextFormat();
		
		/**
		 * Initialize the Stopwatch
		 */
		public static function Init():void
		{
			totalTime = 0;
			splitStartTime = getTimer();
			started = false;
			paused = false;
			stopwatchText.text = "00:00.000";
			stopwatchDefaultTextFormat.font = Constants.GAME_STOPWATCH_FONT;
			stopwatchDefaultTextFormat.size = Constants.GAME_STOPWATCH_FONT_SIZE;
			stopwatchText.setTextFormat(stopwatchDefaultTextFormat);
		}
		
		/**
		 * Starts the stopwatch
		 * Time is not reset
		 */
		public static function start():void
		{
			if (!started || paused)
			{
				splitStartTime = getTimer();
				started = true;
				paused = false;
			}
		}
		
		/**
		 * Pauses the stopwatch
		 * Does nothing if the stopwatch was not previously started
		 */
		public static function pause():void
		{
			if (started && !paused)
			{
				totalTime += getTimer() - splitStartTime;
				paused = true;
				stopwatchText.text = formatTiming(getCurrentTiming());
			}
		}
		
		/**
		 * Resets the stopwatch
		 * Does nothing if the stopwatch was not previously started
		 */
		public static function reset():void
		{
			totalTime = 0;
			started = false;
			paused = false;
			stopwatchText.text = "00:00.000";
			stopwatchText.setTextFormat(stopwatchDefaultTextFormat);
		}
		
		/**
		 * Get the current timing on the stopwatch
		 * 0 if the stopwatch was not previously started
		 * @return The current timing on the stopwatch
		 */
		public static function getCurrentTiming():int
		{
			if (started)
			{
				if (paused)
				{
					return totalTime;
				}
				return totalTime + getTimer() - splitStartTime;
			}
			return 0;
		}
		
		public static function updateStopwatchText():void
		{
			if (started && !paused)
			{
				stopwatchText.text = formatTiming(getCurrentTiming());
				stopwatchText.setTextFormat(stopwatchDefaultTextFormat);
			}
		}
		
		public static function formatTiming(timing:int):String
		{
			var time:String = "";
			var minutes:int = timing / 60000;
			var seconds:int = (timing % 60000) / 1000;
			var milliseconds:int = (timing % 60000) % 1000;
			if (minutes < 10)
			{
				time += "0";
			}
			time += String(minutes) + ":";
			if (seconds < 10)
			{
				time += "0";
			}
			time += String(seconds) + "." + String(milliseconds);
			return time;
		}
	}

}