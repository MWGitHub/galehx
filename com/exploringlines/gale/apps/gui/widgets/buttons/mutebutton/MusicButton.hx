/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.gui.widgets.buttons.mutebutton;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.sound.ISoundData;
import com.exploringlines.gale.core.Button;
import com.exploringlines.gale.core.RootScene;
import flash.geom.Point;
import flash.geom.Rectangle;

class MusicButton extends Button
{
	private var rootScene:RootScene;
	private var display:Entity;
	private var onKey:String;
	private var offKey:String;
	public var musics:Array<ISoundData>;
	public var muteToggled:Bool;
	
	// True to save the position of the music and set the offset.
	public var savePosition:Bool;

	public function new(rootScene:RootScene, inputData:InputData, ?position:Vector2, layer:Int = 0, onKey:String, offKey:String, ?musics:Array<ISoundData>, savePosition:Bool = false)
	{
		super(inputData, position);
		this.rootScene = rootScene;
		if (musics == null) {
			this.musics = [];
		} else {
			this.musics = musics;
		}
		this.savePosition = savePosition;
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
		if (!rootScene.getMusicMute()) {
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
		if (rootScene.getMusicMute()) {
			if (musics.length > 0) {
				rootScene.setMusicMute(false);
				for (i in 0...musics.length) {
					rootScene.playMusic(musics[i]);
				}
			} else {
				rootScene.setMusicMute(false);
			}
		} else {
			if (musics.length > 0 && savePosition) {
				for (i in 0...musics.length) {
					if (musics[i].soundChannel != null) {
						musics[i].offset = musics[i].soundChannel.position;
					}
				}
			}
			rootScene.setMusicMute(true);
		}
	}
}