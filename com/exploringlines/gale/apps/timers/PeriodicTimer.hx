/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.timers;

/**
 * A periodic timer that automatically resets itself after each isReady check.
 */
class PeriodicTimer implements ITimer
{
	/**
	 * The time in milliseconds of each wave.
	 */
	public var period:Int;
	
	public var isReady(getIsReady, null):Bool;
	public var counter:Int;
	
	/**
	 * Creates a new countdown timer that can be set to be initially ready.
	 * @param	period		The time in milliseconds of each wave.
	 * @param	beginReady	If true, the timer will begin ready.
	 */
	public function new(period:Int, beginReady:Bool = false) 
	{
		this.period = period;
		isReady = false;
		if (beginReady) {
			counter = period;
		} else {
			counter = 0;
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function update(deltaTime:Int):Void {
		counter += deltaTime;
		if (counter >= period) {
			isReady = true;
		}
	}
	
	/**
	 * Returns true when the period has passed, then resets when the status is retrieved.
	 * @return	Returns true if the timer is ready.
	 */
	private inline function getIsReady():Bool {
		var status:Bool = isReady;
		if (isReady) {
			counter = 0;
			isReady = false;
		}
		
		return status;
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function reset():Void {
		isReady = false;
		counter = 0;
	}
}