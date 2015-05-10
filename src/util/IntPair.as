package util 
{
	/**
	 * ...
	 * @author Marc
	 * 
	 * Allows passing in of x/y coordinates more easily
	 * 
	 */
	public class IntPair 
	{
		public var x:int;
		public var y:int;
		
		public function IntPair(int1:int, int2:int) 
		{
			x = int1;
			y = int2;
		}
		
		public function isEqualTo(other:IntPair):Boolean
		{
			if (x == other.x && y == other.y) 
				return true;
			else 
				return false;
		}
		
	}

}