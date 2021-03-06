package {
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;

import util.Audio;
import util.GameState;
import util.Stopwatch;
import util.Stopwatch;

/**
 * ...
 * @author Panji Wisesa
 */
public class Menu {
    public static var stage:Stage;
    public static var game:Game;
    public static var mainMenu:MainMenu;
    public static var creditsMenu:CreditsMenu;
    public static var levelSelectMenu:LevelSelectMenu;
    public static var pauseMenu:PauseMenu;
    public static var endLevelMenu:EndLevelMenu;
    public static var endGameMenu:EndGameMenu;
    public static var recordsMenu:RecordsMenu;
    private static var muteButton:SimpleButton;
    private static var menuInstructions:TextField;
    public static var gameInstructions:TextField;
    private static var previousRecord:TextField;
    private static var playthroughTip:TextField;
    private static var playthroughTime:TextField;
    private static var playthroughTimeTextFormat:TextFormat;
    private static var calculations:TextField;
    private static var highScoreIndicator:TextField;
    public static var state:int;

    public static var rewindInstructions:TextField;

    public static var fullPlaythrough:Boolean;
    public static var playthroughFinished:Boolean;
    public static var totalTime:int;

    [Embed(source = "../assets/art/background/SplashScreenPig.svg")]
    public static var mainMenuLogoArt:Class;

    [Embed(source = "../assets/art/background/WinBackground.svg")]
    public static var endLevelBackgroundArt:Class;
	
	[Embed(source = "../assets/art/background/WinGameBackground.svg")]
    public static var endGameBackgroundArt:Class;

	[Embed(source = "../assets/art/Buttons/button.svg")]
    public static var mainMenuButtonBackgroundArt:Class;

	[Embed(source = "../assets/art/Buttons/halfButton.svg")]
    public static var menuButtonBackgroundArt:Class;

	[Embed(source = "../assets/art/Buttons/buttonCover.svg")]
    public static var mainMenuButtonCoverArt:Class;

	[Embed(source = "../assets/art/Buttons/halfButtonCover.svg")]
    public static var menuButtonCoverArt:Class;

    [Embed(source="../assets/art/background/gameBackground.svg")]
    public static var menuBackgroundArt:Class;

    /**
     * Licensed under the SIL Open Font License, Version 1.1.
     * Copy of license is included in the repo and the bottom of this file
     * also available at: http://scripts.sil.org/OFL
     */
    [Embed(source="../assets/fonts/BreeSerif-Regular.otf",
            fontName = "breeSerif",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="false")]
    public static var fontBreeSerif:Class;


    public static function Init(s:Stage, g:Game):void {
        stage = s;
        game = g;
        mainMenu = new MainMenu();
        creditsMenu = new CreditsMenu();
        levelSelectMenu = new LevelSelectMenu();
        pauseMenu = new PauseMenu();
        endLevelMenu = new EndLevelMenu();
        endGameMenu = new EndGameMenu();
        recordsMenu = new RecordsMenu();
        muteButton = Audio.muteButton;

        // Instructions
        menuInstructions = Menu.getTextField(Constants.INSTRUCTIONS_MENU,
                Constants.INSTRUCTIONS_MENU_HEIGHT,
                Constants.INSTRUCTIONS_MENU_WIDTH,
                Constants.INSTRUCTIONS_MENU_LEFT_PADDING,
                Constants.INSTRUCTIONS_MENU_TOP_PADDING,
                Constants.MENU_FONT,
                Constants.INSTRUCTIONS_MENU_FONT_SIZE,
                Constants.INSTRUCTIONS_ALIGNMENT);

        gameInstructions = Menu.getTextField(Constants.INSTRUCTIONS_GAME,
                Constants.INSTRUCTIONS_GAME_HEIGHT,
                Constants.INSTRUCTIONS_GAME_WIDTH,
                Constants.INSTRUCTIONS_GAME_RIGHT_PADDING,
                Constants.SCREEN_HEIGHT - Constants.INSTRUCTIONS_GAME_HEIGHT - Constants.INSTRUCTIONS_GAME_BOTTOM_PADDING,
                Constants.MENU_FONT,
                Constants.INSTRUCTIONS_GAME_FONT_SIZE,
                Constants.INSTRUCTIONS_ALIGNMENT);

        playthroughTip = getTextField(Constants.TOTAL_TIME_TIP_TEXT,
                Constants.TOTAL_TIME_TIP_HEIGHT,
                Constants.SCREEN_WIDTH,
                0,
                        Constants.SCREEN_HEIGHT - Constants.TOTAL_TIME_TIP_BOTTOM_PADDING,
                Constants.MENU_FONT,
                Constants.TOTAL_TIME_TIP_FONT_SIZE,
                Constants.TOTAL_TIME_TIP_ALIGNMENT);

        playthroughTime = getTextField(Constants.TOTAL_TIME_TEXT + Constants.STOPWATCH_DEFAULT_TEXT,
                Constants.TOTAL_TIME_HEIGHT,
                Constants.SCREEN_WIDTH,
                0,
                        Constants.SCREEN_HEIGHT - Constants.TOTAL_TIME_BOTTOM_PADDING,
                Constants.MENU_FONT,
                Constants.TOTAL_TIME_FONT_SIZE,
                Constants.TOTAL_TIME_ALIGNMENT);
        playthroughTimeTextFormat = playthroughTime.getTextFormat();
		
        rewindInstructions = getTextField(Constants.REWIND_INSTRUCTION_TEXT,
                Constants.REWIND_INSTRUCTION_HEIGHT,
                Constants.REWIND_INSTRUCTION_WIDTH,
                Constants.SCREEN_WIDTH - Constants.REWIND_INSTRUCTION_RIGHT_PADDING - Constants.REWIND_INSTRUCTION_WIDTH,
                Constants.SCREEN_HEIGHT - Constants.REWIND_INSTRUCTION_HEIGHT - Constants.REWIND_INSTRUCTION_BOTTOM_PADDING,
                Constants.MENU_FONT,
                Constants.REWIND_INSTRUCTION_FONT_SIZE,
                Constants.REWIND_INSTRUCTION_ALIGNMENT,
                Constants.IN_GAME_TEXT_COLOR);

        highScoreIndicator = Menu.getTextField(Constants.END_LEVEL_SCORING_BEST_TOTAL_TEXT,
                Constants.END_LEVEL_SCORING_HIGH_SCORE_INDICATOR_HEIGHT,
                Constants.SCREEN_WIDTH,
                        0,
                        Constants.END_LEVEL_SCORING_TOP_PADDING + Constants.END_LEVEL_SCORING_HEIGHT,
                Constants.MENU_FONT,
                Constants.END_LEVEL_SCORING_FONT_SIZE,
                Constants.END_LEVEL_SCORING_HIGH_SCORE_INDICATOR_TEXT_ALIGNMENT);

        state = 0;

        fullPlaythrough = false;
        playthroughFinished = false;
        totalTime = 0;
    }

    // Menu creation/deletion functions
    public static function createMainMenu():void {
        stage.removeChildren();
        fullPlaythrough = false;
        playthroughFinished = false;
        totalTime = 0;
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, game.onKeyDown); // Need to do this whenever leaving game state
        state = Constants.STATE_MAIN_MENU;
        muteButton.x = Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH * 2 - Constants.MAIN_CREDITS_BUTTON_RIGHT_PADDING - Constants.MAIN_MENU_MUTE_BUTTON_RIGHT_PADDING;
        muteButton.y = Constants.SCREEN_HEIGHT - Constants.MAIN_MENU_MUTE_BUTTON_BOTTOM_PADDING;
        mainMenu.addChild(muteButton);
        //mainMenu.addChild(menuInstructions);
        stage.addChild(mainMenu);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.focus = stage;
    }

    public static function createPauseMenu():void {
        Stopwatch.pause();
        state = Constants.STATE_PAUSE_MENU;
        muteButton.x = Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH - Constants.MUTE_BUTTON_RIGHT_PADDING;
        muteButton.y = Constants.MUTE_BUTTON_TOP_PADDING;
        pauseMenu.addChild(muteButton);
        pauseMenu.addChild(menuInstructions);
        stage.addChild(pauseMenu);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.focus = stage;
    }

    public static function removePauseMenu():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.removeChild(pauseMenu);
        state = Constants.STATE_GAME;
        game.pause = false; // For leaving pause menu using button
        Stopwatch.start();
        stage.focus = stage;
    }

    public static function createEndLevelMenu():void {
        stage.removeChildren();
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, game.onKeyDown); // Need to do this whenever leaving game state
        state = Constants.STATE_END_LEVEL_MENU;
        muteButton.x = Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH - Constants.MUTE_BUTTON_RIGHT_PADDING;
        muteButton.y = Constants.MUTE_BUTTON_TOP_PADDING;
        endLevelMenu.addChild(muteButton);
        stage.addChild(endLevelMenu);
        /*
        if (fullPlaythrough) {
            stage.addChild(Menu.playthroughTime);
        } else {
            stage.addChild(playthroughTip);
        }*/
        stage.addChild(playthroughTip);
        Stopwatch.stopwatchMenuText.x = Constants.END_LEVEL_STOPWATCH_LEFT_PADDING;
        Stopwatch.stopwatchMenuText.y = Constants.END_LEVEL_STOPWATCH_TOP_PADDING;
		previousRecord = GameState.getPlayerRecordEndLevelTextField(game.currLevelIndex);
        previousRecord.x = Stopwatch.stopwatchMenuText.x;
        previousRecord.y = Stopwatch.stopwatchMenuText.y + Constants.PLAYER_RECORD_TIME_END_LEVEL_TOP_PADDING;
		//stage.addChild(Stopwatch.stopwatchMenuText);
        //stage.addChild(previousRecord);
        calculations = Menu.getTextField(
                Constants.END_LEVEL_SCORING_TIME_TEXT + Stopwatch.formatScoreTiming(Stopwatch.getCurrentTiming()) + "\tX 10\n" +
                Constants.END_LEVEL_SCORING_SPRING_TEXT + game.totalSuccessfulSprings + "\tX 1000\n" +
                Constants.END_LEVEL_SCORING_TOTAL_TEXT + game.highScore + "\n",
                Constants.END_LEVEL_SCORING_HEIGHT,
                Constants.END_LEVEL_SCORING_WIDTH,
                (Constants.SCREEN_WIDTH - Constants.END_LEVEL_SCORING_WIDTH) / 2,
                Constants.END_LEVEL_SCORING_TOP_PADDING,
                Constants.MENU_FONT,
                Constants.END_LEVEL_SCORING_FONT_SIZE,
                Constants.END_LEVEL_SCORING_TEXT_ALIGNMENT);
        if (game.highScore == GameState.getPlayerHighScore(game.currLevelIndex)) {
            stage.addChild(highScoreIndicator);
        }
        stage.addChild(calculations);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.focus = stage;
    }

    public static function createEndGameMenu():void {
        stage.removeChildren();
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, game.onKeyDown); // Need to do this whenever leaving game state
        state = Constants.STATE_END_GAME_MENU;
        stage.addChild(endGameMenu);
        /*
        if (fullPlaythrough) {
            stage.addChild(Menu.playthroughTime);
        } else {
            stage.addChild(playthroughTip);
        }*/
        stage.addChild(playthroughTip);
        Stopwatch.stopwatchMenuText.x = Constants.END_GAME_STOPWATCH_LEFT_PADDING;
        Stopwatch.stopwatchMenuText.y = Constants.END_GAME_STOPWATCH_TOP_PADDING;
        previousRecord = GameState.getPlayerRecordEndLevelTextField(game.currLevelIndex);
        previousRecord.x = Stopwatch.stopwatchMenuText.x;
        previousRecord.y = Stopwatch.stopwatchMenuText.y + Constants.PLAYER_RECORD_TIME_END_LEVEL_TOP_PADDING;
        //stage.addChild(Stopwatch.stopwatchMenuText);
        //stage.addChild(previousRecord);
        calculations = Menu.getTextField(
                        Constants.END_LEVEL_SCORING_TIME_TEXT + Stopwatch.formatScoreTiming(Stopwatch.getCurrentTiming()) + "\tX 10\n" +
                        Constants.END_LEVEL_SCORING_SPRING_TEXT + game.totalSuccessfulSprings + "\tX 1000\n" +
                        Constants.END_LEVEL_SCORING_TOTAL_TEXT + game.highScore + "\n",
                Constants.END_LEVEL_SCORING_HEIGHT,
                Constants.END_LEVEL_SCORING_WIDTH,
                        (Constants.SCREEN_WIDTH - Constants.END_LEVEL_SCORING_WIDTH) / 2,
                Constants.END_LEVEL_SCORING_TOP_PADDING,
                Constants.MENU_FONT,
                Constants.END_LEVEL_SCORING_FONT_SIZE,
                Constants.END_LEVEL_SCORING_TEXT_ALIGNMENT);
        if (game.highScore == GameState.getPlayerHighScore(game.currLevelIndex)) {
            stage.addChild(highScoreIndicator);
        }
        stage.addChild(calculations);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.focus = stage;
    }

    public static function updatePlaythroughTime():void {
        if (fullPlaythrough) {
            if (game.currLevelIndex == game.progression.length - 1) {
                playthroughFinished = true;
            }
            totalTime += Stopwatch.getCurrentTiming();
            Menu.playthroughTime.text = Constants.TOTAL_TIME_TEXT + Stopwatch.formatTiming(totalTime);
            Menu.playthroughTime.setTextFormat(Menu.playthroughTimeTextFormat);
            mainMenu.updateBestPlaythroughTime();
        }
    }

    public static function removeBestPlaythroughTime():void {
        mainMenu.removeBestPlaythroughTime();
    }

    public static function createLevelSelectMenu():void {
        stage.removeChildren();
        levelSelectMenu.regeneratePages();
        state = Constants.STATE_LEVEL_SELECT_MENU;
        stage.addChild(levelSelectMenu);
        stage.focus = stage;
    }

    public static function createRecordsMenu():void {
        stage.removeChildren();
        recordsMenu.regeneratePages();
        state = Constants.STATE_TIME_RECORDS_MENU;
        stage.addChild(recordsMenu);
        stage.focus = stage;
    }

    public static function createCreditsMenu():void {
        stage.removeChildren();
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, game.onKeyDown); // Need to do this whenever leaving game state
        state = Constants.STATE_CREDITS_MENU;
        creditsMenu.enableResetProgress();
        stage.addChild(creditsMenu);
        stage.focus = stage;
    }

    public static function continueGame():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.removeChildren();
        state = Constants.STATE_GAME;
        game.startAtLevel(GameState.getPlayerLetestProgress());
    }

    public static function startGame():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.removeChildren();
        mainMenu.enableContinue();
        state = Constants.STATE_GAME;
        fullPlaythrough = true;
        totalTime = 0;
        game.startFirstLevel();
    }

    public static function startNextLevel():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.removeChild(endLevelMenu);
        //stage.removeChild(Stopwatch.stopwatchMenuText);
        //stage.removeChild(previousRecord);
        state = Constants.STATE_GAME;
        /*
        if (fullPlaythrough) {
            stage.removeChild(playthroughTime);
        } else {
            stage.removeChild(playthroughTip);
        }*/
        stage.removeChild(playthroughTip);
        stage.removeChild(calculations);
        if (game.highScore == GameState.getPlayerHighScore(game.currLevelIndex)) {
            stage.removeChild(highScoreIndicator);
        }
        game.startNextLevel();
    }

    public static function restartLevel():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.removeChild(endLevelMenu);
        //stage.removeChild(Stopwatch.stopwatchMenuText);
        //stage.removeChild(previousRecord);
        state = Constants.STATE_GAME;
        /*
        if (fullPlaythrough) {
            stage.removeChild(playthroughTime);
        } else {
            stage.removeChild(playthroughTip);
        }*/
        stage.removeChild(playthroughTip);
        stage.removeChild(calculations);
        if (game.highScore == GameState.getPlayerHighScore(game.currLevelIndex)) {
            stage.removeChild(highScoreIndicator);
        }
        fullPlaythrough = false;
        totalTime = 0;
        game.restartLevel();
    }

    public static function restartLevelFromPause():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.removeChild(pauseMenu);
        state = Constants.STATE_GAME;
        game.pause = false; // For leaving pause menu using button
        fullPlaythrough = false;
        totalTime = 0;
        game.restartLevel();
        stage.focus = stage;
    }

    public static function setPauseMenuLevelInfo(levelNumber:int, levelName:String):void {
        pauseMenu.setLevelInfo(levelNumber, levelName);
    }

    // Event functions
    public static function onContinueClick(event:MouseEvent):void {
        continueGame();
    }

    public static function onStartClick(event:MouseEvent):void {
        startGame();
    }

    public static function onLevelSelectClick(event:MouseEvent):void {
        createLevelSelectMenu();
    }

    public static function onRecordsClick(event:MouseEvent):void {
        createRecordsMenu();
    }

    public static function onCreditsClick(event:MouseEvent):void {
        createCreditsMenu();
    }

    public static function onMainMenuClick(event:MouseEvent):void {
        createMainMenu();
    }

    public static function onResumeClick(event:MouseEvent):void {
        removePauseMenu();
    }

    public static function onNextLevelClick(event:MouseEvent):void {
        startNextLevel()
    }

    public static function onRestartLevelClick(event:MouseEvent):void {
        restartLevel();
    }

    public static function onRestartLevelFromPauseClick(event:MouseEvent):void {
        restartLevelFromPause();
    }

    public static function onResetProgressClick(event:MouseEvent):void {
        creditsMenu.disableResetProgress();
        mainMenu.disableContinue();
        GameState.resetProgress();
    }

    public static function onLevelClick(event:MouseEvent):void {
        stage.removeChild(levelSelectMenu);
        state = Constants.STATE_GAME;
        game.startAtLevel(int(event.target.name));
    }

    // Keyboard controls
    private static function onKeyDown(event:KeyboardEvent):void {
        var key:uint = event.keyCode;
        switch (state) {
            case Constants.STATE_MAIN_MENU:
                switch (key) {
                    case Keyboard.SPACE:
                        if (!mainMenu.blocked) {
                            continueGame();
                        }
                        break;
                    case Keyboard.S:
                        startGame();
                        break;
                    case Keyboard.L:
                        createLevelSelectMenu();
                        break;
                    case Keyboard.C:
                        createCreditsMenu();
                        break;
                    case Keyboard.R:
                        createRecordsMenu();
                        break;
                }
                break;
            case Constants.STATE_END_LEVEL_MENU:
                switch (key) {
                    case Keyboard.SPACE:
                        startNextLevel();
                        break;
                    case Keyboard.Y:
                        restartLevel();
                        break;
                    case Keyboard.M:
                        createMainMenu();
                        break;
                }
                break;
            case Constants.STATE_END_GAME_MENU:
                switch (key) {
                    case Keyboard.M:
                        createMainMenu();
                        break;
                    case Keyboard.C:
                        createCreditsMenu();
                        break;
                }
                break;
            case Constants.STATE_CREDITS_MENU:
                switch (key) {
                    case Keyboard.M:
                        createMainMenu();
                        break;
                }
                break;
            case Constants.STATE_LEVEL_SELECT_MENU:
                switch (key) {
                    case Keyboard.M:
                        createMainMenu();
                        break;
                }
                break;
            case Constants.STATE_TIME_RECORDS_MENU:
                switch (key) {
                    case Keyboard.M:
                        createMainMenu();
                        break;
                }
                break;
            case Constants.STATE_PAUSE_MENU:
                switch (key) {
                    case Keyboard.E:
                        removePauseMenu();
                        break;
                    case Keyboard.Y:
                        restartLevelFromPause();
                        break;
                    case Keyboard.M:
                        createMainMenu();
                        break;
                }
        }
    }

    // Util functions
    public static function getMenuTitle(text:String, topPadding:int, size:int):TextField {
        var title:TextField = new TextField();
        title.embedFonts = true;
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

    public static function getMenuButtonShape():Shape {
        return getButtonShape(Constants.MENU_BUTTON_COLOR,
                Constants.MENU_BUTTON_WIDTH,
                Constants.MENU_BUTTON_HEIGHT,
                Constants.MENU_BUTTON_BORDER_COLOR,
                Constants.MENU_BUTTON_BORDER_SIZE);
    }

    public static function getMainMenuButtonShape():Shape {
        return getButtonShape(Constants.MAIN_MENU_BUTTON_COLOR,
                Constants.MAIN_MENU_BUTTON_WIDTH,
                Constants.MAIN_MENU_BUTTON_HEIGHT,
                Constants.MAIN_MENU_BUTTON_BORDER_COLOR,
                Constants.MAIN_MENU_BUTTON_BORDER_SIZE);
    }

    public static function getButtonShape(color:uint, width:int, height:int, borderColor:uint, borderSize:int):Shape {
        var buttonShape:Shape = new Shape();
        buttonShape.graphics.lineStyle(borderSize, borderColor);
        buttonShape.graphics.beginFill(color);
        buttonShape.graphics.drawRect(0, 0, width, height);
        buttonShape.graphics.endFill();
        return buttonShape;
    }

    public static function getMenuButtonBackground():Sprite {
        var buttonBackground:Sprite = new menuButtonBackgroundArt();
        buttonBackground.width = Constants.MENU_BUTTON_WIDTH + Constants.MENU_BUTTON_BORDER_SIZE;
        buttonBackground.height = Constants.MENU_BUTTON_HEIGHT + Constants.MENU_BUTTON_BORDER_SIZE;
        return buttonBackground;
    }

    public static function getMainMenuButtonBackground():Sprite {
        var buttonBackground:Sprite = new mainMenuButtonBackgroundArt();
        buttonBackground.width = Constants.MAIN_MENU_BUTTON_WIDTH + Constants.MAIN_MENU_BUTTON_BORDER_SIZE;
        buttonBackground.height = Constants.MAIN_MENU_BUTTON_HEIGHT + Constants.MAIN_MENU_BUTTON_BORDER_SIZE;
        return buttonBackground;
    }

    public static function getButtonBackground(width:int, height:int, borderSize:int):Sprite {
        var buttonBackground:Sprite = new menuButtonBackgroundArt();
        buttonBackground.width = width + borderSize;
        buttonBackground.height = height + borderSize;
        return buttonBackground;
    }

    public static function getMenuButtonTextFormat():TextFormat {
        return getTextFormat(Constants.MENU_BUTTON_FONT_SIZE, Constants.MENU_BUTTON_TEXT_ALIGNMENT);
    }

    public static function getTextFormat(size:int, align:String):TextFormat {
        var buttonTextFormat:TextFormat = new TextFormat();
        buttonTextFormat.font = Constants.MENU_FONT;
        buttonTextFormat.size = size;
        buttonTextFormat.align = align;
        return buttonTextFormat;
    }

    public static function getMenuButton(text:String, x:int, y:int, listener:Function):SimpleButton {
        return getButton(text,
                Menu.getMenuButtonTextFormat(),
                Constants.MENU_BUTTON_WIDTH,
                Constants.MENU_BUTTON_HEIGHT + Constants.MENU_BUTTON_BORDER_SIZE,
                Constants.MENU_BUTTON_TEXT_TOP_PADDING,
                x,
                y,
                Menu.getMenuButtonBackground(),
                listener);
    }

    public static function getButton(text:String, textFormat:TextFormat, textWidth:int, textHeight:int, textTopPadding:int, x:int, y:int, buttonBackground:Sprite, listener:Function):SimpleButton {
        var buttonText:TextField = new TextField();
        buttonText.embedFonts = true;
        buttonText.text = text;
        buttonText.width = textWidth;
        buttonText.height = textHeight;
        buttonText.y = textTopPadding;
        buttonText.setTextFormat(textFormat);

        var buttonSprite:Sprite = new Sprite();
        buttonSprite.addChild(buttonBackground);
        buttonSprite.addChild(buttonText);

        var button:SimpleButton = new SimpleButton();
        button.upState = buttonSprite;
        button.downState = buttonSprite;
        button.overState = buttonSprite;
        button.hitTestState = buttonSprite;
        button.x = x;
        button.y = y;

        button.addEventListener(MouseEvent.CLICK, listener);

        return button;
    }

    public static function getTextField(text:String, height:int, width:int, x:int, y:int, font:String, fontSize:int, align:String, textColor:uint = 0x000000):TextField {
        var textField:TextField = new TextField();
        textField.embedFonts = true;
        textField.text = text;
        textField.height = height;
        textField.width = width;
        textField.x = x;
        textField.y = y;
        textField.textColor = textColor;

        var textFormat:TextFormat = new TextFormat();
        textFormat.font = font;
        textFormat.size = fontSize;
        textFormat.align = align;

        textField.setTextFormat(textFormat);

        return textField;
    }
}

}

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import model.levelHandling.Board;
import model.levelHandling.LevelParser;

