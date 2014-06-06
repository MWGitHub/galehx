/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.datastructures.quadtree;
import com.exploringlines.gale.apps.math.geom.Rect;

class QuadTreeCollidable implements IQuadTreeCollidable
{
	public var collisionRectangle:Rect;
	public var parent:Dynamic;

	public function new(collisionRectangle:Rect, parent:Dynamic) 
	{
		this.collisionRectangle = collisionRectangle;
		this.parent = parent;
	}
	
}