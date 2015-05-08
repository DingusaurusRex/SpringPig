package model.player 
{
	import adobe.utils.CustomActions;
	import cgs.engine.view.mouseInteraction.IDraggable;
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
		public var speedX:Number;
		public var cratePushSpeed:Number;
		public var upSpeedY:Number; // Speed on ladder
		public var downSpeedY:Number; // Speed on ladder
		public var airSpeedX:Number;
		public var inAir:Boolean = false;
		public var onPlatform:Boolean = false;
		
		public var startingHeight:int = 0;
		
		public var dy:Number;
		
		public function Player(tileSideLength:int) 
		{
			m_asset = new playerArt();
			dy = 0;
			
			var frac:Number = tileSideLength / Constants.BASE_SIDE_LENGTH;
			speedX = Constants.PLAYER_SPEED * frac;
			cratePushSpeed = Constants.CRATE_SPEED * frac;
			upSpeedY = Constants.LADDER_UP_SPEED * frac;
			downSpeedY = Constants.LADDER_DOWN_SPEED * frac;
			airSpeedX = Constants.AIR_SPEED * frac;
			trace(speedX);
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
		
		public function get width():int
		{
			return m_asset.width;
		}
		
		public function set width(val:int):void
		{
			m_asset.width = val;
		}
		
		public function get height():int
		{
			return m_asset.height;
		}
		
		public function set height(val:int):void
		{
			m_asset.height = val;
		}
	}
}