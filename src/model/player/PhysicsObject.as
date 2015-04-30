package model.player 
{
	
	/**
	 * ...
	 * @author Jack
	 */
	public interface PhysicsObject 
	{
		function updatePosition(tileSize:int):void;
		function set velocity(value:Number):void;
	}
	
}