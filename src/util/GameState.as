package util {
import flash.net.SharedObject;
import flash.text.TextField;
import flash.text.TextFormat;

import util.Stopwatch;

/**
 * ...
 * @author Panji Wisesa
 */
public class GameState {
    private static var saveable:Boolean;
    private static var playerData:SharedObject;
    private static var game:Game;

    private static var playerRecordGameText:TextField = new TextField();
    private static var playerRecordGameDefaultTextFormat:TextFormat = new TextFormat();

    private static var playerRecordEndLevelText:TextField = new TextField();
    private static var playerRecordEndLevelDefaultTextFormat:TextFormat = new TextFormat();

    public static function Init(progressionFileName:String, g:Game):void {
        game = g;
        try {
            playerData = SharedObject.getLocal(progressionFileName);
			//playerData.clear(); // uncomment if save data is corrupted
            saveable = true;
            if (!playerData.data.hasOwnProperty("unlocked") ||
                    !playerData.data.hasOwnProperty("progress") ||
                    !playerData.data.hasOwnProperty("personalRecords") ||
                    !playerData.data.hasOwnProperty("mute")) {
                resetProgress();
            }

            playerRecordGameText.text = Constants.PLAYER_RECORD_TIME_GAME_DEFAULT_TEXT + Constants.STOPWATCH_DEFAULT_TIME;
            playerRecordGameDefaultTextFormat.font = Constants.MENU_FONT;
            playerRecordGameDefaultTextFormat.size = Constants.PLAYER_RECORD_TIME_GAME_FONT_SIZE;
            playerRecordGameDefaultTextFormat.align = Constants.PLAYER_RECORD_TIME_GAME_TEXT_ALIGNMENT;
            playerRecordGameText.setTextFormat(playerRecordGameDefaultTextFormat);

            playerRecordEndLevelText.text = Constants.PLAYER_RECORD_TIME_END_LEVEL_DEFAULT_TEXT + Constants.STOPWATCH_DEFAULT_TIME;
            playerRecordEndLevelText.width = Constants.SCREEN_WIDTH;
            playerRecordEndLevelDefaultTextFormat.font = Constants.MENU_FONT;
            playerRecordEndLevelDefaultTextFormat.size = Constants.PLAYER_RECORD_TIME_END_LEVEL_FONT_SIZE;
            playerRecordEndLevelDefaultTextFormat.align = Constants.PLAYER_RECORD_TIME_END_LEVEL_TEXT_ALIGNMENT;
            playerRecordEndLevelText.setTextFormat(playerRecordGameDefaultTextFormat);
        } catch (e:Error) {
            saveable = false;
        }
    }

    public static function openNextLevelSave():void {
        if (saveable) {
            playerData.data.progress = game.currLevelIndex + 1;
            if (playerData.data.progress == game.progression.length) {
                playerData.data.progress--;
            }
            if (playerData.data.unlocked < playerData.data.progress + 1) {
                playerData.data.unlocked = playerData.data.progress + 1;
            }
            if (Stopwatch.getCurrentTiming() < playerData.data.personalRecords[game.currLevelIndex]) {
                playerData.data.personalRecords[game.currLevelIndex] = Stopwatch.getCurrentTiming();
            }
            playerData.flush();
        }
    }

    public static function currentLevelSave():void {
        if (saveable) {
            playerData.data.progress = game.currLevelIndex;
            if (playerData.data.progress == game.progression.length) {
                playerData.data.progress--;
            }
            if (playerData.data.unlocked < playerData.data.progress + 1) {
                playerData.data.unlocked = playerData.data.progress + 1;
            }
            playerData.flush();
        }
    }

    public static function muteSave(mute:Boolean):void {
        if (saveable) {
            playerData.data.mute = mute;
            playerData.flush();
        }
    }

    public static function getPlayerLetestProgress():int {
        if (saveable) {
            return playerData.data.progress;
        }
        return 0;
    }

    public static function getPlayerOverallProgress():int {
        if (saveable) {
            return playerData.data.unlocked;
        }
        return 1;
    }

    public static function getPlayerRecord(level:int):int {
        if (saveable) {
            return playerData.data.personalRecords[level];
        }
        return Constants.STOPWATCH_DEFAULT_TIME;
    }

    public static function getPlayerRecordGameTextField(level:int):TextField {
        if (saveable) {
            playerRecordGameText.text = Constants.PLAYER_RECORD_TIME_GAME_DEFAULT_TEXT + Stopwatch.formatTiming(getPlayerRecord(level));
            playerRecordGameText.setTextFormat(playerRecordGameDefaultTextFormat);
            return playerRecordGameText;
        }
        return new TextField();
    }

    public static function getPlayerRecordEndLevelTextField(level:int):TextField {
        if (saveable) {
            var playerRecordText:String = Constants.PLAYER_RECORD_TIME_END_LEVEL_DEFAULT_TEXT + Stopwatch.formatTiming(getPlayerRecord(level));
            if (Stopwatch.getCurrentTiming() == playerData.data.personalRecords[game.currLevelIndex]) {
                playerRecordText += Constants.PLAYER_RECORD_TIME_END_LEVEL_NEW_RECORD_TEXT;
            }
            playerRecordEndLevelText.text = playerRecordText;
            playerRecordEndLevelText.setTextFormat(playerRecordEndLevelDefaultTextFormat);
            return playerRecordEndLevelText;
        }
        return new TextField();
    }

    public static function getPlayerMuteOption():Boolean {
        return playerData.data.mute;
    }

    public static function resetProgress():void {
        playerData.clear();
        playerData.data.unlocked = 1;
        playerData.data.progress = 0;
        var personalRecords:Array = new Array();
        for (var i:int = 0; i < game.progression.length; i++) {
            personalRecords.push(Constants.STOPWATCH_DEFAULT_TIME);
        }
        playerData.data.personalRecords = personalRecords;
        playerData.data.mute = false;
        playerData.flush();
    }
}

}