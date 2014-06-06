/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.mainloops;
import flash.Lib;

/**
 * A main loop that updates both the logic and display at the same time.
 */
class MainLoopSynced implements IMainLoop
{
	/**
	 * Number of ticks per second to update the game logic.
	 */
	public var updateTicksPerSecond(default, setUpdateTicksPerSecond):Int;
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
	
	private var lastIterationTime:Int;
	private var currentTime:Int;

	public function new(updateTicksPerSecond:Int = 24) 
	{
		this.updateTicksPerSecond = updateTicksPerSecond;
		displayStepSize = updateStepSize;
		
		lastIterationTime = 0;
		currentTime = 0;
		interpolation = 0;
		
		timesToUpdate = 1;
		timesToRender = 1;
	}
	
	/**
	 * @inheritDoc
	 */
	public function enable():Void {
		lastIterationTime = Lib.getTimer();
	}
	
	public function update():Void {
		currentTime = Lib.getTimer();
		while (lastIterationTime + updateStepSize <= currentTime) {
			isUpdating = true;
			isRendering = true;
			lastIterationTime += updateStepSize;
		}
	}
	
	/**
	 * Updates the number of updates per second.
	 * @param	ticks	The number of updates per second.
	 */
	private function setUpdateTicksPerSecond(ticks:Int):Int {
		updateStepSize = Std.int(1000 / ticks);
		displayStepSize = updateStepSize;
		return ticks;
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