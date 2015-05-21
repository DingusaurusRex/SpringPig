package util {

import flash.display.Sprite;
import flash.utils.Dictionary;

import model.player.Crate;

import model.player.Player;
import mx.utils.ObjectUtil;

/**
 * @author Panji Wisesa
 */
public class PlayState {
    public var player:Player;
    public var gateStatus:Object;
    public var buttonStatus:Object;
    public var crates:Dictionary;
    public var platforms:Dictionary;
    public var powerupUsed:IntPair;

    public function PlayState(p:Player, gs:Object, bs:Object, cs:Array, pls:Dictionary, puu:IntPair = null) {
        player = p.clone();
        gateStatus = ObjectUtil.copy(gs);
        buttonStatus = ObjectUtil.copy(bs);
        crates = new Dictionary();
        for each (var c:Crate in cs) {
            var tc:Object = new Object();
            tc.x = c.asset.x;
            tc.y = c.asset.y;
            tc.dy = c.dy;
            crates[c] = tc;
        }
        platforms = new Dictionary();
        for each (var pl:Sprite in pls) {
            var tp:Object = new Object();
            tp.x = pl.x;
            tp.y = pl.y;
            platforms[pl] = tp;
        }
        powerupUsed = puu;
        if (puu != null) {
            powerupUsed = puu.clone();
        }
    }
}

}