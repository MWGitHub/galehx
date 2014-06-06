/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.math.geom;
import com.exploringlines.gale.core.INode;
import com.exploringlines.gale.core.Node;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.RootScene;
import flash.geom.Rectangle;

/**
 * An extension of the rectangle class with additional offsets.
 */
class Rect extends Rectangle
{
	/**
	 * The x offset of the rectangle.
	 */
	public var offsetX:Float;
	
	/**
	 * The y offset of the rectangle.
	 */
	public var offsetY:Float;
	
	/**
	 * Used to display the rectangle on screen.
	 */
	private var parent:INode;

	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, offsetX:Float = 0, offsetY:Float = 0) 
	{
		super(x, y, width, height);
		
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}
	
	/**
	 * Converts the rect to a rectangle with the offsets added in.
	 * @return	The converted rect.
	 */
	public inline function toRectangle():Rectangle {
		return new Rectangle(x + offsetX, y + offsetY, width, height);
	}
	
	/**
	 * Clones a rectangle with no offsets.
	 * @param	rect	The rectangle to clone.
	 * @return	A new PlatformerRectangle with the same parameters as the cloned rectangle.
	 */
	public static function cloneRectangle(rect:Rectangle):Rect {
		return new Rect(rect.x, rect.y, rect.width, rect.height);
	}
	
}