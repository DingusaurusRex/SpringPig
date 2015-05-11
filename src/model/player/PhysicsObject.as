package model.player 
{
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Jack
	 */
	public interface PhysicsObject 
	{
		function updatePosition(tileSize:int):void;
		function set velocity(value:Number):void;
		function get asset():Bitmap;
		function get width():int;
		function set width(val:int):void;
		function get height():int;
		function set height(val:int):void;
		function get onPlatform():Boolean;
		function set onPlatform(val:Boolean):void;
		function set inAir(val:Boolean):void
		function get inAir():Boolean;
	}
	
}