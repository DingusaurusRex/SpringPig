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
    [Embed(source = "../../assets/sounds/Spring Pig Loop (1).mp3")]
    private static var BGM1:Class;
    // http://www.freesfx.co.uk/
    [Embed(source = "../../assets/sounds/comedy_spring.mp3")]
    private static var SFXJump1:Class;
    [Embed(source = "../../assets/sounds/bounce_boing_32.mp3")]
    private static var SFXSpring1:Class;
    [Embed(source = "../../assets/sounds/bacon_frying.mp3")]
    private static var SFXDeath1:Class;
    [Embed(source = "../../assets/sounds/teleport.mp3")]
    private static var SFXReset1:Class;
    // http://www.freesound.org/people/fins/sounds/171671/
    [Embed(source = "../../assets/sounds/fins__success-1.mp3")]
    private static var SFXWin1:Class;

    private static var BGMSound:Sound;
    private static var BGMChannel:SoundChannel;

    private static var SFXTransform:SoundTransform;

    private static var SFXJumpSound:Sound;
    private static var SFXJumpSoundChannel:SoundChannel;

    private static var SFXSpringSound:Sound;
    private static var SFXSpringSoundChannel:SoundChannel;

    private static var SFXDeathSound:Sound;
    private static var SFXDeathSoundChannel:SoundChannel;

    private static var SFXResetSound:Sound;
    private static var SFXResetSoundChannel:SoundChannel;

    private static var SFXWinSound:Sound;
    private static var SFXWinSoundChannel:SoundChannel;

    private static var defaultTransform:SoundTransform;

    public static var mute:Boolean;
    private static var muteButtonText:TextField;
    private static var muteButtonTextFormat:TextFormat;
    private static var muteButtonBackground:Sprite;
    private static var muteButtonSprite:Sprite;
    public static var muteButton:SimpleButton;
    private static var muteTransform:SoundTransform;

    public static function Init(m:Boolean):void {
        muteTransform = new SoundTransform();
        muteTransform.volume = 0;

        defaultTransform = new SoundTransform();
        defaultTransform.volume = 1;

        mute = !m;
        muteButtonText = new TextField();
        muteButtonText.embedFonts = true;
        muteButtonText.width = Constants.MENU_BUTTON_WIDTH;
        muteButtonText.height = Constants.MENU_BUTTON_HEIGHT;
        muteButtonText.y = Constants.MENU_BUTTON_TEXT_TOP_PADDING;
        muteButtonTextFormat = Menu.getMenuButtonTextFormat();
        flipMute();

        muteButtonBackground = Menu.getMenuButtonBackground();

        muteButtonSprite = new Sprite();
        muteButtonSprite.addChild(muteButtonBackground);
        muteButtonSprite.addChild(muteButtonText);

        muteButton = new SimpleButton();
        muteButton.upState = muteButtonSprite;
        muteButton.downState = muteButtonSprite;
        muteButton.overState = muteButtonSprite;
        muteButton.hitTestState = muteButtonSprite;
        muteButton.x = Constants.SCREEN_WIDTH - Constants.MENU_BUTTON_WIDTH - Constants.MUTE_BUTTON_RIGHT_PADDING;
        muteButton.y = Constants.MUTE_BUTTON_TOP_PADDING;

        muteButton.addEventListener(MouseEvent.CLICK, onMuteClick);

        BGMSound = (new BGM1()) as Sound;
        BGMChannel = BGMSound.play(0, int.MAX_VALUE);

        SFXTransform = new SoundTransform();
        SFXTransform.volume = Constants.SFX_VOLUME;

        SFXJumpSound = (new SFXJump1()) as Sound;
        SFXSpringSound = (new SFXSpring1()) as Sound;
        SFXDeathSound = (new SFXDeath1()) as Sound;
        SFXResetSound = (new SFXReset1()) as Sound;
        SFXWinSound = (new SFXWin1()) as Sound;
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
        GameState.muteSave(mute);
    }

    public static function onMuteClick(event:MouseEvent):void {
        Audio.flipMute();
    }

    public static function playJumpSFX():void {
        SFXJumpSoundChannel = SFXJumpSound.play();
        SFXJumpSoundChannel.soundTransform = SFXTransform;
    }

    public static function playSpringSFX():void {
        SFXSpringSoundChannel = SFXSpringSound.play();
        SFXSpringSoundChannel.soundTransform = SFXTransform;
    }

    public static function playDeathSFX():void {
        SFXDeathSoundChannel = SFXDeathSound.play();
        SFXDeathSoundChannel.soundTransform = SFXTransform;
    }

    public static function playResetSFX():void {
        SFXResetSoundChannel = SFXResetSound.play();
        SFXResetSoundChannel.soundTransform = SFXTransform;
    }

    public static function playWinSFX():void {
        SFXWinSoundChannel = SFXWinSound.play();
        SFXWinSoundChannel.soundTransform = SFXTransform;
    }

}

}