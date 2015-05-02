package model.button 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Marc
	 */
	public class Button 
	{
		[Embed(source = "../../../assets/art/tiles/buttonDOWN.png")]
		private var buttonDownArt:Class;
		[Embed(source = "../../../assets/art/tiles/buttonUP.png")]
		private var buttonUpArt:Class;
		
		private var character:Sprite;
		private var upButton:Sprite;
		private var downButton:Sprite;
		
		public function Button()
		{
			upButton = new buttonUpArt();
			downButton = new buttonDownArt();
			character = upButton;
		}
		
		/**
		 * Set the button to its upstate
		 */
		public function setUp()
		{
			if (character != upButton) {
				character = upButton;
			}
		}
		
		/**
		 * Set the button to its downstate
		 */
		public function setDown()
		{
			if (character != downButton) {
				character = downButton;
			}
		}
		
	}

}