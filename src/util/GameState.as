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

    private static var minSpringsGameText:TextField = new TextField();
    private static var minSpringsGameDefaultTextFormat:TextFormat = new TextFormat();

    public static function Init(progressionFileName:String, g:Game):void {
        game = g;
        try {
            playerData = SharedObject.getLocal(progressionFileName);
			//playerData.clear(); // uncomment if save data is corrupted
            saveable = true;
            if (!playerData.data.hasOwnProperty("unlocked") ||
                    !playerData.data.hasOwnProperty("progress") ||
                    !playerData.data.hasOwnProperty("personalRecords") ||
                    !playerData.data.hasOwnProperty("mute") ||
                    !playerData.data.hasOwnProperty("playthroughBest") ||
                    !playerData.data.hasOwnProperty("version") ||
                    !playerData.data.hasOwnProperty("springs") ||
                    !playerData.data.hasOwnProperty("scores")) {
                resetProgress(false);
            }

            playerRecordGameText.text = Constants.PLAYER_RECORD_TIME_GAME_DEFAULT_TEXT + Constants.STOPWATCH_DEFAULT_TIME;
            playerRecordGameText.embedFonts = true;
            playerRecordGameDefaultTextFormat.font = Constants.MENU_FONT;
            playerRecordGameDefaultTextFormat.size = Constants.PLAYER_RECORD_TIME_GAME_FONT_SIZE;
            playerRecordGameDefaultTextFormat.align = Constants.PLAYER_RECORD_TIME_GAME_TEXT_ALIGNMENT;
            playerRecordGameText.setTextFormat(playerRecordGameDefaultTextFormat);

            playerRecordEndLevelText.text = Constants.PLAYER_RECORD_TIME_END_LEVEL_DEFAULT_TEXT + Constants.STOPWATCH_DEFAULT_TIME;
            playerRecordEndLevelText.embedFonts = true;
            playerRecordEndLevelText.width = Constants.SCREEN_WIDTH;
            playerRecordEndLevelDefaultTextFormat.font = Constants.MENU_FONT;
            playerRecordEndLevelDefaultTextFormat.size = Constants.PLAYER_RECORD_TIME_END_LEVEL_FONT_SIZE;
            playerRecordEndLevelDefaultTextFormat.align = Constants.PLAYER_RECORD_TIME_END_LEVEL_TEXT_ALIGNMENT;
            playerRecordEndLevelText.setTextFormat(playerRecordGameDefaultTextFormat);

            minSpringsGameText.text = Constants.MIN_SPRING_GAME_DEFAULT_TEXT + Constants.MIN_SPRING_DEFAULT_TEXT;
            minSpringsGameText.embedFonts = true;
            minSpringsGameDefaultTextFormat.font = Constants.MENU_FONT;
            minSpringsGameDefaultTextFormat.size = Constants.MIN_SPRING_GAME_FONT_SIZE;
            minSpringsGameDefaultTextFormat.align = Constants.MIN_SPRING_GAME_TEXT_ALIGNMENT;
            minSpringsGameText.setTextFormat(minSpringsGameDefaultTextFormat);
        } catch (e:Error) {
            trace(e);
            trace(e.getStackTrace());
            saveable = false;
        }
    }

    public static function checkSaveFile(progressionFileName:String):Boolean {
        try {
            var data:SharedObject = SharedObject.getLocal(progressionFileName);
            if (!data.data.hasOwnProperty("unlocked") ||
                    !data.data.hasOwnProperty("progress") ||
                    !data.data.hasOwnProperty("personalRecords") ||
                    !data.data.hasOwnProperty("mute") ||
                    !data.data.hasOwnProperty("playthroughBest") ||
                    !data.data.hasOwnProperty("version") ||
                    !data.data.hasOwnProperty("springs") ||
                    !data.data.hasOwnProperty("scores")) {
                data.clear();
                return false;
            }
        } catch (e:Error) {
            trace(e);
            trace(e.getStackTrace());
            return false;
        }
        return true;
    }

    public static function clearSaveFile(progressionFileName:String):void {
        try {
            var data:SharedObject = SharedObject.getLocal(progressionFileName);
            data.clear();
        } catch (e:Error) {
            trace(e);
            trace(e.getStackTrace());
        }
    }

	/**
	 * Saves high score, time, springs for a given level
	 */
    public static function openNextLevelSave():void {
        if (saveable) {
            playerData.data.progress = game.currLevelIndex + 1;
            if (playerData.data.progress == game.progression.length) {
                playerData.data.progress--;
                if (Menu.fullPlaythrough &&
                        Menu.playthroughFinished &&
                        (Menu.totalTime < playerData.data.playthroughBest ||
                                playerData.data.playthroughBest == Constants.STOPWATCH_DEFAULT_TIME)) {
                    playerData.data.playthroughBest = Menu.totalTime;
                }
            }
            if (playerData.data.unlocked < playerData.data.progress + 1) {
                playerData.data.unlocked = playerData.data.progress + 1;
            }
            if (Stopwatch.getCurrentTiming() < playerData.data.personalRecords[game.currLevelIndex]) {
                playerData.data.personalRecords[game.currLevelIndex] = Stopwatch.getCurrentTiming();
            }
            if (game.totalSuccessfulSprings < playerData.data.springs[game.currLevelIndex]) {
                playerData.data.springs[game.currLevelIndex] = game.totalSuccessfulSprings;
            }
            if (game.highScore < playerData.data.scores[game.currLevelIndex]) {
                playerData.data.scores[game.currLevelIndex] = game.highScore;
            }
            playerData.flush();
        }
    }
	
	public static function sendHighScoresToKong(kongregate:*):void
	{
		var send:Boolean = true;
		var sum:int = 0;
		
		// LEVELS 1-10
		for (var i:int = 0; i <= 9; i++) {
			if (playerData.data.scores[i] == Constants.SCORES_DEFAULT_VALUE) {
				send = false;
				break;
			} else {
				sum += playerData.data.scores[i];
			}
		}
		if (send) {
			kongregate.stats.submit("Level 1 - 10 Score", sum);
		}
		
		// LEVELS 11-20
		send = true;
		sum = 0;
		for (i = 10; i <= 19; i++) {
			if (playerData.data.scores[i] == Constants.SCORES_DEFAULT_VALUE) {
				send = false;
				break;
			} else {
				sum += playerData.data.scores[i];
			}
		}
		if (send) {
			kongregate.stats.submit("Level 11 - 20 Score", sum);
		}
		
		// LEVELS 21-30
		send = true;
		sum = 0;
		for (i = 20; i <= 29; i++) {
			if (playerData.data.scores[i] == Constants.SCORES_DEFAULT_VALUE) {
				send = false;
				break;
			} else {
				sum += playerData.data.scores[i];
			}
		}
		if (send) {
			kongregate.stats.submit("Level 21 - 30 Score", sum);
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

    public static function getPlayerHighScore(level:int):int {
        if (saveable) {
            return playerData.data.scores[level];
        }
        return Constants.SCORES_DEFAULT_VALUE;
    }

    public static function getPlayerHighScoreString(level:int):String {
        if (saveable) {
            if (playerData.data.scores[level] == Constants.SCORES_DEFAULT_VALUE) {
                return Constants.SCORES_DEFAULT_TEXT;
            }
            return "" + playerData.data.scores[level];
        }
        return Constants.SCORES_DEFAULT_TEXT;
    }

    public static function getPlayerBestPlaythroughTime():int {
        if (saveable) {
            return playerData.data.playthroughBest;
        }
        return Constants.STOPWATCH_DEFAULT_TIME;
    }

    public static function getPlayerVersion():String {
        if (saveable) {
            return playerData.data.version;
        }
        return Constants.VERSION_A;
    }

    public static function savePlayerVersion(version:String):void {
        if (saveable) {
            playerData.data.version = version;
            playerData.flush();
        }
    }

    public static function getPlayerRecordGameTextField(level:int):TextField {
        if (saveable) {
            playerRecordGameText.text = Constants.PLAYER_RECORD_TIME_GAME_DEFAULT_TEXT + Stopwatch.formatTiming(getPlayerRecord(level));
            playerRecordGameText.width = Constants.PLAYER_RECORD_TIME_GAME_WIDTH;
            playerRecordGameText.setTextFormat(playerRecordGameDefaultTextFormat);
            return playerRecordGameText;
        }
        return new TextField();
    }

    public static function getMinSpringsGameTextField(level:int):TextField {
        if (saveable) {
            var springs:String = "" + playerData.data.springs[level];
            if (playerData.data.springs[level] == Constants.SPRINGS_DEFAULT_VALUE) {
                springs = Constants.MIN_SPRING_DEFAULT_TEXT;
            }
            minSpringsGameText.text = Constants.MIN_SPRING_GAME_DEFAULT_TEXT + springs;
            minSpringsGameText.width = Constants.MIN_SPRING_GAME_WIDTH;
            minSpringsGameText.setTextFormat(minSpringsGameDefaultTextFormat);
            return minSpringsGameText;
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

    public static function resetProgress(removeBestTimeText:Boolean = true):void {
        playerData.clear();
        playerData.data.unlocked = 1;
        playerData.data.progress = 0;
        var personalRecords:Array = new Array();
        var i:int = 0;
        for (i = 0; i < game.progression.length; i++) {
            personalRecords.push(Constants.STOPWATCH_DEFAULT_TIME);
        }
        playerData.data.personalRecords = personalRecords;
        playerData.data.mute = false;
        playerData.data.playthroughBest = Constants.STOPWATCH_DEFAULT_TIME;
        playerData.data.version = Constants.VERSION_NULL;
        var springs:Array = new Array();
        for (i = 0; i < game.progression.length; i++) {
            springs.push(Constants.SPRINGS_DEFAULT_VALUE);
        }
        playerData.data.springs = springs;
        var scores:Array = new Array();
        for (i = 0; i < game.progression.length; i++) {
            scores.push(Constants.SCORES_DEFAULT_VALUE);
        }
        playerData.data.scores = scores;
        playerData.flush();
        if (removeBestTimeText) {
            Menu.removeBestPlaythroughTime();
        }
    }
}

}