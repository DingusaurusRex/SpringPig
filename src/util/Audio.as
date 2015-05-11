package util {
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * ...
 * @author Panji Wisesa
 */
public class Audio {
    [Embed(source = "../../assets/sounds/Spring Pig Loop.mp3")]
    private static var BGM1:Class;

    private static var BGMSound:Sound;
    private static var BGMChannel:SoundChannel;

    private static var defaultTransform:SoundTransform;

    public static var mute:Boolean;
    private static var muteButtonText:TextField;
    private static var muteButtonTextFormat:TextFormat;
    private static var muteButtonShape:Shape;
    private static var muteButtonSprite:Sprite;
    public static var muteButton:SimpleButton;
    private static var muteTransform:SoundTransform;

    public static function Init():void {
        mute = false;
        muteButtonText = new TextField();
        muteButtonText.text = Constants.MUTE_BUTTON_TEXT + "Off";
        muteButtonText.width = Constants.MENU_BUTTON_WIDTH;
        muteButtonTextFormat = Menu.getMenuButtonTextFormat();
        muteButtonText.setTextFormat(muteButtonTextFormat);

        muteButtonShape = Menu.getMenuButtonShape();

        muteButtonSprite = new Sprite();
        muteButtonSprite.addChild(muteButtonShape);
        muteButtonSprite.addChild(muteButtonText);

        muteButton = new SimpleButton();
        muteButton.upState = muteButtonSprite;
        muteButton.downState = muteButtonSprite;
        muteButton.overState = muteButtonSprite;
        muteButton.hitTestState = muteButtonSprite;
        muteButton.x = Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH - Constants.MUTE_BUTTON_RIGHT_PADDING;
        muteButton.y = Constants.MUTE_BUTTON_TOP_PADDING;

        muteButton.addEventListener(MouseEvent.CLICK, onMuteClick);

        muteTransform = new SoundTransform();
        muteTransform.volume = 0;

        defaultTransform = new SoundTransform();
        defaultTransform.volume = 1;

        BGMSound = (new BGM1()) as Sound;
        BGMChannel = BGMSound.play(0, int.MAX_VALUE);
    }

    public static function flipMute():void {
        mute = !mute;
        if (mute) {
            SoundMixer.soundTransform = muteTransform;
            muteButtonText.text = Constants.MUTE_BUTTON_TEXT + "On";
        } else {
            SoundMixer.soundTransform = defaultTransform;
            muteButtonText.text = Constants.MUTE_BUTTON_TEXT + "Off";
        }
        muteButtonText.setTextFormat(muteButtonTextFormat);
    }

    public static function onMuteClick(event:MouseEvent):void {
        Audio.flipMute();
    }
}

}