import util.GameState;
import util.Stopwatch;

class MainMenu extends Sprite {
    private var background:Sprite;
    private var logo:Sprite;
    private var title:TextField;
    private var continueButton:SimpleButton;
    private var continueButtonCover:Sprite;
    private var startButton:SimpleButton;
    private var levelSelectButton:SimpleButton;
    private var recordsButton:SimpleButton;
    private var creditsButton:SimpleButton;
    private var bestPlaythroughTime:TextField;
    private var bestPlaythroughTimeTextFormat:TextFormat;

    private var bestTime:int;

    public var blocked:Boolean;
	
    public function MainMenu():void {
        // Main menu background
        background = new Menu.menuBackgroundArt();
        background.width = Constants.SCREEN_WIDTH;
        background.height = Constants.SCREEN_HEIGHT;

        // Game logo
        logo = new Menu.mainMenuLogoArt();
		logo.x = Constants.MAIN_LOGO_LEFT_PADDING;
		logo.y = Constants.MAIN_LOGO_TOP_PADDING;
        logo.height = Constants.MAIN_LOGO_HEIGHT;
		logo.width = Constants.MAIN_LOGO_HEIGHT * Constants.MAIN_LOGO_RATIO;
		
        // Main title
        title = Menu.getMenuTitle(Constants.GAME_TITLE,
                Constants.MAIN_TITLE_TOP_PADDING,
                Constants.MAIN_TITLE_FONT_SIZE);

        // Continue button
        continueButton = Menu.getButton(Constants.CONTINUE_BUTTON_TEXT,
                Menu.getTextFormat(Constants.MAIN_MENU_BUTTON_FONT_SIZE, Constants.MAIN_MENU_BUTTON_TEXT_ALIGNMENT),
                Constants.MAIN_MENU_BUTTON_WIDTH,
                Constants.MAIN_MENU_BUTTON_TEXT_HEIGHT,
                (Constants.MAIN_MENU_BUTTON_HEIGHT - Constants.MAIN_MENU_BUTTON_TEXT_HEIGHT) / 2 + Constants.MAIN_MENU_BUTTON_TEXT_TOP_PADDING,
                Constants.SCREEN_WIDTH * 5 / 6 - Constants.MAIN_MENU_BUTTON_WIDTH / 2,
                Constants.SCREEN_HEIGHT / 6 - Constants.MAIN_MENU_BUTTON_HEIGHT / 2,
                Menu.getMainMenuButtonBackground(),
                Menu.onContinueClick);

        // Cover for the continue button
        continueButtonCover = new Menu.mainMenuButtonCoverArt();/*
        continueButtonCover.graphics.beginFill(Constants.CONTINUE_BUTTON_COVER_COLOR, Constants.CONTINUE_BUTTON_COVER_OPACITY);
        continueButtonCover.graphics.drawRect(0, 0, continueButton.width, continueButton.height);
        continueButtonCover.graphics.endFill();*/
        continueButtonCover.x = continueButton.x;
        continueButtonCover.y = continueButton.y;
        continueButtonCover.alpha = Constants.CONTINUE_BUTTON_COVER_OPACITY;
        continueButtonCover.height = continueButton.height;
        continueButtonCover.width = continueButton.width;

        // Start button
        startButton = Menu.getButton(Constants.START_BUTTON_TEXT,
                Menu.getTextFormat(Constants.MAIN_MENU_BUTTON_FONT_SIZE, Constants.MAIN_MENU_BUTTON_TEXT_ALIGNMENT),
                Constants.MAIN_MENU_BUTTON_WIDTH,
                Constants.MAIN_MENU_BUTTON_TEXT_HEIGHT,
                        (Constants.MAIN_MENU_BUTTON_HEIGHT - Constants.MAIN_MENU_BUTTON_TEXT_HEIGHT) / 2 + Constants.MAIN_MENU_BUTTON_TEXT_TOP_PADDING,
                        Constants.SCREEN_WIDTH * 5 / 6 - Constants.MAIN_MENU_BUTTON_WIDTH / 2,
                        continueButton.y + Constants.MAIN_MENU_BUTTON_HEIGHT + Constants.MAIN_MENU_BUTTON_PADDING_BETWEEN,
                Menu.getMainMenuButtonBackground(),
                Menu.onStartClick);

        // Level select button
        levelSelectButton = Menu.getButton(Constants.LEVEL_SELECT_BUTTON_TEXT,
                Menu.getTextFormat(Constants.MAIN_MENU_BUTTON_FONT_SIZE, Constants.MAIN_MENU_BUTTON_TEXT_ALIGNMENT),
                Constants.MAIN_MENU_BUTTON_WIDTH,
                Constants.MAIN_MENU_BUTTON_TEXT_HEIGHT,
                        (Constants.MAIN_MENU_BUTTON_HEIGHT - Constants.MAIN_MENU_BUTTON_TEXT_HEIGHT) / 2 + Constants.MAIN_MENU_BUTTON_TEXT_TOP_PADDING,
                        Constants.SCREEN_WIDTH * 5 / 6 - Constants.MAIN_MENU_BUTTON_WIDTH / 2,
                        startButton.y + Constants.MAIN_MENU_BUTTON_HEIGHT + Constants.MAIN_MENU_BUTTON_PADDING_BETWEEN,
                Menu.getMainMenuButtonBackground(),
                Menu.onLevelSelectClick);

        // Records button
        recordsButton = Menu.getButton(Constants.TIME_RECORDS_BUTTON_TEXT,
                Menu.getTextFormat(Constants.MAIN_MENU_BUTTON_FONT_SIZE, Constants.MAIN_MENU_BUTTON_TEXT_ALIGNMENT),
                Constants.MAIN_MENU_BUTTON_WIDTH,
                Constants.MAIN_MENU_BUTTON_TEXT_HEIGHT,
                        (Constants.MAIN_MENU_BUTTON_HEIGHT - Constants.MAIN_MENU_BUTTON_TEXT_HEIGHT) / 2 + Constants.MAIN_MENU_BUTTON_TEXT_TOP_PADDING,
                        Constants.SCREEN_WIDTH * 5 / 6 - Constants.MAIN_MENU_BUTTON_WIDTH / 2,
                        levelSelectButton.y + Constants.MAIN_MENU_BUTTON_HEIGHT + Constants.MAIN_MENU_BUTTON_PADDING_BETWEEN,
                Menu.getMainMenuButtonBackground(),
                Menu.onRecordsClick);

        // Credits button
        creditsButton = Menu.getMenuButton(Constants.CREDITS_BUTTON_TEXT,
                        Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH - Constants.MAIN_CREDITS_BUTTON_RIGHT_PADDING,
                        Constants.SCREEN_HEIGHT - Constants.MAIN_CREDITS_BUTTON_BOTTOM_PADDING,
                Menu.onCreditsClick);

        // Best playthrough time
        bestTime = GameState.getPlayerBestPlaythroughTime();
        bestPlaythroughTime = Menu.getTextField(Constants.BEST_TOTAL_TIME_TEXT + Stopwatch.formatTiming(bestTime),
                Constants.BEST_TOTAL_TIME_HEIGHT,
                Constants.BEST_TOTAL_TIME_WIDTH,
                        Constants.SCREEN_WIDTH * 5 / 6 - Constants.BEST_TOTAL_TIME_WIDTH / 2,
                        recordsButton.y + Constants.MAIN_MENU_BUTTON_HEIGHT + Constants.MAIN_MENU_BUTTON_PADDING_BETWEEN,
                Constants.MENU_FONT,
                Constants.BEST_TOTAL_TIME_FONT_SIZE,
                Constants.BEST_TOTAL_TIME_ALIGNMENT);
        bestPlaythroughTimeTextFormat = bestPlaythroughTime.getTextFormat();

        // Adding everything
        addChild(background);
        addChild(logo);
        //addChild(title);
        addChild(continueButton);
        addChild(startButton);
        addChild(levelSelectButton);
        addChild(recordsButton);
        addChild(creditsButton);
        if (bestTime != Constants.STOPWATCH_DEFAULT_TIME) {
            //addChild(bestPlaythroughTime);
        }

        if (GameState.getPlayerLetestProgress() == 0) {
            disableContinue();
        }
    }

