/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.mainloops;

interface IMainLoop 
{
	/**
	 * True when logic is ready to be updated.
	 */
	public var isUpdating(getIsUpdating, null):Bool;
	
	/**
	 * The step size of the logic update.
	 */
	public var updateStepSize:Int;
	
	/**
	 * Number of times to run the logic update.
	 */
	public var timesToUpdate:Int;
	
	/**
	 * True when display is ready to be drawn.
	 */
	public var isRendering(getIsRendering, null):Bool;
	
	/**
	 * The step size of the display; used for animations.
	 */
	public var displayStepSize:Int;
	
	/**
	 * The size of the time passed since the last logic update; used for speed interpolation.
	 */
	public var interpolation:Int;
	
	/**
	 * The number of times to render.
	 */
	public var timesToRender:Int;
	
	/**
	 * Resets the main timer.
	 */
	public function enable():Void;
	
	/**
	 * Updates the main loop.
	 */
	public function update():Void;
}