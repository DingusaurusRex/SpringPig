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
    private static var muteButton:SimpleButton;
    private static var instructions:TextField;
    private static var state:int;

    // TODO: Background
    public static function Init(s:Stage, g:Game):void {
        stage = s;
        game = g;
        mainMenu = new MainMenu();
        creditsMenu = new CreditsMenu();
        levelSelectMenu = new LevelSelectMenu();
        pauseMenu = new PauseMenu();
        endLevelMenu = new EndLevelMenu();
        endGameMenu = new EndGameMenu();
        muteButton = Audio.muteButton;

        // Instructions
        instructions = Menu.getTextField(Constants.INSTRUCTIONS,
                Constants.INSTRUCTIONS_HEIGHT,
                Constants.INSTRUCTIONS_WIDTH,
                Constants.INSTRUCTIONS_LEFT_PADDING,
                Constants.INSTRUCTIONS_TOP_PADDING,
                Constants.MENU_FONT,
                Constants.INSTRUCTIONS_FONT_SIZE,
                Constants.INSTRUCTIONS_ALIGNMENT);

        state = 0;
    }

    // Menu creation/deletion functions
    public static function createMainMenu():void {
        stage.removeChildren();
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, game.onKeyDown); // Need to do this whenever leaving game state
        state = Constants.STATE_MAIN_MENU;
        mainMenu.addChild(muteButton);
        mainMenu.addChild(instructions);
        stage.addChild(mainMenu);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.focus = stage;
    }

    public static function createPauseMenu():void {
        Stopwatch.pause();
        state = Constants.STATE_PAUSE_MENU;
        pauseMenu.addChild(muteButton);
        pauseMenu.addChild(instructions);
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
        state = Constants.STATE_END_LEVEL_MENU;
        endLevelMenu.addChild(muteButton);
        stage.addChild(endLevelMenu);
        Stopwatch.stopwatchMenuText.x = Constants.END_LEVEL_STOPWATCH_LEFT_PADDING;
        Stopwatch.stopwatchMenuText.y = Constants.END_LEVEL_STOPWATCH_TOP_PADDING;
        stage.addChild(Stopwatch.stopwatchMenuText);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.focus = stage;
    }

    public static function createEndGameMenu():void {
        stage.removeChildren();
        state = Constants.STATE_END_GAME_MENU;
        stage.addChild(endGameMenu);
        Stopwatch.stopwatchMenuText.x = Constants.END_GAME_STOPWATCH_LEFT_PADDING;
        Stopwatch.stopwatchMenuText.y = Constants.END_GAME_STOPWATCH_TOP_PADDING;
        stage.addChild(Stopwatch.stopwatchMenuText);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.focus = stage;
    }

    public static function createLevelSelectMenu():void {
        stage.removeChildren();
        levelSelectMenu.regeneratePages();
        state = Constants.STATE_LEVEL_SELECT_MENU;
        stage.addChild(levelSelectMenu);
        stage.focus = stage;
    }

    public static function createCreditsMenu():void {
        stage.removeChildren();
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, game.onKeyDown); // Need to do this whenever leaving game state
        state = Constants.STATE_CREDITS_MENU;
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
        game.startFirstLevel();
    }

    public static function startNextLevel():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.removeChild(endLevelMenu);
        state = Constants.STATE_GAME;
        game.startNextLevel();
    }

    public static function restartLevel():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, Menu.onKeyDown);
        stage.removeChild(endLevelMenu);
        state = Constants.STATE_GAME;
        game.restartLevel();
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
                        continueGame();
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
                }
                break;
            case Constants.STATE_END_LEVEL_MENU:
                switch (key) {
                    case Keyboard.SPACE:
                        startNextLevel();
                        break;
                    case Keyboard.R:
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
            case Constants.STATE_PAUSE_MENU:
                switch (key) {
                    case Keyboard.E:
                        removePauseMenu();
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
        var buttonShape:Shape = new Shape();
        buttonShape.graphics.lineStyle(Constants.MENU_BUTTON_BORDER_SIZE, Constants.MENU_BUTTON_BORDER_COLOR);
        buttonShape.graphics.beginFill(Constants.MENU_BUTTON_COLOR);
        buttonShape.graphics.drawRect(0, 0, Constants.MENU_BUTTON_WIDTH, Constants.MENU_BUTTON_HEIGHT);
        buttonShape.graphics.endFill();
        return buttonShape;
    }

    public static function getMenuButtonTextFormat():TextFormat {
        var buttonTextFormat:TextFormat = new TextFormat();
        buttonTextFormat.font = Constants.MENU_FONT;
        buttonTextFormat.size = Constants.MENU_BUTTON_FONT_SIZE;
        buttonTextFormat.align = Constants.MENU_BUTTON_TEXT_ALIGNMENT;
        return buttonTextFormat;
    }

    public static function getMenuButton(text:String, x:int, y:int, listener:Function):SimpleButton {
        var buttonText:TextField = new TextField();
        buttonText.text = text;
        buttonText.width = Constants.MENU_BUTTON_WIDTH;
        buttonText.height = Constants.MENU_BUTTON_HEIGHT + Constants.MENU_BUTTON_BORDER_SIZE;
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

    public static function getTextField(text:String, height:int, width:int, x:int, y:int, font:String, fontSize:int, align:String):TextField {
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
        textFormat.align = align;

        textField.setTextFormat(textFormat);

        return textField;
    }
}

}

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.text.TextField;

