/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.sort;

/**
 * Sorts an array of items.
 * Sorting will change the order of the passed array instead of creating a new one.
 */
class BubbleSort {
	/**
	 * Sorts an array of items.
	 * @param	items			The items to sort.
	 * @param	isReversed		Sorted by descending order if true, ascending otherwise.
	 * @param	field			The field to sort by, if blank then sorts as if it were floats.
	 */
	public static function sort(items:Array<Dynamic>, isReverse:Bool = false, field:String = ""):Array<Dynamic> {
		var length:Int = items.length;
		do {
			var newLength:Int = 0;
			for (i in 0...length - 1) {
				if (field != "") {
					if (!isReverse) {
						if (Reflect.field(items[i], field) > Reflect.field(items[i + 1], field)) {
							var item:Dynamic = items[i + 1];
							items[i + 1] = items[i];
							items[i] = item;
							newLength = i + 1;
						}
					} else {
						if (Reflect.field(items[i], field) < Reflect.field(items[i + 1], field)) {
							var item:Dynamic = items[i + 1];
							items[i + 1] = items[i];
							items[i] = item;
							newLength = i + 1;
						}
					}
				} else {
					if (!isReverse) {
						if (items[i] > items[i + 1]) {
							var item:Dynamic = items[i + 1];
							items[i + 1] = items[i];
							items[i] = item;
							newLength = i + 1;
						}
					} else {
						if (items[i] < items[i + 1]) {
							var item:Dynamic = items[i + 1];
							items[i + 1] = items[i];
							items[i] = item;
							newLength = i + 1;
						}
					}
				}
			}
			length = newLength;
		} while (length > 1);
		
		return items;
	}
}