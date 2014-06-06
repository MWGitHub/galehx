/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.achievements;
import com.exploringlines.gale.apps.graphics.Draw;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.apps.text.Text;
import com.exploringlines.gale.apps.timers.CountdownTimer;
import com.exploringlines.gale.core.Globals;
import com.exploringlines.gale.core.Node;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.EntityAnimationFrame;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.RootScene;
import com.exploringlines.gale.core.sound.SoundData;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;

/**
 * Displays a panel when an achievement is unlocked.
 */
class AchievementUnlockDisplay extends Node
{	
	private var rootScene:RootScene;
	private var layer:Int;
	
	// Styling data
	private static var panelKey:String;
	private static var panelOverlayKey:String;
	private static var imageSize:Float;
	private static var imageXOffset:Float;
	private static var imageYOffset:Float;
	private static var font:String;
	private static var fontSize:Int;
	private static var fontColor:UInt;
	private static var nameXOffset:Float;
	private static var nameYOffset:Float;
	private static var soundKey:String;
	private static var volume:Float;
	private static var slideSpeed:Float;
	private static var transitionDuration:Int;
	private static var idleDuration:Int;
	
	private var slideDuration:CountdownTimer;
	private var duration:CountdownTimer;

	/**
	 * Creates all entities and attaches them to the node.
	 * The graphics creation will only be generated one time.
	 * @param	rootScene	The current rootScene of the state.
	 * @param	layer		The layer to render on.
	 * @param	name		The name of the achievement.
	 */
	public function new(rootScene:RootScene, layer:Int, achievement:Achievement) 
	{
		super();
		
		// Create background
		var entity:IEntity = attachObject(rootScene.createEntity(AchievementUnlockDisplay.panelKey, layer));
		var width:Float = entity.rectangle.width;
		var height:Float = entity.rectangle.height;
		
		// Create icon and overlay
		var offsetX:Float = -width / 2 + imageXOffset;
		var offsetY:Float = -height / 2 + imageYOffset;
		
		attachObject(rootScene.createEntity(achievement.imageKey, layer, new Point(offsetX, offsetY)));
		attachObject(rootScene.createEntity(AchievementUnlockDisplay.panelOverlayKey, layer, new Point(offsetX, offsetY)));
		
		// Create the name of the achievement
		offsetX = -width / 2 + AchievementUnlockDisplay.nameXOffset;
		offsetY = -height / 2 + AchievementUnlockDisplay.nameYOffset;
		var text:Text = rootScene.createText(layer, achievement.name, new Point(offsetX, offsetY), 
											 AchievementUnlockDisplay.fontSize, AchievementUnlockDisplay.fontColor, AchievementUnlockDisplay.font);
		attachObject(text);
		
		// Create the sound and play it
		var sound:SoundData = rootScene.createSound(AchievementUnlockDisplay.soundKey);
		sound.setVolume(AchievementUnlockDisplay.volume);
		rootScene.playSound(sound);
		
		speed.y = AchievementUnlockDisplay.slideSpeed;
		slideDuration = new CountdownTimer(Std.int(AchievementUnlockDisplay.transitionDuration));
		duration = new CountdownTimer(Std.int(AchievementUnlockDisplay.idleDuration));
		
		// Set the starting location
		position.x = Globals.stage.stageWidth / 2;
		position.y = -height / 2;
		update();
	}
	
	/**
	 * Sets the animation and timer for transitioning out.
	 * Updates only when visible.
	 * @param	deltaTime
	 */
	override public function update(deltaTime:Int = 0):Void 
	{
		super.update(deltaTime);
		
		slideDuration.update(deltaTime);
		if (slideDuration.isReady) {
			if (speed.y < 0) {
				isRemoved = true;
			} else {
				speed.y = 0;
			}
		}
		if (speed.y == 0) {
			duration.update(deltaTime);
			if (duration.isReady) {
				speed.y = -AchievementUnlockDisplay.slideSpeed;
				slideDuration.reset();
			}
		}
	}
	
	/**
	 * Loads the images and style of the achievement display.
	 */
	public static function loadStyle(data:Dynamic):Void {
		AchievementUnlockDisplay.panelKey = data.panelImage;
		AchievementUnlockDisplay.panelOverlayKey = data.panelImageOverlay;
		
		AchievementUnlockDisplay.imageSize = data.imageSize;
		AchievementUnlockDisplay.imageXOffset = data.imageX;
		AchievementUnlockDisplay.imageYOffset = data.imageY;
		
		AchievementUnlockDisplay.font = data.font;
		AchievementUnlockDisplay.fontSize = data.fontSize;
		AchievementUnlockDisplay.fontColor = data.fontColor;
		AchievementUnlockDisplay.nameXOffset = data.nameX;
		AchievementUnlockDisplay.nameYOffset = data.nameY;
		
		AchievementUnlockDisplay.soundKey = data.sound;
		AchievementUnlockDisplay.volume = data.soundVolume;
		
		AchievementUnlockDisplay.slideSpeed = data.speed;
		AchievementUnlockDisplay.transitionDuration = data.transitionDuration;
		AchievementUnlockDisplay.idleDuration = data.idleDuration;
	}
}