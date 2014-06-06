/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.mainloops;
import com.exploringlines.gale.core.Globals;
import flash.Lib;

class MainLoopStageFrame implements IMainLoop
{
	/**
	 * Number of ticks per second to update the game logic.
	 */
	public var updateStepSize:Int;
	public var isUpdating(getIsUpdating, null):Bool;
	public var timesToUpdate:Int;
	
	/**
	 * Number of ticks per second to update the display.
	 */
	public var displayStepSize:Int;
	public var interpolation:Int;
	public var isRendering(getIsRendering, null):Bool;
	public var timesToRender:Int;

	public function new() 
	{
		updateStepSize = Std.int(1 / Globals.stage.frameRate * 1000);
		displayStepSize = Std.int(1 / Globals.stage.frameRate * 1000);
		
		interpolation = 0;
		
		timesToUpdate = 1;
		timesToRender = 1;
	}
	
	/**
	 * @inheritDoc
	 */
	public function enable():Void {
	}
	
	public function update():Void {
		isUpdating = true;
		isRendering = true;
	}
	
	private inline function getIsUpdating():Bool {
		var v:Bool = isUpdating;
		isUpdating = false;
		return v;
	}
	
	private inline function getIsRendering():Bool {
		var v:Bool = isRendering;
		isRendering = false;
		return v;
	}
}