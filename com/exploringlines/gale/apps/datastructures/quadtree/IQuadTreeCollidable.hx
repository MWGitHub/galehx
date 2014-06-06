/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.datastructures.quadtree;
import com.exploringlines.gale.apps.math.geom.Rect;
import flash.geom.Rectangle;

/**
 * An interface for a quadtree object.
 */
interface IQuadTreeCollidable 
{
	/**
	 * The collision used when placing the object into a quadtree.
	 */
	public var collisionRectangle:Rect;
}