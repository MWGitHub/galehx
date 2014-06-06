/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.timers;

interface ITimer 
{
	/**
	 * The length of the timer in milliseconds.
	 */
	public var period:Int;
	
	public var isReady(getIsReady, null):Bool;
	public var counter:Int;
	
	/**
	 * Updates the timer.
	 * @param	deltaTime	The time between the last update in milliseconds.
	 */
	public function update(deltaTime:Int):Void;
	
	/**
	 * Gets if the timer is ready.
	 * @return	Returns true if the timer is ready.
	 */
	private function getIsReady():Bool;
	
	
	/**
	 * Resets the timer.
	 */
	public function reset():Void;
}