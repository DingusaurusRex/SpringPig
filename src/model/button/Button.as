package model.button 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Marc
	 */
	public class Button 
	{
		/*
		[Embed(source = "../../../assets/art/tiles/buttonDOWN.png")]
		private var buttonDownArt:Class;
		
		[Embed(source = "../../../assets/art/tiles/buttonUP.png")]
		private var buttonUpArt:Class;
		*/
		
		private var character:Sprite;
		private var upButton:Sprite;
		private var downButton:Sprite;
		
		private var buttonNum:int;
		
		public function Button(num:int)
		{
			//upButton = new buttonUpArt();
			//downButton = new buttonDownArt();
			//character = upButton;
			
			buttonNum = num;
		}
		
		public function get num():int
		{
			return buttonNum;
		}
		
		/**
		 * Set the button to its upstate
		 */
		public function setUp():void
		{
			if (character != upButton) {
				character = upButton;
			}
		}
		
		/**
		 * Set the button to its downstate
		 */
		public function setDown():void
		{
			if (character != downButton) {
				character = downButton;
			}
		}
		
	}

}