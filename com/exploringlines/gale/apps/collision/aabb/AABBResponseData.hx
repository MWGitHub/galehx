/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.collision.aabb;

class AABBResponseData 
{
	/**
	 * True if the object has collided.
	 */
	public var hasCollided:Bool;
	
	/**
	 * A depth greater than 0 means collision from the right where the collider is to the right of the collidee.
	 */
	public var depthX:Float;
	
	/**
	 * A depth greater than 0 means collision from the bottom where the collider to below the collidee.
	 */
	public var depthY:Float;
	
	/**
	 * Custom data for the response.
	 */
	public var data:Dynamic;

	public function new() 
	{
		hasCollided = false;
		depthX = 0;
		depthY = 0;
	}
	
}