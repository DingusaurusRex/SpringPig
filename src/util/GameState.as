package util {
import flash.net.SharedObject;

/**
 * ...
 * @author Panji Wisesa
 */
public class GameState {
    private static var saveable:Boolean;
    private static var playerData:SharedObject;
    private static var game:Game;

    public static function Init(progressionFileName:String, g:Game):void {
        game = g;
        try {
            playerData = SharedObject.getLocal(progressionFileName);
            saveable = true;
            if (!playerData.data.hasOwnProperty("unlocked")) {
                playerData.data.unlocked = 1;
                playerData.data.progress = 0;
                var personalRecords:Array = new Array();
                for (var i:int = 0; i < game.progression.length; i++) {
                    personalRecords.push(Constants.STOPWATCH_DEFAULT_TIME);
                }
                playerData.data.personalRecords = personalRecords;
                playerData.data.mute = false;
            }
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
        playerData.data.mute = mute;
        playerData.flush();
    }

    public static function getPlayerLetestProgress():int {
        if (saveable) {
            return playerData.data.progress;
        }
        return -1;
    }

    public static function getPlayerOverallProgress():int {
        if (saveable) {
            return playerData.data.unlocked;
        }
        return -1;
    }

    public static function getPlayerRecord(level:int):int {
        return playerData.data.personalRecords[level];
    }

    public static function getPlayerMuteOption():Boolean {
        return playerData.data.mute;
    }
}

}