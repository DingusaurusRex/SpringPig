package model.button 
{
	/**
	 * ...
	 * @author Marc
	 */
	public class Gate 
	{
		private var gateNumber:int = 0;
		
		public function Gate(number:int) 
		{
			gateNumber = number;
		}
		
		public function get num():int 
		{
			return gateNumber;
		}
	}
}