/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.stateeffects;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.apps.timers.CountdownTimer;
import com.exploringlines.gale.core.Globals;
import com.exploringlines.gale.core.IRootState;
import com.exploringlines.gale.core.Node;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.RootScene;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.Lib;

enum Fade {
	IN;
	OUT;
	NONE;
}

class StateEffectFade extends Node
{
	private var state:IRootState;
	private var rootScene:RootScene;
	private var display:Entity;
	
	private var fading:Fade;
	private var duration:CountdownTimer;
	private var beginAt:Int;
	
	/**
	 * True when the fade has completed.
	 */
	public var isFadeComplete:Bool;
	
	/**
	 * The state to change to when finished fading.
	 */
	public var fadedState:String;
	
	/**
	 * Is true then the fade effect is done through a sprite.
	 * Layers will be ignored with sprites and the effect will display above the renderer.
	 */
	private var isSprite:Bool;
	private var fadeClip:Sprite;

	public function new(state:IRootState, layer:Int = 0, color:UInt = 0x000000, isSprite:Bool = true) 
	{
		super(new Vector2(Globals.stage.stageWidth / 2, Globals.stage.stageHeight / 2));
		
		this.state = state;
		this.isSprite = isSprite;
		this.rootScene = state.rootScene;
		isVisible = false;
		isLocked = true;
		
		if (!isSprite) {
			var bitmapData:BitmapData = new BitmapData(Globals.stage.stageWidth, Globals.stage.stageHeight, true, 0xFFFFFF);
			var canvas:Sprite = new Sprite();
			canvas.graphics.beginFill(color, 1);
			canvas.graphics.drawRect(0, 0, Globals.stage.stageWidth, Globals.stage.stageHeight);
			canvas.graphics.endFill();
			bitmapData.draw(canvas);
			
			display = new Entity("FadeEffect", bitmapData, bitmapData.rect, null, layer);
			rootScene.addEntity(display);
			attachObject(display);
		} else {
			fadeClip = new Sprite();
			fadeClip.graphics.beginFill(color, 1);
			fadeClip.graphics.drawRect(0, 0, Globals.stage.stageWidth, Globals.stage.stageHeight);
			fadeClip.graphics.endFill();
		}
		
		fading = Fade.NONE;
		duration = new CountdownTimer(1000);
		
		isFadeComplete = true;
		
		fadedState = "";
		
		beginAt = 0;
	}
	
	/**
	 * Fades in by slowly becoming more transparent.
	 * @param	duration	The duration of the fade.
	 */
	public function fadeIn(duration:Int):Void {
		if (!isSprite) {
			rootScene.removeEntity(display);
			rootScene.addEntity(display);
		} else {
			if (Globals.stage.contains(fadeClip)) {
				Globals.stage.removeChild(fadeClip);
			}
			Globals.stage.addChild(fadeClip);
		}
		
		this.duration.period = duration;
		this.duration.reset();
		fading = Fade.IN;
		isVisible = true;
		fadeClip.visible = false;
		isFadeComplete = false;
		alpha = 1;
	}
	
	/**
	 * Fades out by becoming less transparent. The state can be changed when completed.
	 * @param	duration	The duration of the fade effect.
	 * @param	beginAt		The time to begin fading out.
	 * @param	state		The state to change to when completed.
	 */
	public function fadeOut(duration:Int, beginAt:Int = 0, state:String = ""):Void {
		fadedState = state;
		this.beginAt = beginAt;
		
		if (!isSprite) {
			rootScene.removeEntity(display);
			rootScene.addEntity(display);
		} else {
			removeFade();
			Globals.stage.addChild(fadeClip);
		}
		
		this.duration.period = duration;
		this.duration.reset();
		fading = Fade.OUT;
		isVisible = true;
		isFadeComplete = false;
		alpha = 0;
		fadeClip.visible = false;
	}
	
	override public function update(deltaTime:Int = 0):Void 
	{
		super.update(deltaTime);
		
		duration.update(deltaTime);
		
		// Update fading when complete
		if (duration.isReady) {
			if (fading == Fade.OUT) {
				isFadeComplete = true;
				if (fadedState != "") {
					state.nextState = fadedState;
					fadedState = "";
				}
			} else {
				fading == Fade.NONE;
				isVisible = false;
				isFadeComplete = true;
				removeFade();
			}
		}
		
		// Update fading alpha
		if (fading == Fade.IN) {
			if (isSprite) {
				fadeClip.visible = true;
				alpha = 1 - duration.counter / duration.period;
			} else {
				alpha = GaleMath.roundToNearest((1 - duration.counter / duration.period) * 100, 10) / 100;
			}
		} else if (fading == Fade.OUT) {
			if (duration.counter > beginAt) {
				if (isSprite) {
					fadeClip.visible = true;
					alpha = (duration.counter - beginAt) / (duration.period - beginAt);
				} else {
					alpha = GaleMath.roundToNearest(((duration.counter - beginAt) / (duration.period - beginAt)) * 100, 10) / 100;
				}
			} else {
				alpha = 0;
			}
		}
		if (isSprite) {
			fadeClip.alpha = alpha;
		}
	}
	
	public function removeFade():Void {
		if (isSprite) {
			if (Globals.stage.contains(fadeClip)) {
				Globals.stage.removeChild(fadeClip);
			}
		}
	}
	
	public function leave():Void {
		removeFade();
	}
}