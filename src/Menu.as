package 
{
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import util.Audio;
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
		public static var levelSelectMenu:LevelSelectMenu;
		public static var pauseMenu:PauseMenu;
		private static var muteButton:SimpleButton;
		private static var instructions:TextField;
		
		// TODO: Background
		public static function Init(s:Stage, g:Game):void
		{
			stage = s;
			game = g;
			mainMenu = new MainMenu();
			creditsMenu = new CreditsMenu();
			levelSelectMenu = new LevelSelectMenu();
			pauseMenu = new PauseMenu();
			muteButton = Audio.muteButton;
			
			// Instructions
			instructions = Menu.getTextField(Constants.INSTRUCTIONS,
			Constants.INSTRUCTIONS_HEIGHT,
			Constants.INSTRUCTIONS_WIDTH,
			Constants.INSTRUCTIONS_LEFT_PADDING,
			Constants.INSTRUCTIONS_TOP_PADDING,
			Constants.MENU_FONT,
			Constants.INSTRUCTIONS_FONT_SIZE);
		}
		
		// Menu creation/deletion functions
		public static function createMainMenu():void
		{
			stage.removeChildren();
			mainMenu.addChild(muteButton);
			mainMenu.addChild(instructions);
			stage.addChild(mainMenu);
		}
		
		public static function createPauseMenu():void
		{
			pauseMenu.addChild(muteButton);
			pauseMenu.addChild(instructions);
			stage.addChild(pauseMenu);
		}
		
		public static function removePauseMenu():void
		{
			stage.removeChild(pauseMenu);
			game.pause = false; // For leaving pause menu using button
			stage.focus = stage;
		}
		
		// Event functions
		public static function onStartClick(event:MouseEvent):void
		{
			stage.removeChildren();
			game.startLevel("test1");
		}
		
		public static function onLevelSelectClick(event:MouseEvent):void
		{
			stage.removeChildren();
			stage.addChild(levelSelectMenu);
		}
		
		public static function onCreditsClick(event:MouseEvent):void
		{
			stage.removeChildren();
			stage.addChild(creditsMenu);
		}
		
		public static function onMainMenuClick(event:MouseEvent):void
		{
			createMainMenu();
		}
		
		public static function onResumeClick(event:MouseEvent):void
		{
			removePauseMenu();
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
		
		public static function getTextField(text:String, height:int, width:int, x:int, y:int, font:String, fontSize:int):TextField
		{
			var textField:TextField = new TextField();
			textField = new TextField();
			textField.text = text;
			textField.height = height;
			textField.width = width;
			textField.x = x;
			textField.y = y;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = font;
			textFormat.size = fontSize;
			
			textField.setTextFormat(textFormat);
			
			return textField;
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
		Menu.onLevelSelectClick);
		
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

class PauseMenu extends Sprite
{
	private var title:TextField;
	private var resumeButton:SimpleButton;
	private var mainMenuButton:SimpleButton;
	
	public function PauseMenu():void
	{
		// Background
		this.graphics.beginFill(Constants.PAUSE_BACKGROUND_COLOR, Constants.PAUSE_BACKGROUND_OPACITY);
		this.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
		this.graphics.endFill();
		
		// Pause title
		title = Menu.getMenuTitle(Constants.PAUSE_TITLE_TEXT,
		Constants.PAUSE_TITLE_TOP_PADDING,
		Constants.PAUSE_TITLE_FONT_SIZE);
		
		// Resume button
		resumeButton = Menu.getMenuButton(Constants.PAUSE_RESUME_BUTTON_TEXT,
		(Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
		Constants.SCREEN_HEIGHT / 2,
		Menu.onResumeClick);
		
		// Main menu button
		mainMenuButton = Menu.getMenuButton(Constants.MAIN_MENU_BUTTON_TEXT,
		(Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
		resumeButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
		Menu.onMainMenuClick);
		
		addChild(title);
		addChild(resumeButton);
		addChild(mainMenuButton);
	}
}

class LevelSelectMenu extends Sprite
{
	private var mainMenuButton:SimpleButton;
	private var title:TextField;
	
	public function LevelSelectMenu():void
	{
		// Main menu button
		mainMenuButton = Menu.getMenuButton(Constants.MAIN_MENU_BUTTON_TEXT,
		Constants.MAIN_MENU_BUTTON_TOP_PADDING,
		Constants.MAIN_MENU_BUTTON_LEFT_PADDING,
		Menu.onMainMenuClick);
		
		// Credits title
		title = Menu.getMenuTitle(Constants.LEVEL_SELECT_TITLE_TEXT,
		Constants.LEVEL_SELECT_TITLE_TOP_PADDING,
		Constants.LEVEL_SELECT_TITLE_FONT_SIZE);
		
		addChild(mainMenuButton);
		addChild(title);
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
		mainMenuButton = Menu.getMenuButton(Constants.MAIN_MENU_BUTTON_TEXT,
		Constants.MAIN_MENU_BUTTON_TOP_PADDING,
		Constants.MAIN_MENU_BUTTON_LEFT_PADDING,
		Menu.onMainMenuClick);
		
		// Credits title
		title = Menu.getMenuTitle(Constants.CREDITS_TITLE_TEXT,
		Constants.CREDITS_TITLE_TOP_PADDING,
		Constants.CREDITS_TITLE_FONT_SIZE);
		
		// Credits
		credits = Menu.getTextField(Constants.CREDITS,
		Constants.CREDITS_HEIGHT,
		Constants.CREDITS_WIDTH,
		(Constants.SCREEN_WIDTH - Constants.CREDITS_WIDTH) / 2,
		Constants.CREDITS_TOP_PADDING,
		Constants.MENU_FONT,
		Constants.CREDITS_FONT_SIZE);
		
		addChild(mainMenuButton);
		addChild(title);
		addChild(credits);
	}
}