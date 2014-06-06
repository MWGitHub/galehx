/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * A cached renderable object.
 */
class RendererCacheObject 
{
	/**
	 * The bitmapData of the cached object.
	 */
	public var bitmapData:BitmapData;
	
	/**
	 * The rectangle of the cached object.
	 */
	public var rectangle:Rectangle;
	
	/**
	 * The center of the cached object.
	 * Defaults to the center of the rectangle if not given.
	 */
	public var center:Point;

	public function new(bitmapData:BitmapData, rectangle:Rectangle, ?center:Point) 
	{
		this.bitmapData = bitmapData;
		this.rectangle = rectangle;
		
		if (center != null) {
			this.center = center;
		} else {
			this.center = new Point(rectangle.width / 2, rectangle.height / 2);
		}
	}
}