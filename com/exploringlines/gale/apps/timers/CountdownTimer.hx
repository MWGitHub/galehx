/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.timers;

/**
 * A countdown timer.
 */
class CountdownTimer implements ITimer
{
	/**
	 * The length of the countdown in milliseconds.
	 */
	public var period:Int;
	
	public var isReady(getIsReady, null):Bool;
	public var counter:Int;
	
	/**
	 * Creates a new countdown timer.
	 * @param	period		The length of the countdown timer in milliseconds.
	 */
	public function new(period:Int) 
	{
		this.period = period;
		isReady = false;
		counter = 0;
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function update(deltaTime:Int):Void {
		counter += deltaTime;
		if (counter >= period) {
			counter = period;
			isReady = true;
		}
	}
	
	/**
	 * Gets if the countdown timer has reached zero.
	 * @return	Returns true if the countdown timer has reached zero.
	 */
	private inline function getIsReady():Bool {
		var status:Bool = isReady;
		
		return status;
	}
	
	/**
	 * Resets the countdown timer so it can be used again.
	 */
	public inline function reset():Void {
		isReady = false;
		counter = 0;
	}
	
}