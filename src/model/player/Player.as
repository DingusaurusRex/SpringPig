package model.player 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Marc
	 */
	public class Player 
	{
		[Embed(source = "../../../assets/art/player/pig.png")]
		private var playerArt:Class;
		
		public var energy:int = 0;
		public var character:Bitmap;
		public var speedX:Number = 5;
		public var airSpeedX:Number = 5;
		public var inAir:Boolean = false;
		
		public var startingHeight:int = 0;
		
		public function Player() 
		{
			character = new playerArt();
		}
		
	}

}