import util.GameState;

class MainMenu extends Sprite {
    private var title:TextField;
    private var continueButton:SimpleButton;
    private var continueButtonCover:Sprite;
    private var blocked:Boolean;
    private var startButton:SimpleButton;
    private var levelSelectButton:SimpleButton;
    private var creditsButton:SimpleButton;

    public function MainMenu():void {
        // Main title
        title = Menu.getMenuTitle(Constants.GAME_TITLE,
                Constants.MAIN_TITLE_TOP_PADDING,
                Constants.MAIN_TITLE_FONT_SIZE);

        // Continue button
        continueButton = Menu.getMenuButton(Constants.CONTINUE_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        Constants.SCREEN_HEIGHT / 2,
                Menu.onContinueClick);

        // Cover for the continue button
        continueButtonCover = new Sprite();
        continueButtonCover.graphics.beginFill(Constants.CONTINUE_BUTTON_COVER_COLOR, Constants.CONTINUE_BUTTON_COVER_OPACITY);
        continueButtonCover.graphics.drawRect(0, 0, continueButton.width, continueButton.height);
        continueButtonCover.graphics.endFill();
        continueButtonCover.x = continueButton.x - Constants.MENU_BUTTON_BORDER_SIZE;
        continueButtonCover.y = continueButton.y - Constants.MENU_BUTTON_BORDER_SIZE;
        continueButtonCover.height = continueButton.height;
        continueButtonCover.width = continueButton.width;

        // Start button
        startButton = Menu.getMenuButton(Constants.START_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        continueButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
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
        addChild(continueButton);
        addChild(startButton);
        addChild(levelSelectButton);
        addChild(creditsButton);

        if (GameState.getPlayerLetestProgress() == 0) {
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
}

class PauseMenu extends Sprite {
    private var title:TextField;
    private var resumeButton:SimpleButton;
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

class EndLevelMenu extends Sprite {
    private var title:TextField;
    private var nextLevelButton:SimpleButton;
    private var restartLevelButton:SimpleButton;
    private var mainMenuButton:SimpleButton;

    public function EndLevelMenu():void {
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

        addChild(title);
        addChild(nextLevelButton);
        addChild(restartLevelButton);
        addChild(mainMenuButton);
    }
}

class EndGameMenu extends Sprite {
    private var title:TextField;
    private var subtitle:TextField;
    private var creditsButton:SimpleButton;
    private var mainMenuButton:SimpleButton;

    public function EndGameMenu():void {
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
                        Constants.SCREEN_HEIGHT / 2,
                Menu.onCreditsClick);

        // Main menu button
        mainMenuButton = Menu.getMenuButton(Constants.MAIN_MENU_BUTTON_TEXT,
                        (Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH) / 2,
                        creditsButton.y + Constants.MENU_BUTTON_PADDING_BETWEEN,
                Menu.onMainMenuClick);

        addChild(title);
        addChild(subtitle);
        addChild(creditsButton);
        addChild(mainMenuButton);
    }
}

class LevelSelectMenu extends Sprite {
    private var mainMenuButton:SimpleButton;
    private var title:TextField;

    private var previousPageButton:SimpleButton;
    private var nextPageButton:SimpleButton;
    private var currentPage:int;

    private var pages:Array;
    private var totalPages:int;

    public function LevelSelectMenu():void {
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

        var levels:int = GameState.getPlayerOverallProgress();
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
                    var levelButton:SimpleButton = Menu.getMenuButton(Menu.game.progression[l],
                                    Constants.SCREEN_WIDTH * (c + 1) / (Constants.LEVEL_SELECT_COLUMNS + 1) - Constants.MENU_BUTTON_WIDTH / 2,
                                    Constants.LEVEL_SELECT_PAGE_TOP_PADDING + pageHeight * r / Constants.LEVEL_SELECT_ROWS,
                            Menu.onLevelClick);
                    levelButton.name = String(l);

                    page.addChild(levelButton);
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
    private var mainMenuButton:SimpleButton;
    private var title:TextField;
    private var credits:TextField;

    public function CreditsMenu():void {
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

        addChild(mainMenuButton);
        addChild(title);
        addChild(credits);
    }
}