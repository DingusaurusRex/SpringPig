package model.player 
{
	import flash.display.Bitmap;
	import util.IntPair;
	/**
	 * ...
	 * @author Jack
	 */
	public class Crate implements PhysicsObject 
	{
		[Embed(source = "../../../assets/art/tiles/crate.png")]
		private var CrateArt:Class;
		
		private var m_asset:Bitmap;
		public var inAir:Boolean = false;
		public var dy:Number = 0;
		public var startingPos:IntPair;
		
		public function Crate() 
		{
			m_asset = new CrateArt();
		}
		
		/* INTERFACE model.player.PhysicsObject */
		
		public function set velocity(value:Number):void 
		{
			dy = Math.min(value, Constants.TERMINAL_VELOCITY);
		}
		
		public function updatePosition(tileSize:int):void 
		{
			m_asset.y = m_asset.y + dy * tileSize;
			dy = Math.min(dy + Constants.GRAVITY, Constants.TERMINAL_VELOCITY);
		}
		
		public function get asset():Bitmap
		{
			return m_asset;
		}
		
		public function reset():void
		{
			asset.x = startingPos.x;
			asset.y = startingPos.y;
			dy = 0;
		}
		
		public function get width():int
		{
			return m_asset.width - 1;
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