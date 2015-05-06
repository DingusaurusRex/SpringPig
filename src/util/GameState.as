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
        try {
            playerData = SharedObject.getLocal(progressionFileName);
            saveable = true;
            if (playerData.data.unlocked == 0) {
                playerData.data.unlocked = 1;
            }
        } catch (e:Error) {
            saveable = false;
        }
        game = g;
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
            //trace("onl cl:" + playerData.data.progress + "; op:" + playerData.data.unlocked);
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
            //trace("cls cl:" + playerData.data.progress + "; op:" + playerData.data.unlocked);
            playerData.flush();
        }
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
}

}