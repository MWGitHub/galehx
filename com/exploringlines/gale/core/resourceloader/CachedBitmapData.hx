/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.resourceloader;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * A bitmapData that can be reused.
 */
class CachedBitmapData 
{
	/**
	 * The name of the bitmapData.
	 */
	public var name:String;
	
	/**
	 * The bitmapData used when rendering.
	 */
	public var bitmapData:BitmapData;
	
	/**
	 * The rectangle used when rendering.
	 */
	public var rectangle:Rectangle;
	public var center:Point;

	public function new(bitmapData:BitmapData, rectangle:Rectangle, name:String = "Empty") 
	{
		this.bitmapData = bitmapData;
		this.rectangle = rectangle;
		this.name = name;
		center = new Point(rectangle.width / 2, rectangle.height / 2);
	}
	
}