    public function disableContinue():void {
        if (!blocked) {
            continueButton.enabled = false;
            continueButton.mouseEnabled = false;
            addChild(continueButtonCover);
            blocked = true;
        }
    }

    public function enableContinue():void {
        if (blocked) {
            continueButton.enabled = true;
            continueButton.mouseEnabled = true;
            removeChild(continueButtonCover);
            blocked = false;
        }
    }

    public function updateBestPlaythroughTime():void {
        if (Menu.fullPlaythrough &&
                Menu.playthroughFinished &&
                (Menu.totalTime < bestTime || bestTime == Constants.STOPWATCH_DEFAULT_TIME)) {
            bestTime = Menu.totalTime;
            bestPlaythroughTime.text = Constants.BEST_TOTAL_TIME_TEXT + Stopwatch.formatTiming(bestTime);
            bestPlaythroughTime.setTextFormat(bestPlaythroughTimeTextFormat);
            //addChild(bestPlaythroughTime);
        }
    }

    public function removeBestPlaythroughTime():void {
        //addChild(bestPlaythroughTime);
        //removeChild(bestPlaythroughTime);
    }
}

class PauseMenu extends Sprite {
    private var title:TextField;
    private var levelInfo:TextField;
    private var levelInfoFormat:TextFormat;
    private var resumeButton:SimpleButton;
    private var restartLevelButton:SimpleButton;
    private var mainMenuButton:SimpleButton;

