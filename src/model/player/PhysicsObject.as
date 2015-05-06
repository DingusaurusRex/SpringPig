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
	}
	
}