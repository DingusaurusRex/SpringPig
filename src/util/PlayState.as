package util {

import model.player.Player;
import mx.utils.ObjectUtil;

/**
	 * @author Panji Wisesa
	 */
	public class PlayState {
		public var player:Player;
        public var gateStatus:Object;
        public var buttonStatus:Object;

		public function PlayState(p:Player, gs:Object, bs:Object) {
			player = p.clone();
            gateStatus = ObjectUtil.copy(gs);
            buttonStatus = ObjectUtil.copy(bs);
		}

        public function printTrace():void {
            trace("saved: " + player.asset.x);
        }
		
	}

}