    public function PauseMenu():void {
        // Background
        this.graphics.beginFill(Constants.PAUSE_BACKGROUND_COLOR, Constants.PAUSE_BACKGROUND_OPACITY);
        this.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
        this.graphics.endFill();

        // Pause title
        title = Menu.getMenuTitle(Constants.PAUSE_TITLE_TEXT,
                Constants.PAUSE_TITLE_TOP_PADDING,
                Constants.PAUSE_TITLE_FONT_SIZE);

        // Level info
        levelInfo = Menu.getTextField(Constants.PAUSE_LEVEL_INFO_TEXT,
                Constants.PAUSE_LEVEL_INFO_HEIGHT,
                Constants.SCREEN_WIDTH,
                0,
                        title.y + title.height + Constants.PAUSE_LEVEL_INFO_TOP_PADDING,
                Constants.MENU_FONT,
                Constants.PAUSE_LEVEL_INFO_FONT_SIZE,
                Constants.PAUSE_LEVEL_INFO_ALIGNMENT);
        levelInfoFormat = levelInfo.getTextFormat();

        // Resume button
        resumeButton = Menu.getMenuButton(Constants.PAUSE_RESUME_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        Constants.SCREEN_HEIGHT / 2,
                Menu.onResumeClick);

        // Restart level button
        restartLevelButton = Menu.getMenuButton(Constants.PAUSE_RESTART_LEVEL_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        resumeButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
                Menu.onRestartLevelFromPauseClick);

        // Main menu button
        mainMenuButton = Menu.getMenuButton(Constants.MAIN_MENU_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        restartLevelButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
                Menu.onMainMenuClick);

        addChild(title);
        addChild(resumeButton);
        addChild(restartLevelButton);
        addChild(mainMenuButton);
    }

