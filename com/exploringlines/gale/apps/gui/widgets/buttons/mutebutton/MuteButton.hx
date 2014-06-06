/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.gui.widgets.buttons.mutebutton;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.sound.SoundData;
import com.exploringlines.gale.core.sound.SoundPlayer;
import com.exploringlines.gale.core.Button;
import com.exploringlines.gale.core.RootScene;
import flash.geom.Point;
import flash.geom.Rectangle;

class MuteButton extends Button
{
	private var rootScene:RootScene;
	private var display:Entity;
	private var onKey:String;
	private var offKey:String;
	public var muteToggled:Bool;

	public function new(rootScene:RootScene, inputData, ?position:Vector2, layer:Int = 0, onKey:String = "ExtMuteButtonOn", offKey:String = "ExtMuteButtonOff")
	{
		super(inputData, position);
		this.rootScene = rootScene;
		this.onKey = onKey;
		this.offKey = offKey;
		display = rootScene.createEntity(onKey, layer, null);
		attachObject(display);
		
		isLocked = true;
		muteToggled = false;
		
		callbackRelease = onClicked;
		checkKeyImage();
	}
	
	override public function update(deltaTime:Int = 0):Void {
		super.update(deltaTime);
		
		muteToggled = false;
	}
	
	/**
	 * Checks the state of the image.
	 */
	private inline function checkKeyImage():Void {
		if (!rootScene.getMute()) {
			display.setImage(rootScene.getBitmapData(onKey), onKey);
		} else {
			display.setImage(rootScene.getBitmapData(offKey), offKey);
		}
	}
	
	private function onClicked(button:Button):Void {
		toggleSound();
		muteToggled = true;
		checkKeyImage();
	}
	
	private function toggleSound():Void {
		if (rootScene.getMute()) {
			rootScene.setMute(false);
		} else {
			rootScene.setMute(true);
		}
	}
}