/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.shortcuts;
import com.exploringlines.gale.apps.math.geom.Rect;
import com.exploringlines.gale.core.renderer.EntityAnimationFrame;
import com.exploringlines.gale.core.resourceloader.CachedBitmapData;
import com.exploringlines.gale.core.resourceloader.IResourceLoader;

class AnimationCreator 
{
	private var resourceLoader:IResourceLoader;
	private var animationCacher:Hash < Array < EntityAnimationFrame >> ;

	public function new(resourceLoader:IResourceLoader)
	{
		this.resourceLoader = resourceLoader;
		
		animationCacher = new Hash < Array < EntityAnimationFrame >> ();
	}
	
	public inline function createAnimation(animation:Array < String >, duration:Int ):Array < EntityAnimationFrame > {
		var animationFrames:Array<EntityAnimationFrame> = [];
		var cache:CachedBitmapData;
		
		for (i in 0...animation.length) {
			cache = resourceLoader.getCachedBitmapData(animation[i]);
			animationFrames.push(new EntityAnimationFrame(cache.bitmapData, cache.rectangle, duration, animation[i]));
		}
		
		return animationFrames;
	}
	
	public inline function setAnimationCacheRaw(key:String, animationFrames:Array < EntityAnimationFrame > ):Void {
		animationCacher.set(key, animationFrames);
	}
	
	public inline function setAnimationCache(key:String, animationIndices:Array < String > ):Void {
		animationCacher.set(key, createAnimation(animationIndices, 16));
	}
	
	public inline function getAnimationCache(key:String):Array < EntityAnimationFrame > {
		return animationCacher.get(key);
	}
}