    public function setLevelInfo(levelNumber:int, levelName:String):void {
        levelInfo.text = Constants.PAUSE_LEVEL_INFO_TEXT + levelNumber + ": " + levelName;
        levelInfo.setTextFormat(levelInfoFormat);
        addChild(levelInfo);
    }
}

class EndLevelMenu extends Sprite {
    private var background:Sprite;
    private var title:TextField;
    private var nextLevelButton:SimpleButton;
    private var restartLevelButton:SimpleButton;
    private var mainMenuButton:SimpleButton;
	
    public function EndLevelMenu():void {
        // Game logo
        background = new Menu.endLevelBackgroundArt();
        background.x = 0;
        background.y = 0;
        background.height = Constants.SCREEN_HEIGHT;
        background.width = Constants.SCREEN_WIDTH;

        // End level title
        title = Menu.getMenuTitle(Constants.END_LEVEL_TITLE_TEXT,
                Constants.END_LEVEL_TITLE_TOP_PADDING,
                Constants.END_LEVEL_TITLE_FONT_SIZE);

        // Next level button
        nextLevelButton = Menu.getMenuButton(Constants.END_LEVEL_NEXT_LEVEL_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        Constants.SCREEN_HEIGHT / 2,
                Menu.onNextLevelClick);

        // Restart level button
        restartLevelButton = Menu.getMenuButton(Constants.END_LEVEL_RESTART_LEVEL_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        nextLevelButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
                Menu.onRestartLevelClick);

        // Main menu button
        mainMenuButton = Menu.getMenuButton(Constants.END_LEVEL_MAIN_MENU_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        restartLevelButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
                Menu.onMainMenuClick);

        addChild(background);
        //addChild(title);
        addChild(nextLevelButton);
        addChild(restartLevelButton);
        addChild(mainMenuButton);
    }
}

