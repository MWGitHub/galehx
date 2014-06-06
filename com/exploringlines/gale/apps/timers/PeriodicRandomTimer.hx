/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.timers;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.Random;

/**
 * A periodic timer.
 */
class PeriodicRandomTimer implements ITimer
{
	/**
	 * The time in milliseconds of each wave.
	 */
	public var period:Int;
	
	/**
	 * The original period of the timer.
	 */
	public var originalPeriod:Int;
	
	/**
	 * The lower percent error.
	 */
	public var lowerRange:Float;
	
	/**
	 * The upper percent error.
	 */
	public var upperRange:Float;
	
	public var isReady(getIsReady, null):Bool;
	public var counter:Int;
	
	/**
	 * Creates a new countdown timer that can be set to be initially ready.
	 * @param	period		The time in milliseconds of each wave.
	 * @param	beginReady	If true, the timer will begin ready.
	 * @param	lowerRange	The percent of the original value to offset from the floor.
	 * @param	upperRange	The percent of the original value to offset from the ceiling.
	 */
	public function new(period:Int, lowerRange:Float, upperRange:Float, beginReady:Bool = false) 
	{
		this.originalPeriod = period;
		this.period = Std.int(Random.range(originalPeriod - originalPeriod * lowerRange, originalPeriod + originalPeriod * upperRange));
		this.lowerRange = lowerRange;
		this.upperRange = upperRange;
		
		isReady = false;
		if (beginReady) {
			counter = this.period;
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
			period = Std.int(Random.range(originalPeriod - originalPeriod * lowerRange, originalPeriod + originalPeriod * upperRange));
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