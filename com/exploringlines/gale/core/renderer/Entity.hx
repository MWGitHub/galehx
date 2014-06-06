/**
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import com.exploringlines.gale.core.Node;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * A displayable object used for rendering. Requires it to be attached to a parent object in order to be displayed.
 * An entity may only have one parent.
 */
class Entity implements IEntity
{
	private static var indexCounter:Int = 0;
	
	/**
	 * The index of the entity. Each entity has a unique index.
	 */
	public var index(default, null):Int;
	
	/**
	 * The name of the entity. This is used when finding cached renders.
	 */
	public var name:String;
	
	/**
	 * The layer the entity is on.
	 * This is overridden when using the z position.
	 */
	public var layer:Int;
	
	/**
	 * @inheritDoc
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
	 * The bitmap retrieved from cache.
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
	 * @inheritDoc
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
	 * If set to false, filters will not apply to this object.
	 */
	public var isProcessed:Bool;
	
	/**
	 * If true, the entity is animated.
	 */
	public var isAnimated(default, null):Bool;
	public var animationFrame:Int;
	
	/**
	 * The animation frames of the entity.
	 */
	public var animation:Array<EntityAnimationFrame>;
	private var animationLoop:Int;
	private var animationTimeCounter:Int;
	private var animationLoopCounter:Int;
	
	/**
	 * True when the animation runs through all the loops.
	 */
	public var isAnimationComplete:Bool;
	
	/**
	 * @inheritDoc
	 */
	public var isCacheUpdated:Bool;
	
	/**
	 * An entity is a renderable object which stores information about the display to use and the parent position.
	 * @param	name					The name of the entity, used for caching.
	 * @param	bitmapData				The display to use when rendering.
	 * @param	rectangle				The rectangle to use when rendering.
	 * @param	?offset					The offset of the entity compared to the parent.
	 */
	public function new(name:String = "Empty", ?bitmapData:BitmapData, ?rectangle:Rectangle, ?offset:Point, layer:Int = 0) 
	{
		interpolatedPosition = new Point(0, 0);
		center = new Point(0, 0);
		isCentered = true;
		isInterpolated = true;
		
		this.name = name;
		this.bitmapData = bitmapData;
		isCached = true;
		isProcessed = true;
		
		if (rectangle != null) {
			this.rectangle = rectangle;
			center.x = Std.int(rectangle.width / 2);
			center.y = Std.int(rectangle.height / 2);
		}
		
		if (offset != null) {
			this.offset = offset;
		} else {
			this.offset = new Point(0, 0);
		}
		
		this.layer = layer;
		stageLayer = 0;
		
		isAnimated = false;
		
		index = indexCounter;
		indexCounter++;
		
		isVisible = true;
		
		cacheKey = "Empty";
		isCacheUpdated = true;
	}
	
	/**
	 * Updates the interpolated position.
	 * @param	deltaTime	The time that passed since the last update.
	 */
	private inline function updatePosition(deltaTime:Int):Void {
		if (isInterpolated) {
			interpolatedPosition.x = parent.derivedPosition.x + parent.derivedSpeed.x * deltaTime / 1000 + offset.x;
			interpolatedPosition.y = parent.derivedPosition.y + parent.derivedSpeed.y * deltaTime / 1000 + offset.y;
		} else {
			interpolatedPosition.x = parent.derivedPosition.x + offset.x;
			interpolatedPosition.y = parent.derivedPosition.y + offset.y;
		}
	}
	
	/**
	 * Updates the interpolated position.
	 * @param	deltaTime				The time that passed since the last update.
	 */
	public function update(deltaTime:Int, deltaTimeAnimation:Int):Void {
		if (isAnimated) {
			animationTimeCounter += deltaTimeAnimation;
			while (animationTimeCounter >= animation[animationFrame].duration && !isAnimationComplete) {
				if (animationFrame < animation.length-1) {
					animationFrame++;
					center.x = animation[animationFrame].rectangle.width / 2;
					center.y = animation[animationFrame].rectangle.height / 2;
					offset.x = animation[animationFrame].offset.x;
					offset.y = animation[animationFrame].offset.y;
					isCacheUpdated = true;
				} else {
					animationFrame = 0;
					animationLoopCounter++;
					if (animationLoopCounter >= animationLoop && animationLoop != 0) {
						animationFrame = animation.length - 1;
						isAnimationComplete = true;
						isAnimated = false;
					}
					center.x = animation[animationFrame].rectangle.width / 2;
					center.y = animation[animationFrame].rectangle.height / 2;
					offset.x = animation[animationFrame].offset.x;
					offset.y = animation[animationFrame].offset.y;
					isCacheUpdated = true;
				}
				bitmapData = animation[animationFrame].bitmapData;
				rectangle = animation[animationFrame].rectangle;
				name = animation[animationFrame].name;
				//updateCache();
				animationTimeCounter -= animation[animationFrame].duration;
			}
		}
		
		updatePosition(deltaTime);
	}
	
	/**
	 * Sets an animation for the entity to be looped over.
	 * @param	animation				The animation to be looped over.
	 * @param	animationFrameTime		The time between each animation frame.
	 * @param	animationLoop			The amount of times to loop through the animation; a value of 0 signifies infinite looping.
	 */
	public function setAnimation(animation:Array < EntityAnimationFrame >, animationLoop:Int = 0):Void {
		this.animation = animation;
		this.animationLoop = animationLoop;
		animationFrame = 0;
		animationTimeCounter = 0;
		animationLoopCounter = 0;
		isAnimationComplete = false;
		
		isAnimated = true;
		
		bitmapData = animation[animationFrame].bitmapData;
		rectangle = animation[animationFrame].rectangle;
		name = animation[animationFrame].name;
		offset.x = animation[animationFrame].offset.x;
		offset.y = animation[animationFrame].offset.y;
	}
	
	public function stopAnimation():Void {
		if (isAnimated) {
			isAnimated = false;
			bitmapData = animation[0].bitmapData;
			rectangle = animation[0].rectangle;
		}
	}
	
	public inline function setRectangle(r:Rectangle):Rectangle {
		rectangle = r;
		
		center.x = rectangle.width / 2;
		center.y = rectangle.height / 2;
		
		return r;
	}
	
	private inline function setRendererCacheObject(v:RendererCacheObject):RendererCacheObject {
		rendererCacheObject = v;
		
		return rendererCacheObject;
	}
	
	/**
	 * Sets the image of the entity.
	 * @param	bitmapData	The image to set it to.
	 * @param	name		The name of the image for cache usage.
	 */
	public inline function setImage(bitmapData:BitmapData, name:String):Void {
		this.bitmapData = bitmapData;
		this.rectangle = bitmapData.rect;
		this.name = name;
		isCacheUpdated = true;
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function updateCache():Void {
		if (isCacheUpdated) {
			if (isCached || isProcessed) {
				if (name != "") {
					cacheKey = "name=" + name + 
							   ";color=" + parent.alpha + "," + parent.redOffset + "," + parent.greenOffset + "," + parent.blueOffset + 
							   ";scale=" + (parent.derivedScaleX * parent.cameraScaleX) + "," + (parent.derivedScaleY * parent.cameraScaleY) + "," + parent.flipHorizontal + "," + parent.flipVertical + 
							   ";rotation=" + (parent.derivedRotation + parent.cameraRotation);
				} else {
					cacheKey = "Empty";
				}
			}
		}
	}
	
	public function onAttached(node:Node):Void {
		parent = node;
	}
}