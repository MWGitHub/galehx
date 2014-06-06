/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.math;

class GaleMath 
{
	public inline static var MAX_INT:Int = 0xffffff;
	
	
	/**
	 * Returns the absolute value of a float.
	 * @param	v	The value to be turned absolute.
	 * @return	The absolute value.
	 */
	public inline static function absFloat(v:Float):Float {
		return v < 0 ? -v : v;
	}
	
	/**
	 * Returns the absolute value of an integer.
	 * @param	v	The value to be turned absolute.
	 * @return	The absolute value.
	 */
	public inline static function absInt(v:Int):Int {
		return (v ^ (v >> 31)) - (v >> 31);
	}
	
	/**
	 * Returns the sign of the value.
	 * @param	v	The value to get the sign of.
	 * @return	Returns -1 or 1 depending on the value.
	 */
	public inline static function getSign(v:Float):Int {
		return v < 0 ? -1 : 1;
	}
	
	/**
	 * Returns a fixed value.
	 * @param	number	The number to fix.
	 * @param	factor	The significant digits.
	 * @return	The fixed value.
	 */
	public inline static function toFixed(number:Float, factor:Int):Float {
		return (Math.round(number * factor) / factor);
	}
	
	/**
	 * Rounds a float to the nearest digit.
	 * @param	v		The number to round.
	 * @param	factor	The factor to round by.
	 * @return	The rounded value.
	 * 
	 * @example
	 * A factor of 10 will round the number to the nearest tenth, whereas a factor of 5
	 * will round to the nearest fifth.
	 * <code>
	 * GaleMath.randomRange(53, 10) // Yields 50
	 * GaleMath.randomRange(123, 5) // Yields 125
	 */
	public inline static function roundToNearest(v:Float, factor:Int):Int {
		return (Std.int(Math.round(v / factor) * factor));
	}
	
	/**
	 * Returns a random number between a range.
	 * Deprecated, will be removed in next version (Replaced with the Random class).
	 * @param	min	The lower range.
	 * @param	max	The upper range.
	 * @return	The random number between the ranges.
	 */
	public inline static function randomRange(min:Float, max:Float):Float {
		return min + Math.random() * (max - min);
	}
	
	/**
	 * Clamps a number between two ranges.
	 * @param	value	The number to clamp.
	 * @param	min		The minimum the number can be.
	 * @param	max		The maximum the number can be.
	 * @return	The clamped number.
	 */
	public inline static function clamp(value:Float, min:Float, max:Float):Float {
		return value < min ? min : value > max ? max : value;
	}
	
	/**
	 * Converts time in milliseconds into a string.
	 * @param	time	The time in milliseconds.
	 * @return	The time in string form.
	 */
	public inline static function timeToString(time:Int, showMinutes:Bool = true, showSeconds:Bool = true, showMilliseconds:Bool = true, msDigits:Int = 3):String {
		var splitTime:Int;
		var output:String = "";
		
		if (showMinutes) {
			output += Std.string(Std.int(time / 60000));
		}
		
		if (showSeconds) {
			if (showMinutes) {
				output += ":";
			}
			splitTime = time % 60000;
			if (Std.int(splitTime / 1000) == 0) {
				output += "00";
			} else if (Std.int(splitTime / 1000) < 10) {
				output += "0" + Std.int(splitTime / 1000);
			} else {
				output += Std.string(Std.int(splitTime / 1000));
			}
		}
		
		if (showMilliseconds) {
			output += ":";
			splitTime = time % 1000;
			if (splitTime == 0) {
				output += "000";
			} else if (splitTime < 10) {
				output += "00" + splitTime;
			} else if (splitTime < 100) {
				output += "0" + splitTime;
			} else {
				output += splitTime;
			}
			
			output = output.substr(0, output.length - (3 - msDigits));
		}
		
		return output;
	}
	
	public inline static function ceil(number:Float):Int {
		var value:Int = Std.int(number);
		return untyped value == number ? number : number >= 0 ? Std.int(number + 1) : value;
	}
}