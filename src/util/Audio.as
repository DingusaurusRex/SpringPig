package util 
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Panji Wisesa
	 */
	public class Audio 
	{
		public static var mute:Boolean;
		private static var muteButtonText:TextField;
		private static var muteButtonTextFormat:TextFormat;
		private static var muteButtonShape:Shape;
		private static var muteButtonSprite:Sprite;
		public static var muteButton:SimpleButton;
		
		public static function Init():void
		{
			mute = false;
			muteButtonText = new TextField();
			muteButtonText.text = Constants.MUTE_BUTTON_TEXT + "Off";
			muteButtonTextFormat = Menu.getMenuButtonTextFormat();
			muteButtonText.setTextFormat(muteButtonTextFormat);
			
			muteButtonShape = Menu.getMenuButtonShape();
			
			muteButtonSprite = new Sprite();
			muteButtonSprite.addChild(muteButtonShape);
			muteButtonSprite.addChild(muteButtonText);
			
			muteButton = new SimpleButton();
			muteButton.upState = muteButtonSprite;
			muteButton.downState = muteButtonSprite;
			muteButton.overState = muteButtonSprite;
			muteButton.hitTestState = muteButtonSprite;
			muteButton.x = Constants.MUTE_BUTTON_LEFT_PADDING;
			muteButton.y = Constants.MUTE_BUTTON_TOP_PADDING;
			
			muteButton.addEventListener(MouseEvent.CLICK, onMuteClick);
		}
		
		public static function flipMute():void
		{
			mute = !mute;
			if (mute)
			{
				muteButtonText.text = Constants.MUTE_BUTTON_TEXT + "On";
			} else
			{
				muteButtonText.text = Constants.MUTE_BUTTON_TEXT + "Off";
			}
			muteButtonText.setTextFormat(muteButtonTextFormat);
		}
		
		public static function onMuteClick(event:MouseEvent):void
		{
			Audio.flipMute();
		}
	}

}