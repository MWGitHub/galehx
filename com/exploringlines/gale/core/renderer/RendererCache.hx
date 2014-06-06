/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.system.System;
import flash.utils.Dictionary;
import com.exploringlines.gale.apps.datastructures.Map;

class RendererCache 
{
	/**
	 * The maximum memory the cache will store before purging data.
	 * The memory usage is shared between all flash player instances.
	 */
	private var limit:Float;
	
	/**
	 * The cached objects.
	 */
	private var cache:Map<String, RendererCacheObject>;

	public function new(limit:Float = 2000) 
	{
		this.limit  = limit;
		cache = new Map<String, RendererCacheObject>();
	}
	
	/**
	 * Add a renderable object to the cache.
	 * @param	key				The object and operations done on it.
	 * @param	bitmapData		The applied transforms to the original bitmapData
	 * @param	rectangle		The rectangle after the transforms.
	 */
	public inline function addToCache(key:String, object:RendererCacheObject):Void {
		cache.set(key, object);
		
		if (System.totalMemory / 1024 / 1024 > limit) {
			cache = null;
			cache = new Map<String, RendererCacheObject>();
		}
	}
	
	/**
	 * Check if an object is cached.
	 * @param	key				The object and operations done on it.
	 * @return	The 
	 */
	public inline function isInCache(key:String):Bool {
		return cache.exists(key);
	}
	
	/**
	 * Retrieves data from the cache.
	 * @param	key		The object to retrieve.
	 * @return	The retrieved object.
	 */
	public inline function retrieveFromCache(key:String):RendererCacheObject {
		return cache.get(key);
	}
	
	/**
	 * Flushes the cache.
	 */
	public inline function flush():Void {
		cache = new Map<String, RendererCacheObject>();
	}
}