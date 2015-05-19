package util {

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

    public function PlayState(p:Player, gs:Object, bs:Object, cs:Array) {
        player = p.clone();
        gateStatus = ObjectUtil.copy(gs);
        buttonStatus = ObjectUtil.copy(bs);
        crates = new Dictionary();
        for each (var c:Crate in cs) {
            var t:Object = new Object();
            t.x = c.asset.x;
            t.y = c.asset.y;
            t.dy = c.dy;
            crates[c] = t;
        }
    }
}

}