package model.player 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jack
	 */
	public interface PhysicsObject 
	{
		function updatePosition(tileSize:int):void;
		function set velocity(value:Number):void;
		function get asset():Sprite;
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