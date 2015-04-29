package model.player 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Marc
	 */
	public class Player implements PhysicsObject 
	{
		[Embed(source = "../../../assets/art/player/pig.png")]
		private var playerArt:Class;
		
		public var energy:int = 0;
		public var character:Bitmap;
		public var speedX:Number = 5;
		public var airSpeedX:Number = 5;
		public var inAir:Boolean = false;
		
		public var startingHeight:int = 0;
		
		public var dy:Number = 0;
		
		public function Player() 
		{
			character = new playerArt();
		}
		
		public function updatePosition(tileSize:int):void
		{
			character.y = character.y + dy * tileSize;
			dy = Math.min(dy + Constants.GRAVITY, Constants.TERMINAL_VELOCITY);
		}
		
		public function set velocity(value:Number):void
		{
			dy = Math.min(value, Constants.TERMINAL_VELOCITY);
		}
		
	}

}