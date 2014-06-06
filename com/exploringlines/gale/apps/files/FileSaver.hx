/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.files;
import com.exploringlines.gale.core.Globals;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.Lib;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.system.Security;

/**
 * Opens a dialog to choose where to save a file.
 */
class FileSaver 
{
	private var rectangle:Rectangle;
	private var buttonHook:MovieClip;
	private var file:FileReference;
	
	/**
	 * The data to save when clicked.
	 */
	public var data:String;
	
	/**
	 * The callback function that is run before saving.
	 */
	public var preSaveCallback:Void->Void;

	/**
	 * Creates a transparent button that allows saving to disk.
	 * @param	rectangle	The rectangle of the button.
	 */
	public function new(rectangle:Rectangle) 
	{
		this.rectangle = rectangle;
		
		buttonHook = new MovieClip();
		buttonHook.graphics.beginFill(0x784b1f);
		buttonHook.alpha = 0.01;
		buttonHook.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
		buttonHook.graphics.endFill();
		buttonHook.gotoAndStop(0);
		
		file = new FileReference();
	}
	
	/**
	 * Adds the hook to the stage.
	 */
	public function enable():Void {
		if (!Globals.stage.contains(buttonHook)) {
			Globals.stage.addChild(buttonHook);
			buttonHook.addEventListener(MouseEvent.CLICK, buttonHookAction);
		}
	}
	
	/**
	 * Removes the hook from the stage.
	 */
	public function disable():Void {
		if (Globals.stage.contains(buttonHook)) {
			Globals.stage.removeChild(buttonHook);
			buttonHook.removeEventListener(MouseEvent.CLICK, buttonHookAction);
		}
	}
	
	/**
	 * Updates the location of the button.
	 * @param	rectangle	The position and dimensions of the button.
	 */
	public function updateLocation(rectangle:Rectangle):Void {
		buttonHook.graphics.clear();
		buttonHook.graphics.beginFill(0x784b1f);
		buttonHook.alpha = 0.01;
		buttonHook.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
		buttonHook.graphics.endFill();
	}
	
	/**
	 * Saves the data when the hook is clicked.
	 */
	private function buttonHookAction(event:MouseEvent):Void {
		if (preSaveCallback != null) {
			preSaveCallback();
		}
		file.save(data);
	}
}