class EndGameMenu extends Sprite {
    private var background:Sprite;
    private var title:TextField;
    private var subtitle:TextField;
    private var creditsButton:SimpleButton;
    private var mainMenuButton:SimpleButton;
	
    public function EndGameMenu():void {
        // Game logo
        background = new Menu.endGameBackgroundArt();
        background.x = 0;
        background.y = 0;
        background.height = Constants.SCREEN_HEIGHT;
        background.width = Constants.SCREEN_WIDTH;

        // End level title
        title = Menu.getMenuTitle(Constants.END_GAME_TITLE_TEXT,
                Constants.END_GAME_TITLE_TOP_PADDING,
                Constants.END_GAME_TITLE_FONT_SIZE);

        // End level subtitle
        subtitle = Menu.getMenuTitle(Constants.END_GAME_SUBTITLE_TEXT,
                Constants.END_GAME_SUBTITLE_TOP_PADDING,
                Constants.END_GAME_SUBTITLE_FONT_SIZE);

        // Credits button
        creditsButton = Menu.getMenuButton(Constants.CREDITS_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        Constants.SCREEN_HEIGHT / 2 + Constants.END_LEVEL_CREDITS_BUTTON_TOP_PADDING,
                Menu.onCreditsClick);

        // Main menu button
        mainMenuButton = Menu.getMenuButton(Constants.MAIN_MENU_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        creditsButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
                Menu.onMainMenuClick);

        addChild(background);
        //addChild(title);
        //addChild(subtitle);
        addChild(creditsButton);
        addChild(mainMenuButton);
    }
}

class LevelSelectMenu extends Sprite {
    private var background:Sprite;
    private var backgroundCover:Sprite;
    private var mainMenuButton:SimpleButton;
    private var title:TextField;

    private var previousPageButton:SimpleButton;
    private var nextPageButton:SimpleButton;
    private var currentPage:int;

    private var pages:Array;
    private var totalPages:int;
	
    public function LevelSelectMenu():void {
        // Background
        background = new Menu.menuBackgroundArt();
        background.width = Constants.SCREEN_WIDTH;
        background.height = Constants.SCREEN_HEIGHT;

        // Background cover
        backgroundCover = new Sprite();
        backgroundCover.graphics.beginFill(Constants.MENU_BACKGROUND_COVER_COLOR, Constants.MENU_BACKGROUND_COVER_OPACITY);
        backgroundCover.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
        backgroundCover.graphics.endFill();

        // Main menu button
        mainMenuButton = Menu.getMenuButton(Constants.MAIN_MENU_BUTTON_TEXT,
                Constants.MAIN_MENU_BUTTON_TOP_PADDING,
                Constants.MAIN_MENU_BUTTON_LEFT_PADDING,
                Menu.onMainMenuClick);

        // Level Select title
        title = Menu.getMenuTitle(Constants.LEVEL_SELECT_TITLE_TEXT,
                Constants.LEVEL_SELECT_TITLE_TOP_PADDING,
                Constants.LEVEL_SELECT_TITLE_FONT_SIZE);

        // Page buttons
        previousPageButton = Menu.getMenuButton(Constants.LEVEL_SELECT_PREVIOUS_PAGE_BUTTON_TEXT,
                        Constants.SCREEN_WIDTH / Constants.LEVEL_SELECT_COLUMNS - Constants.MENU_BUTTON_WIDTH / 2,
                        Constants.SCREEN_HEIGHT - Constants.LEVEL_SELECT_PAGE_BUTTON_BOTTOM_PADDING,
                onPreviousPageClick);

        nextPageButton = Menu.getMenuButton(Constants.LEVEL_SELECT_NEXT_PAGE_BUTTON_TEXT,
                        Constants.SCREEN_WIDTH * (Constants.LEVEL_SELECT_COLUMNS - 1) / Constants.LEVEL_SELECT_COLUMNS - Constants.MENU_BUTTON_WIDTH / 2,
                        Constants.SCREEN_HEIGHT - Constants.LEVEL_SELECT_PAGE_BUTTON_BOTTOM_PADDING,
                onNextPageClick);
    }

