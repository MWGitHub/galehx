/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.sort;

/**
 * Sorts an array of items.
 * Sorting will change the order of the passed array instead of creating a new one.
 */
class Quicksort 
{
	/**
	 * Sorts an array of items.
	 * @param	items			The items to sort.
	 * @param	isReversed		Sorted by descending order if true, ascending otherwise.
	 * @param	field			The field to sort by, if blank then sorts as if it were floats.
	 */
	public static function sort(items:Array<Dynamic>, isReversed:Bool = false, field:String = ""):Void {	
		if (items.length > 1) {
			qsort(items, isReversed, 0, items.length, field);
		}
	}
	
	private static function qsort(items:Array<Dynamic>, isReversed:Bool = false, begin:Int, end:Int, field:String = ""):Void {
		if (end - 1 > begin) {
			var pivot = begin + Std.int(Math.random() * (end - begin));
			pivot = partition(items, isReversed, begin, end, pivot, field);
			
			qsort(items, isReversed, begin, pivot, field);
			qsort(items, isReversed, pivot + 1, end, field);
		}
	}
	
	private static inline function partition(items:Array<Dynamic>, isReversed:Bool = false, begin:Int, end:Int, pivot:Int, field:String = ""):Int {
		var piv;
		if (field == "") {
			piv = items[pivot];
		} else {
			piv = Reflect.field(items[pivot], field);
		}
		swap(items, pivot, end - 1);
		var store = begin;
		for (i in begin...end - 1) {
			if (!isReversed) {
				if (field != "") {
					if (cast(Reflect.field(items[i], field), Float) <= piv) {
						swap(items, store, i);
						++store;
					}
				} else {
					if (items[i] <= piv) {
						swap(items, store, i);
						++store;
					}
				}
			} else {
				if (field != "") {
					if (cast(Reflect.field(items[i], field), Float) >= piv) {
						swap(items, store, i);
						++store;
					}
				} else {
					if (items[i] >= piv) {
						swap(items, store, i);
						++store;
					}
				}
			}
		}
		swap(items, end - 1, store);
		
		return store;
	}
	
	/**
	 * Swaps two elements
	 */
	private static inline function swap(items:Array<Dynamic>, a:Dynamic, b:Dynamic):Void {
		var temp = items[a];
		items[a] = items[b];
		items[b] = temp;
	}
}