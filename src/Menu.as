package 
{
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import Constants;
	/**
	 * ...
	 * @author Panji Wisesa
	 */
	public class Menu 
	{
		public static var stage:Stage;
		public static var game:Game;
		public static var mainMenu:MainMenu;
		public static var creditsMenu:CreditsMenu;
		
		public static function Init(s:Stage, g:Game):void
		{
			stage = s;
			game = g;
			mainMenu = new MainMenu();
			creditsMenu = new CreditsMenu();
		}
		
		// Menu creation functions
		public static function createMainMenu():void
		{
			clearStage();
			stage.addChild(mainMenu);
		}
		
		// Event functions
		public static function onStartClick(event:MouseEvent):void
		{
			clearStage();
			game.startLevel("");
		}
		
		public static function onCreditsClick(event:MouseEvent):void
		{
			clearStage();
			stage.addChild(creditsMenu);
		}
		
		public static function onMainMenuClick(event:MouseEvent):void
		{
			clearStage();
			stage.addChild(mainMenu);
		}
		
		// Util functions
		public static function getMenuTitle(text:String, topPadding:int, size:int):TextField
		{
			var title:TextField = new TextField();
			title.text = text;
			title.width = Constants.SCREEN_WIDTH;
			title.y = topPadding;
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.font = Constants.MENU_FONT;
			titleFormat.size = size;
			titleFormat.align = Constants.MENU_TITLE_ALIGNMENT;
			
			title.setTextFormat(titleFormat);
			
			return title;
		}
		
		public static function getMenuButtonShape():Shape
		{
			var buttonShape:Shape = new Shape();
			buttonShape.graphics.lineStyle(Constants.MENU_BUTTON_BORDER_SIZE, Constants.MENU_BUTTON_BORDER_COLOR);
			buttonShape.graphics.beginFill(Constants.MENU_BUTTON_COLOR);
			buttonShape.graphics.drawRect(0, 0, Constants.MENU_BUTTON_WIDTH, Constants.MENU_BUTTON_HEIGHT);
			buttonShape.graphics.endFill();
			return buttonShape;
		}
	
		public static function getMenuButtonTextFormat():TextFormat
		{
			var buttonTextFormat:TextFormat = new TextFormat();
			buttonTextFormat.font = Constants.MENU_FONT;
			buttonTextFormat.size = Constants.MENU_BUTTON_FONT_SIZE;
			buttonTextFormat.align = Constants.MENU_BUTTON_TEXT_ALIGNMENT;
			return buttonTextFormat;
		}
		
		public static function getMenuButton(text:String, x:int, y:int, listener:Function):SimpleButton
		{
			var buttonText:TextField = new TextField();
			buttonText.text = text;
			buttonText.setTextFormat(Menu.getMenuButtonTextFormat());
			
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(Menu.getMenuButtonShape());
			buttonSprite.addChild(buttonText);
			
			var button:SimpleButton = new SimpleButton();
			button.upState = buttonSprite;
			button.downState = buttonSprite;
			button.overState = buttonSprite;
			button.hitTestState = buttonSprite
			button.x = x;
			button.y = y;
			
			button.addEventListener(MouseEvent.CLICK, listener);
			
			return button;
		}
		
		public static function clearStage():void
		{
			while(stage.numChildren > 0)
			{
				stage.removeChildAt(0);
			}
		}
	}

}
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import Constants;
import flash.display.Sprite;

class MainMenu extends Sprite
{
	private var title:TextField;
	private var startButton:SimpleButton;
	private var levelSelectButton:SimpleButton;
	private var creditsButton:SimpleButton;
	
	public function MainMenu():void
	{
		// Main title
		title = Menu.getMenuTitle(Constants.GAME_TITLE,
		Constants.MAIN_TITLE_TOP_PADDING,
		Constants.MAIN_TITLE_FONT_SIZE);
		
		// Start button
		startButton = Menu.getMenuButton(Constants.START_BUTTON_TEXT,
		(Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
		Constants.SCREEN_HEIGHT / 2,
		Menu.onStartClick);
		
		// Level select button
		levelSelectButton = Menu.getMenuButton(Constants.LEVEL_SELECT_BUTTON_TEXT,
		(Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
		startButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
		Menu.onStartClick);
		
		// Credits button		
		creditsButton = Menu.getMenuButton(Constants.CREDITS_BUTTON_TEXT,
		Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH - Constants.MAIN_CREDITS_BUTTON_RIGHT_PADDING,
		Constants.SCREEN_HEIGHT - Constants.MAIN_CREDITS_BUTTON_BOTTOM_PADDING,
		Menu.onCreditsClick);

		// Adding everything
		addChild(title);
		addChild(startButton);
		addChild(levelSelectButton);
		addChild(creditsButton);
	}
}

class CreditsMenu extends Sprite
{
	private var mainMenuButton:SimpleButton;
	private var title:TextField;
	private var credits:TextField;
	
	public function CreditsMenu():void
	{
		// Main menu button
		mainMenuButton = Menu.getMenuButton("Main Menu", 20, 20, Menu.onMainMenuClick);
		
		// Credits title
		title = Menu.getMenuTitle(Constants.CREDITS_TITLE_TEXT,
		Constants.CREDITS_TITLE_TOP_PADDING,
		Constants.CREDITS_TITLE_FONT_SIZE);
		
		// Credits
		credits = new TextField();
		credits.text = Constants.CREDITS;
		credits.height = Constants.CREDITS_HEIGHT;
		credits.width = Constants.CREDITS_WIDTH;
		credits.x = (Constants.SCREEN_WIDTH - Constants.CREDITS_WIDTH) / 2;
		credits.y = Constants.CREDITS_TOP_PADDING;
		
		var creditsFormat:TextFormat = new TextFormat();
		creditsFormat.font = Constants.MENU_FONT;
		creditsFormat.size = Constants.CREDITS_FONT_SIZE;
		
		credits.setTextFormat(creditsFormat);
		
		addChild(mainMenuButton);
		addChild(title);
		addChild(credits);
	}
}