    public function regeneratePages():void {
        removeChildren();
        addChild(background);
        addChild(backgroundCover);

        var levels:int = GameState.getPlayerOverallProgress();
        if (Constants.SHOW_ALL_LEVELS) {
            levels = Menu.game.progression.length;
        }
        var levelsPerPage:int = Constants.LEVEL_SELECT_ROWS * Constants.LEVEL_SELECT_COLUMNS;
        totalPages = levels / levelsPerPage;
        if (levels % levelsPerPage != 0) {
            totalPages++;
        }

        var pageHeight:int = Constants.SCREEN_HEIGHT - Constants.LEVEL_SELECT_PAGE_TOP_PADDING - Constants.LEVEL_SELECT_PAGE_BUTTON_BOTTOM_PADDING;
        pages = new Array();

        var l:int = 0;
        var p:int;
        var r:int;
        var c:int;
        PageCreation: for (p = 0; p < totalPages; p++) {
            var page:Sprite = new Sprite();
            LevelAddition:for (r = 0; r < Constants.LEVEL_SELECT_ROWS; r++) {
                for (c = 0; c < Constants.LEVEL_SELECT_COLUMNS; c++) {
                    var x:int = Constants.SCREEN_WIDTH * (c + 1) / (Constants.LEVEL_SELECT_COLUMNS + 1) - Constants.LEVEL_SELECT_BUTTON_WIDTH / 2;
                    var y:int = Constants.LEVEL_SELECT_PAGE_TOP_PADDING + pageHeight * r / Constants.LEVEL_SELECT_ROWS;
					var levelReader:LevelParser = new LevelParser();
					var board:Board = levelReader.parseLevel(Menu.game.progression[l]);
                    var levelButton:SimpleButton = Menu.getButton(board.name,
                            Menu.getMenuButtonTextFormat(),
                            Constants.LEVEL_SELECT_BUTTON_WIDTH,
                                    Constants.LEVEL_SELECT_BUTTON_HEIGHT + Constants.LEVEL_SELECT_BUTTON_BORDER_SIZE,
                            Constants.MENU_BUTTON_TEXT_TOP_PADDING,
                            x,
                            y,
                            Menu.getButtonBackground(Constants.LEVEL_SELECT_BUTTON_WIDTH,
                                    Constants.LEVEL_SELECT_BUTTON_HEIGHT,
                                    Constants.LEVEL_SELECT_BUTTON_BORDER_SIZE),
                            Menu.onLevelClick);
                    levelButton.name = String(l);

                    var levelRecord:TextField = Menu.getTextField(Constants.LEVEL_SELECT_HIGH_SCORE_TEXT + GameState.getPlayerHighScoreString(l),
                            Constants.LEVEL_SELECT_HIGH_SCORE_HEIGHT,
                            Constants.LEVEL_SELECT_BUTTON_WIDTH,
                            x,
                                    y + Constants.LEVEL_SELECT_BUTTON_HEIGHT + Constants.LEVEL_SELECT_HIGH_SCORE_TOP_PADDING,
                            Constants.MENU_FONT,
                            Constants.LEVEL_SELECT_HIGH_SCORE_FONT_SIZE,
                            Constants.LEVEL_SELECT_HIGH_SCORE_ALIGNMENT);
                    page.addChild(levelButton);
                    page.addChild(levelRecord);
                    l++;
                    if (l == levels) {
                        break LevelAddition;
                    }
                }
            }
            pages.push(page);
            if (l == levels) {
                break PageCreation;
            }
        }

        addChild(mainMenuButton);
        addChild(title);

        currentPage = 0;
        if (pages.length == 1) {
            addChild(pages[currentPage]);
        } else if (pages.length > 1) {
            addChild(pages[currentPage]);
            addChild(nextPageButton);
        }
    }

    private function onPreviousPageClick(event:MouseEvent):void {
        removeChild(pages[currentPage]);
        if (currentPage == totalPages - 1) {
            addChild(nextPageButton);
        }
        currentPage--;
        if (currentPage == 0) {
            removeChild(previousPageButton);
        }
        addChild(pages[currentPage]);
    }

    private function onNextPageClick(event:MouseEvent):void {
        removeChild(pages[currentPage]);
        if (currentPage == 0) {
            addChild(previousPageButton);
        }
        currentPage++;
        if (currentPage == totalPages - 1) {
            removeChild(nextPageButton);
        }
        addChild(pages[currentPage]);
    }
}

class RecordsMenu extends Sprite {
    private var background:Sprite;
    private var backgroundCover:Sprite;
    private var mainMenuButton:SimpleButton;
    private var title:TextField;

    private var previousPageButton:SimpleButton;
    private var nextPageButton:SimpleButton;
    private var currentPage:int;

    private var pages:Array;
    private var totalPages:int;
	
    public function RecordsMenu():void {
        // Background
        background = new Menu.menuBackgroundArt();
        background.width = Constants.SCREEN_WIDTH;
        background.height = Constants.SCREEN_HEIGHT;

        // Background cover
        backgroundCover = new Sprite();
        backgroundCover.graphics.beginFill(Constants.MENU_BACKGROUND_COVER_COLOR, Constants.MENU_BACKGROUND_COVER_OPACITY);
        backgroundCover.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
        backgroundCover.graphics.endFill();

        // Main menu button
        mainMenuButton = Menu.getMenuButton(Constants.MAIN_MENU_BUTTON_TEXT,
                Constants.MAIN_MENU_BUTTON_TOP_PADDING,
                Constants.MAIN_MENU_BUTTON_LEFT_PADDING,
                Menu.onMainMenuClick);

        // Record title
        title = Menu.getMenuTitle(Constants.RECORDS_TITLE_TEXT,
                Constants.RECORDS_TITLE_TOP_PADDING,
                Constants.RECORDS_TITLE_FONT_SIZE);

        // Page buttons
        previousPageButton = Menu.getMenuButton(Constants.RECORDS_PREVIOUS_PAGE_BUTTON_TEXT,
                        Constants.SCREEN_WIDTH / Constants.RECORDS_PAGE_BUTTON_COLUMNS - Constants.MENU_BUTTON_WIDTH / 2,
                        Constants.SCREEN_HEIGHT - Constants.RECORDS_PAGE_BUTTON_BOTTOM_PADDING,
                onPreviousPageClick);

        nextPageButton = Menu.getMenuButton(Constants.RECORDS_NEXT_PAGE_BUTTON_TEXT,
                        Constants.SCREEN_WIDTH * (Constants.RECORDS_PAGE_BUTTON_COLUMNS - 1) / Constants.RECORDS_PAGE_BUTTON_COLUMNS - Constants.MENU_BUTTON_WIDTH / 2,
                        Constants.SCREEN_HEIGHT - Constants.RECORDS_PAGE_BUTTON_BOTTOM_PADDING,
                onNextPageClick);
    }

    public function regeneratePages():void {
        removeChildren();
        addChild(background);
        addChild(backgroundCover);

        var levels:int = GameState.getPlayerOverallProgress();
        if (Constants.SHOW_ALL_LEVELS) {
            levels = Menu.game.progression.length;
        }
        var levelsPerPage:int = Constants.RECORDS_ROWS * Constants.RECORDS_COLUMNS;
        totalPages = levels / levelsPerPage;
        if (levels % levelsPerPage != 0) {
            totalPages++;
        }

        var pageHeight:int = Constants.SCREEN_HEIGHT - Constants.RECORDS_PAGE_TOP_PADDING - Constants.RECORDS_PAGE_BUTTON_BOTTOM_PADDING;
        pages = new Array();

        var l:int = 0;
        var p:int;
        var r:int;
        var c:int;
        PageCreation: for (p = 0; p < totalPages; p++) {
            var page:Sprite = new Sprite();
            LevelAddition:for (c = 0; c < Constants.RECORDS_COLUMNS; c++) {
                for (r = 0; r < Constants.RECORDS_ROWS; r++) {
                    var x:int = Constants.SCREEN_WIDTH * (c * 2 + 1) / (Constants.RECORDS_COLUMNS + 2) - Constants.RECORDS_TIME_RECORD_WIDTH / 2;
                    var y:int = Constants.RECORDS_PAGE_TOP_PADDING + pageHeight * r / Constants.RECORDS_ROWS;
					var levelReader:LevelParser = new LevelParser();
					var board:Board = levelReader.parseLevel(Menu.game.progression[l]);
                    var levelRecord:TextField = Menu.getTextField(board.name + Constants.RECORDS_TIME_RECORD_TEXT + GameState.getPlayerHighScoreString(l),
                            Constants.RECORDS_TIME_RECORD_HEIGHT,
                            Constants.RECORDS_TIME_RECORD_WIDTH,
                            x,
                            y,
                            Constants.MENU_FONT,
                            Constants.RECORDS_TIME_RECORD_FONT_SIZE,
                            Constants.RECORDS_TIME_RECORD_ALIGNMENT);
                    page.addChild(levelRecord);
                    l++;
                    if (l == levels) {
                        break LevelAddition;
                    }
                }
            }
            pages.push(page);
            if (l == levels) {
                break PageCreation;
            }
        }

        addChild(mainMenuButton);
        addChild(title);

        currentPage = 0;
        if (pages.length == 1) {
            addChild(pages[currentPage]);
        } else if (pages.length > 1) {
            addChild(pages[currentPage]);
            addChild(nextPageButton);
        }
    }

