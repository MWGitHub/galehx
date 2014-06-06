/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.files;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLRequest;

/**
 * Loads a file given a set location.
 */
class FileLoader 
{
	public var isLoaded:Bool;
	public var dataLoader:URLLoader; 

	public function new() 
	{
		isLoaded = false;
	}
	
	public function loadData(path:String):Dynamic {
		isLoaded = false;
		
		var request:URLRequest = new URLRequest(path);
		dataLoader = new URLLoader();
		try {
			dataLoader.load(request);
		} catch (error:Dynamic) {
			throw("A SecurityError has occurred.");
		}
		dataLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		dataLoader.addEventListener(Event.COMPLETE, onLoad);
	}
	
	private function onLoad(e:Event):Void {
		isLoaded = true;
	}
	
	private function onError(e:Event):Void {
		trace("Problem loading file.");
	}
}