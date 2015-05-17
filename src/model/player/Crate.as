package model.player 
{
	import flash.display.Sprite;
	import util.IntPair;
	/**
	 * ...
	 * @author Jack
	 */
	public class Crate implements PhysicsObject 
	{
		[Embed(source = "../../../assets/art/tiles/crate.svg")]
		private var CrateArt:Class;
		
		public var dy:Number = 0;
		public var startingPos:IntPair;
		public var oldX:Number = 0;
		
		public var beingPushed:Boolean;
		public var wasBeingPushed:Boolean
		
		private var m_asset:Sprite;
		private var m_inAir:Boolean = false;
		private var m_onPlatform:Boolean;
		
		public function Crate() 
		{
			try {
				m_asset = new CrateArt();
			} catch (error:Error){
				trace(error);
			}
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
		
		public function get asset():Sprite
		{
			return m_asset;
		}
		
		public function reset():void
		{
			trace(startingPos.x);
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
		
		public function get onPlatform():Boolean
		{
			return m_onPlatform;
		}
		
		public function set onPlatform(val:Boolean):void
		{
			m_onPlatform = val;
		}
		
		public function set inAir(val:Boolean):void
		{
			m_inAir = val;
		}
		
		public function get inAir():Boolean
		{
			return m_inAir;
		}
	}

}