    private function onPreviousPageClick(event:MouseEvent):void {
        removeChild(pages[currentPage]);
        if (currentPage == totalPages - 1) {
            addChild(nextPageButton);
        }
        currentPage--;
        if (currentPage == 0) {
            removeChild(previousPageButton);
        }
        addChild(pages[currentPage]);
    }

    private function onNextPageClick(event:MouseEvent):void {
        removeChild(pages[currentPage]);
        if (currentPage == 0) {
            addChild(previousPageButton);
        }
        currentPage++;
        if (currentPage == totalPages - 1) {
            removeChild(nextPageButton);
        }
        addChild(pages[currentPage]);
    }
}


class CreditsMenu extends Sprite {
    private var background:Sprite;
    private var backgroundCover:Sprite;
    private var mainMenuButton:SimpleButton;
    private var title:TextField;
    private var credits:TextField;
    private var resetProgress:SimpleButton;
    private var resetProgressCover:Sprite;
	
    public function CreditsMenu():void {
        // Background
        background = new Menu.menuBackgroundArt();
        background.width = Constants.SCREEN_WIDTH;
        background.height = Constants.SCREEN_HEIGHT;

        // Background cover
        backgroundCover = new Sprite();
        backgroundCover.graphics.beginFill(Constants.MENU_BACKGROUND_COVER_COLOR, Constants.MENU_BACKGROUND_COVER_OPACITY);
        backgroundCover.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
        backgroundCover.graphics.endFill();

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
                Constants.CREDITS_FONT_SIZE,
                Constants.CREDITS_ALIGNMENT);
        credits.autoSize = TextFieldAutoSize.LEFT;

        // Reset progress
        resetProgress = Menu.getMenuButton(Constants.CREDITS_RESET_PROGRESS_BUTTON_TEXT,
                Constants.CREDITS_RESET_PROGRESS_BUTTON_LEFT_PADDING,
                Constants.SCREEN_HEIGHT - Constants.CREDITS_RESET_PROGRESS_BUTTON_BOTTOM_PADDING,
                Menu.onResetProgressClick);

        // Cover for the reset progress button
        resetProgressCover = new Menu.menuButtonCoverArt();/*
        resetProgressCover.graphics.beginFill(Constants.CONTINUE_BUTTON_COVER_COLOR, Constants.CONTINUE_BUTTON_COVER_OPACITY);
        resetProgressCover.graphics.drawRect(0, 0, resetProgress.width, resetProgress.height);
        resetProgressCover.graphics.endFill();*/
        resetProgressCover.x = resetProgress.x;
        resetProgressCover.y = resetProgress.y;
        resetProgressCover.alpha = Constants.CREDITS_RESET_PROGRESS_BUTTON_COVER_OPACITY;
        resetProgressCover.height = resetProgress.height - 1;
        resetProgressCover.width = resetProgress.width;

        addChild(background);
        addChild(backgroundCover);
        addChild(title);
        addChild(credits);
        addChild(mainMenuButton);
        addChild(resetProgress);
    }

    public function enableResetProgress():void {
        resetProgress.enabled = true;
        resetProgress.mouseEnabled = true;
        addChild(resetProgressCover);
        removeChild(resetProgressCover);
    }

    public function disableResetProgress():void {
        resetProgress.enabled = false;
        resetProgress.mouseEnabled = false;
        addChild(resetProgressCover);
    }
}

/**
 Copyright (c) 2011, TypeTogether (www.type-together.com),
 with Reserved Font Names "Bree" and "Bree Serif"

 This Font Software is licensed under the SIL Open Font License, Version 1.1.
 This license is copied below, and is also available with a FAQ at: http://scripts.sil.org/OFL

 -----------------------------------------------------------
 SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007
 -----------------------------------------------------------

 PREAMBLE
 The goals of the Open Font License (OFL) are to stimulate worldwide development of collaborative font projects, to support the font creation efforts of academic and linguistic communities, and to provide a free and open framework in which fonts may be shared and improved in partnership with others.

 The OFL allows the licensed fonts to be used, studied, modified and redistributed freely as long as they are not sold by themselves. The fonts, including any derivative works, can be bundled, embedded, redistributed and/or sold with any software provided that any reserved names are not used by derivative works. The fonts and derivatives, however, cannot be released under any other type of license. The requirement for fonts to remain under this license does not apply to any document created using the fonts or their derivatives.

 DEFINITIONS
 "Font Software" refers to the set of files released by the Copyright Holder(s) under this license and clearly marked as such. This may include source files, build scripts and documentation.

 "Reserved Font Name" refers to any names specified as such after the copyright statement(s).

 "Original Version" refers to the collection of Font Software components as distributed by the Copyright Holder(s).

 "Modified Version" refers to any derivative made by adding to, deleting, or substituting -- in part or in whole -- any of the components of the Original Version, by changing formats or by porting the Font Software to a new environment.

 "Author" refers to any designer, engineer, programmer, technical writer or other person who contributed to the Font Software.

 PERMISSION & CONDITIONS
 Permission is hereby granted, free of charge, to any person obtaining a copy of the Font Software, to use, study, copy, merge, embed, modify, redistribute, and sell modified and unmodified copies of the Font Software, subject to the following conditions:

 1) Neither the Font Software nor any of its individual components, in Original or Modified Versions, may be sold by itself.

 2) Original or Modified Versions of the Font Software may be bundled, redistributed and/or sold with any software, provided that each copy contains the above copyright notice and this license. These can be included either as stand-alone text files, human-readable headers or in the appropriate machine-readable metadata fields within text or binary files as long as those fields can be easily viewed by the user.

 3) No Modified Version of the Font Software may use the Reserved Font Name(s) unless explicit written permission is granted by the corresponding Copyright Holder. This restriction only applies to the primary font name as presented to the users.

 4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font Software shall not be used to promote, endorse or advertise any Modified Version, except to acknowledge the contribution(s) of the Copyright Holder(s) and the Author(s) or with their explicit written permission.

 5) The Font Software, modified or unmodified, in part or in whole, must be distributed entirely under this license, and must not be distributed under any other license. The requirement for fonts to remain under this license does not apply to any document created using the Font Software.

 TERMINATION
 This license becomes null and void if any of the above conditions are not met.

 DISCLAIMER
 THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM OTHER DEALINGS IN THE FONT SOFTWARE.
 */