/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.benchmark;
import flash.Lib;

/**
 * Compares two times and outputs the times and percent difference of functions or times.
 */
class Benchmark 
{
	/**
	 * Compares two functions and returns the times and time difference in percent.
	 * These times are relative due to function calls taking some time if the number of times to run is set very high.
	 * @param	f1 Function to be compared.
	 * @param	f2 Function to be compared.
	 * @param	times Number of times to run the functions.
	 */
	public static function compareFunctions(f1:Void->Void, f2:Void->Void, times:Int):String {
		var startTime:Int;
		var diff1:Float = 0, diff2:Float = 0;
		
		for (i in 0...times) {
			startTime = Lib.getTimer();
			f1();
			diff1 += Lib.getTimer() - startTime;
		}
		
		for (i in 0...times) {
			startTime = Lib.getTimer();
			f2();
			diff2 += Lib.getTimer() - startTime;
		}
		
		return compareTimes(diff1 / times, diff2 / times);
	}
	
	/**
	 * Compares two times and returns the string output.
	 * @param	t1 The first time to test.
	 * @param	t2 The second time to test.
	 * @return 	A string with the percent difference in time.
	 */
	public static function compareTimes(t1:Float, t2:Float):String {
		var percent:Float;
		var output:String = "\nTest A time: ";
		output = output + Std.string(t1) + " ms \n";
		
		output = output + "Test B time: ";
		output = output + Std.string(t2) + " ms \n";
		
		if (t1 < t2) {
			percent = t2 / t1;
			output = output + "A is faster than B by: " + Std.string(percent);
		} else {
			percent = t1 / t2;
			output = output + "B is faster than A by: " + Std.string(percent);
		}
		output = output + "\nPercent change: " + Std.string(((t2 - t1) / t1) * 100);
		
		return output;
	}
}