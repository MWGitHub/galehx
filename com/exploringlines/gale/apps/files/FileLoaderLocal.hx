/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.files;
import com.exploringlines.gale.core.Globals;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.Lib;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.system.Security;

/**
 * Opens a dialog to choose where to save a file.
 */
class FileLoaderLocal 
{
	private var rectangle:Rectangle;
	private var buttonHook:MovieClip;
	private var file:FileReference;
	private var fileFilters:Array<FileFilter>;
	
	/**
	 * The data that was loaded.
	 */
	public var data:String;
	
	/**
	 * The callback function when the file is loaded.
	 */
	public var onLoadComplete:Void->Void;

	/**
	 * Creates a transparent button that loads a file when clicked.
	 * @param	rectangle			The rectangle of the button.
	 * @param	?onLoadComplete		The function to run when the data is loaded.
	 * @param	?fileFilters		The files that can be selected.
	 */
	public function new(rectangle:Rectangle, ?onLoadComplete:Void->Void, ?fileFilters:Array<FileFilter>) 
	{
		this.rectangle = rectangle;
		this.onLoadComplete = onLoadComplete;
		this.fileFilters = fileFilters;
		
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
	 * Updates the location of the hook.
	 * @param	rectangle	The location and dimensions of the hook.
	 */
	public function updateLocation(rectangle:Rectangle):Void {
		buttonHook.graphics.clear();
		buttonHook.graphics.beginFill(0x784b1f);
		buttonHook.alpha = 0.01;
		buttonHook.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
		buttonHook.graphics.endFill();
	}
	
	/**
	 * Selects a file to load.
	 */
	private function buttonHookAction(event:MouseEvent):Void {
		if (fileFilters != null) {
			file.browse(fileFilters);
		} else {
			file.browse();
		}
		file.addEventListener(Event.SELECT, onFileSelected);
	}
	
	/**
	 * Loads the file selected.
	 */
	private function onFileSelected(e:Event):Void {
		file.addEventListener(Event.COMPLETE, onFileLoaded);
		file.load();
	}
	
	/**
	 * Sets the data to the loaded data and runs the onLoadComplete callback.
	 */
	private function onFileLoaded(e:Event):Void {
		data = e.target.data;
		onLoadComplete();
	}
}