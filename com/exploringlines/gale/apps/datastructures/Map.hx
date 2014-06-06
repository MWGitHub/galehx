/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.datastructures;
import flash.utils.Dictionary;

/**
 * A Map using the as3 dictionary.
 */
class Map<K, T>
{
	private var dictionary:Dictionary;

	public function new(weakKeys:Bool = false) 
	{
		dictionary = new Dictionary(weakKeys);
	}
	
	public inline function get(key:K):Null<T> {
		return untyped dictionary[key];
	}
	
	public inline function set(key:K, value:T):Void {
		untyped dictionary[key] = value;
	}
	
	public inline function exists(key:K):Bool {
		return untyped dictionary[key] != null;
	}
	
	public inline function delete(key:K):Void {
		untyped __delete__(dictionary, key);
	}
	
	public inline function iterator():Iterator<K> {
		var a:Array<K> = untyped __keys__(dictionary);
		return a.iterator();
	}
}