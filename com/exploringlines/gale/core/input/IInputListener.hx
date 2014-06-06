/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.input;
import flash.events.Event;
import flash.geom.Point;

interface IInputListener 
{
	/**
	 * The input data for the keyboard and mouse.
	 */
	public var inputData:InputData;
	
	/**
	 * Uses the scale and position to offset the mouse position.
	 */
	public var scaleX:Float;
	public var scaleY:Float;
	public var position:Point;
	
	public function update(deltaTime:Int):Void;
	
	/**
	 * Resets the mouse click locations.
	 */
	public function resetMouseClick():Void;
	
	/**
	 * Resets the cursor to an arrow.
	 */
	public function checkCursor():Void;
	
	/**
	 * Runs when the mouse leaves the flash stage.
	 */
	public function onMouseOut(e:Event):Void;
	
	/**
	 * Resets the shift and control inputs.
	 */
	public function resetModifiers():Void;
}