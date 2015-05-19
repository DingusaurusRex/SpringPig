package model.player 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Marc
	 */
	public class Player implements PhysicsObject 
	{
		[Embed(source="../../../assets/art/player/SpringPigWhole.svg")]
		private var playerArt:Class;
		
		public var energy:int = 0;
		private var m_asset:Sprite;
		public var speedX:Number;
		public var cratePushSpeed:Number;
		public var upSpeedY:Number; // Speed on ladder
		public var downSpeedY:Number; // Speed on ladder
		public var airSpeedX:Number;
		private var m_inAir:Boolean = false;
		private var m_onPlatform:Boolean = false;
		
		public var bounce:Boolean = false;
		public var times2:Boolean = false;
		
		public var startingHeight:int = 0;
		
		public var dy:Number;
		
		public function Player(tileSideLength:int) 
		{
			
			try {
				m_asset = new playerArt();
			} catch(error:Error){
				trace(error);
			}
			dy = 0;
			
			var frac:Number = tileSideLength / Constants.BASE_SIDE_LENGTH;
			speedX = Constants.PLAYER_SPEED * frac;
			cratePushSpeed = Constants.CRATE_SPEED * frac;
			//cratePushSpeed = 1;
			upSpeedY = Constants.LADDER_UP_SPEED * frac;
			downSpeedY = Constants.LADDER_DOWN_SPEED * frac;
			airSpeedX = Constants.AIR_SPEED * frac;
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
		
		public function get asset():Sprite
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

        public function clone():Player {
            var player:Player = new Player(0);
            player.energy = this.energy;
            player.m_asset = new playerArt();
            player.m_asset.x = this.m_asset.x;
            player.m_asset.y = this.m_asset.y;
            player.speedX = this.speedX;
            player.cratePushSpeed = this.cratePushSpeed;
            player.upSpeedY = this.upSpeedY;
            player.downSpeedY = this.downSpeedY;
            player.airSpeedX = this.airSpeedX;
            player.m_inAir = this.m_inAir;
            player.m_onPlatform = this.m_onPlatform;
            player.bounce = this.bounce;
            player.times2 = this.times2;
            player.startingHeight = this.startingHeight;
            player.dy = this.dy;
            return player;
        }

        public function replace(player:Player):void {
            this.energy = player.energy;
            this.m_asset.x = player.m_asset.x;
            this.m_asset.y = player.m_asset.y;
            this.speedX = player.speedX;
            this.cratePushSpeed = player.cratePushSpeed;
            this.upSpeedY = player.upSpeedY;
            this.downSpeedY = player.downSpeedY;
            this.airSpeedX = player.airSpeedX;
            this.m_inAir = player.m_inAir;
            this.m_onPlatform = player.m_onPlatform;
            this.bounce = player.bounce;
            this.times2 = player.times2;
            this.startingHeight = player.startingHeight;
            this.dy = player.dy;
        }
	}
}