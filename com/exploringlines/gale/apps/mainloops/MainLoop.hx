/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.mainloops;
import flash.Lib;

class MainLoop implements IMainLoop
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
	public var displayTicksPerSecond(default, setDisplayTicksPerSecond):Int;
	public var displayStepSize:Int;
	public var interpolation:Int;
	public var isRendering(getIsRendering, null):Bool;
	public var timesToRender:Int;
	
	/**
	 * Number of updates allowed to miss. Using too high a value can cause some computers to crash.
	 */
	public var maximumMissedUpdates:Int;
	private var missedUpdates:Int;
	
	private var lastIterationTime:Int;
	private var lastDisplayIterationTime:Int;
	private var currentTime:Int;

	public function new(updateTicksPerSecond:Int = 24, displayTicksPerSecond:Int = 24, maximumMissedUpdates:Int = 1) 
	{
		this.updateTicksPerSecond = updateTicksPerSecond;
		this.displayTicksPerSecond = displayTicksPerSecond;
		this.maximumMissedUpdates = maximumMissedUpdates;
		
		missedUpdates = 0;
		lastIterationTime = 0;
		lastDisplayIterationTime = 0;
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
		missedUpdates = 0;
		while (lastIterationTime + updateStepSize <= currentTime) {
			isUpdating = true;
			lastIterationTime += updateStepSize;
			missedUpdates++;
			if (missedUpdates > maximumMissedUpdates) {
				lastIterationTime = currentTime;
			}
		}
		
		if (lastDisplayIterationTime + displayStepSize <= currentTime) {
			isRendering = true;
			interpolation = currentTime - lastIterationTime;
			lastDisplayIterationTime += displayStepSize;
			if (lastDisplayIterationTime <= currentTime) {
				lastDisplayIterationTime = currentTime;
			}
		}
	}
	
	/**
	 * Updates the number of updates per second.
	 * @param	ticks	The number of updates per second.
	 */
	private function setUpdateTicksPerSecond(ticks:Int):Int {
		updateStepSize = Std.int(1000 / ticks);
		return ticks;
	}
	
	/**
	 * Updates the number of renders per second.
	 * @param	ticks	The number of renders per second.
	 */
	private function setDisplayTicksPerSecond(ticks:Int):Int {
		displayStepSize = Std.int(1000 / ticks);
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