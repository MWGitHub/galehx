/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import com.exploringlines.gale.apps.math.geom.Vector2;
import flash.display.BitmapData;
import flash.geom.Rectangle;

class EntityAnimationFrame
{
	/**
	 * The rendered display of the frame.
	 */
	public var bitmapData:BitmapData;
	
	/**
	 * The rendered rectangle of the frame.
	 */
	public var rectangle:Rectangle;
	
	/**
	 * The rendered object's name for cache.
	 */
	public var name:String;
	
	/**
	 * The duration of the frame.
	 */
	public var duration:Int;
	
	/**
	 * The x and y offsets for the frame.
	 */
	public var offset:Vector2;

	/**
	 * Represents a frame for use in an entity's animation.
	 * @param	bitmapData The rendered display of the frame.
	 * @param	rectangle The rendered rectangle of the frame.
	 */
	public function new(bitmapData:BitmapData, rectangle:Rectangle, duration:Int, name:String = "", ?offset:Vector2) 
	{
		this.bitmapData = bitmapData;
		this.rectangle = rectangle;
		this.duration = duration;
		this.name = name;
		
		if (offset == null) {
			this.offset = new Vector2();
		} else {
			this.offset = offset;
		}
	}
	
}