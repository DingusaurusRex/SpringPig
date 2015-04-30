package 
{
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Constants;
	/**
	 * ...
	 * @author Panji Wisesa
	 */
	public class Menu 
	{
		private var stage:Stage;
		
		private var game:Game;
		
		private var mainMenu:MainMenu;
		
		public function Menu(stage:Stage, game:Game) 
		{
			this.stage = stage;
			this.game = game;
			this.mainMenu = new MainMenu(this.game);
		}
		
		public function createMainMenu():void
		{
			stage.addChild(mainMenu);
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
	private var game:Game;
	
	private var title:TextField;
	private var startButton:SimpleButton;
	
	public function MainMenu(game:Game):void
	{
		this.game = game;
		
		title = new TextField();
		title.text = Constants.GAME_TITLE;
		title.width = Constants.SCREEN_WIDTH;
		title.y = Constants.MAIN_TITLE_TOP_PADDING;
		
		var titleFormat:TextFormat = new TextFormat();
		titleFormat.font = Constants.MENU_FONT;
		titleFormat.size = Constants.MAIN_TITLE_FONT_SIZE;
		titleFormat.align = Constants.MAIN_TITLE_ALIGNMENT;
		
		title.setTextFormat(titleFormat);
		
		var buttonShape:Shape = new Shape();
		buttonShape.graphics.beginFill(Constants.MENU_BUTTON_COLOR);
		buttonShape.graphics.drawRect(0, 0, Constants.MENU_BUTTON_WIDTH, Constants.MENU_BUTTON_HEIGHT);
		buttonShape.graphics.endFill();
		
		var buttonTextFormat:TextFormat = new TextFormat();
		buttonTextFormat.font = Constants.MENU_FONT;
		buttonTextFormat.size = Constants.MENU_BUTTON_FONT_SIZE;
		buttonTextFormat.align = Constants.MENU_BUTTON_TEXT_ALIGNMENT;
		
		
		
		var startButtonText:TextField = new TextField();
		startButtonText.text = Constants.START_BUTTON_TEXT;
		startButtonText.setTextFormat(buttonTextFormat);
		
		var startButtonSprite:Sprite = new Sprite();
		startButtonSprite.addChild(buttonShape);
		startButtonSprite.addChild(startButtonText);
		
		startButton = new SimpleButton();
		startButton.upState = startButtonSprite;
		startButton.downState = startButtonSprite;
		startButton.overState = startButtonSprite;
		startButton.hitTestState = startButtonSprite
		startButton.x = (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2;
		startButton.y = Constants.SCREEN_HEIGHT / 2;
		
		startButton.addEventListener(MouseEvent.CLICK, onStartClick);
		
		
		addChild(title);
		addChild(startButton);
	}
	
	private function onStartClick(event:MouseEvent):void
	{
		game.startLevel("");
	}
}