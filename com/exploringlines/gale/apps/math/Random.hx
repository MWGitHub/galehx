/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.math;

/**
 * Handles the generation of random values with a seed.
 * Uses the Park-Miller-Carta pseudo-random number generator.
 */
class Random 
{
	/**
	 * The seed for the random numbers.
	 */
	public static var seed:UInt = 1;
	public static var isSeeded:Bool = true;
	
	
	private static var lo:UInt;
	private static var hi:UInt;
	
	public static inline function setRandomSeed():Void {
		seed = Std.int(Math.random() * 0xFFFFFFF);
	}
	
	/**
	 * Retrieves a random float.
	 * @return	The random float.
	 */
	public static inline function random():Float {
		if (isSeeded) {
			lo = 16807 * (seed & 0xFFFF);
			hi = 16807 * (seed >> 16);
			
			lo += (hi & 0x7FFF) << 16;
			lo += hi >> 15;
			
			if (lo > 0x7FFFFFFF) {
				lo -= 0x7FFFFFFF;
			}
			
			seed = lo;
			return seed / 0x7FFFFFFF + 0.000000000233;
		} else {
			return Math.random();
		}
	}
	
	/**
	 * Retrieves a random float within a range.
	 * @param	min		The minimum float.
	 * @param	max		The maximum float.
	 * @return	The random float within the range.
	 */
	public static inline function range(min:Float, max:Float):Float {
		return min + random() * (max - min);
	}
	
	public static inline function rangeUInt(min:UInt, max:UInt):UInt {
		return min + Std.int(random() * ((max + 0.99) - min));
	}
	
	/**
	 * Retrieves either a true or false based on the cahnce.
	 * @param	chance	The chance to be true
	 * @return	Either true or false.
	 */
	public static inline function bool(chance:Float=0.5):Bool {
		return (random() < chance);
	}
		
	
	/**
	 * Returns either a -1 or 1.
	 * @param	chance	The chance to return a 1.
	 * @return	Returns 1 or -1.
	 */
	public static inline function sign(chance:Float=0.5):Int {
		return (random() < chance) ? 1 : -1;
	}
}