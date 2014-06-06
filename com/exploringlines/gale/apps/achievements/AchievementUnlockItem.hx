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
 * The displayed item in the achievements browser.
 */
class AchievementUnlockItem extends Node
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
	private static var descriptionX:Float;
	private static var descriptionY:Float;
	
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
		var entity:IEntity = attachObject(rootScene.createEntity(panelKey, layer));
		var width:Float = entity.rectangle.width;
		var height:Float = entity.rectangle.height;
		
		// Create icon and overlay
		var offsetX:Float = -width / 2 + imageXOffset;
		var offsetY:Float = -height / 2 + imageYOffset;
		
		attachObject(rootScene.createEntity(achievement.imageKey, layer, new Point(offsetX, offsetY)));
		attachObject(rootScene.createEntity(panelOverlayKey, layer, new Point(offsetX, offsetY)));
		
		// Create the name of the achievement
		offsetX = -width / 2 + nameXOffset;
		offsetY = -height / 2 + nameYOffset;
		var text:Text = rootScene.createText(layer, achievement.name, new Point(offsetX, offsetY), fontSize, fontColor, font);
		attachObject(text);
		
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
	}
	
	/**
	 * Loads the images and style of the achievement display.
	 */
	public static function loadStyle(data:Dynamic):Void {
		panelKey = data.panelImage;
		panelOverlayKey = data.panelImageOverlay;
		
		imageSize = data.imageSize;
		imageXOffset = data.imageX;
		imageYOffset = data.imageY;
		
		font = data.font;
		fontSize = data.fontSize;
		fontColor = data.fontColor;
		nameXOffset = data.nameX;
		nameYOffset = data.nameY;
		
		descriptionX = data.descriptionX;
		descriptionY = data.descriptionY;
	}
}