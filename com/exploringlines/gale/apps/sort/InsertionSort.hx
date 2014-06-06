/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.sort;

/**
 * Sorts an array of items.
 * Sorting will change the order of the passed array instead of creating a new one.
 */
class InsertionSort {
	/**
	 * Sorts an array of items.
	 * @param	items			The items to sort.
	 * @param	isReversed		Sorted by descending order if true, ascending otherwise.
	 * @param	field			The field to sort by, if blank then sorts as if it were floats.
	 */
	public static function sort(items:Array<Dynamic>, isReverse:Bool = false, field:String = ""):Array<Dynamic> {
		var length:Int = items.length;
		
		for (i in 1...length) {
			var temp:Dynamic = items[i];
			var j:Int = i - 1;
			var done:Bool = false;
			
			if (field != "") {
				var value:Int = Reflect.field(items[i], field);
				do {
					if (isReverse) {
						if (Reflect.field(items[j], field) < value) {
							items[j + 1] = items[j];
							j = j - 1;
							if (j < 0) {
								done = true;
							}
						} else {
							done = true;
						}
					} else {
						if (Reflect.field(items[j], field) > value) {
							items[j + 1] = items[j];
							j = j - 1;
							if (j < 0) {
								done = true;
							}
						} else {
							done = true;
						}
					}
				} while (!done);
			} else {
				var value:Int = items[i];
				do {
					if (isReverse) {
						if (items[j] < value) {
							items[j + 1] = items[j];
							j = j - 1;
							if (j < 0) {
								done = true;
							}
						} else {
							done = true;
						}
					} else {
						if (items[j] > value) {
							items[j + 1] = items[j];
							j = j - 1;
							if (j < 0) {
								done = true;
							}
						} else {
							done = true;
						}
					}
				} while (!done);
				items[j + 1] = temp;
			}
		}
		
		return items;
	}
}