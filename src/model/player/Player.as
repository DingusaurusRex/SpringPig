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
		private var m_asset:Bitmap;
		public var speedX:Number = 5;
		public var upSpeedY:Number = 8; // Speed on ladder
		public var downSpeedY:Number = 5; // Speed on ladder
		public var airSpeedX:Number = 5;
		public var inAir:Boolean = false;
		public var onPlatform:Boolean = false;
		
		public var startingHeight:int = 0;
		
		public var dy:Number;
		
		public function Player() 
		{
			m_asset = new playerArt();
			dy = 0;
		}
		
		public function updatePosition(tileSize:int):void
		{
			m_asset.y = m_asset.y + dy * tileSize;
			dy = Math.min(dy + Constants.GRAVITY, Constants.TERMINAL_VELOCITY);
		}
		
		public function set velocity(value:Number):void
		{
			dy = Math.min(value, Constants.TERMINAL_VELOCITY);
		}
		
		public function get asset():Bitmap
		{
			return m_asset;
		}
	}
}