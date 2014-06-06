/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import com.exploringlines.gale.core.Node;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

interface IEntity 
{
	/**
	 * The index of the entity. Each entity has a unique index.
	 */
	public var index(default, null):Int;
	
	/**
	 * The name of the entity. This is used when finding cached renders.
	 */
	public var name:String;
	
	/**
	 * The local layer the entity is on.
	 * This is overridden when using the z position.
	 */
	public var layer:Int;
	
	/**
	 * The stage layer to render the entity on.
	 */
	public var stageLayer:Int;
	
	/**
	 * The object the entity is attached to.
	 */
	public var parent:Node;
	
	/**
	 * The bitmap used when rendering.
	 */
	public var bitmapData:BitmapData;
	
	/**
	 * The bitmap used from the cache.
	 */
	public var rendererCacheObject(default, setRendererCacheObject):RendererCacheObject;
	
	/**
	 * The rectangle used when rendering.
	 */
	public var rectangle(default, setRectangle):Rectangle;
	
	/**
	 * The interpolated position of the entity from the parent object's position.
	 */
	public var interpolatedPosition(default, null):Point;
	
	/**
	 * If true the position will be interpolated based on the display step size.
	 */
	public var isInterpolated:Bool;
	
	/**
	 * The offset amount of the render from the parent.
	 */
	public var offset:Point;
	
	/**
	 * The center point of the displayable rectangle after prerendering transforms.
	 */
	public var center:Point;
	
	/**
	 * If true then the entity is centered.
	 */
	public var isCentered:Bool;
	
	/**
	 * If set to false, the renderer will not draw this.
	 */
	public var isVisible:Bool;
	
	/**
	 * A generated cache string for operations done on the entity.
	 */
	public var cacheKey:String;
	
	/**
	 * If set to false, this entity will not be cached.
	 */
	public var isCached:Bool;
	
	/**
	 * If set to false, filters will not be applied to the object.
	 */
	public var isProcessed:Bool;
	
	/**
	 * If true, the entity is animated.
	 */
	public var isAnimated(default, null):Bool;
	
	/**
	 * The current frame index.
	 */
	public var animationFrame:Int;
	
	/**
	 * The animation frames of the entity.
	 */
	public var animation:Array<EntityAnimationFrame>;
	
	/**
	 * True when the animation runs through all the loops.
	 */
	public var isAnimationComplete:Bool;
	
	/**
	 * Set to true if any value that effects the display changes.
	 * If true, the renderer will recaclulate the cache before rendering.
	 */
	public var isCacheUpdated:Bool;
	
	/**
	 * Updates the interpolated position.
	 * @param	deltaTime				The time that passed since the last update.
	 */
	public function update(deltaTime:Int, deltaTimeAnimation:Int):Void;
	
	/**
	 * Sets an animation for the entity to be looped over.
	 * @param	animation				The animation to be looped over.
	 * @param	animationFrameTime		The time between each animation frame.
	 * @param	animationLoop			The amount of times to loop through the animation; a value of 0 signifies infinite looping.
	 */
	public function setAnimation(animation:Array < EntityAnimationFrame >, animationLoop:Int = 0):Void;
	
	/**
	 * Stops the animation if playing.
	 */
	public function stopAnimation():Void;
	
	/**
	 * Updates the cache key.
	 */
	public function updateCache():Void;
	
	/**
	 * Should be called when the entity is attached to a node.
	 */
	public function onAttached(node:Node):Void;
}