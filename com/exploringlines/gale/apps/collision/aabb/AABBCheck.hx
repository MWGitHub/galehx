/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.collision.aabb;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.geom.Vector2;
import flash.geom.Rectangle;

/**
 * Checks two rectangles for collision and returns the response data.
 */
class AABBCheck 
{
	/**
	 * Checks two rectangles for collision.
	 * @param	mainCollider		An object to check, the depth is relative to this object.
	 * @param	testedCollider		Another object to check
	 * @return	The response data.
	 */
	public static inline function checkCollision(mainCollider:Rectangle, testedCollider:Rectangle):AABBResponseData {
		var aabbResponseData:AABBResponseData = new AABBResponseData();
		
		// Test the x-axis
		if (GaleMath.absFloat((testedCollider.x + testedCollider.right) - (mainCollider.x + mainCollider.right)) < mainCollider.width + testedCollider.width) {
			// Test the y-axis
			if (GaleMath.absFloat((testedCollider.y + testedCollider.bottom) - (mainCollider.y + mainCollider.bottom)) < mainCollider.height + testedCollider.height) {
				var halfWidthMain:Float = mainCollider.width / 2;
				var halfHeightMain:Float = mainCollider.height / 2;
				var halfWidthTested:Float = testedCollider.width / 2;
				var halfHeightTested:Float = testedCollider.height / 2;
				var distanceX = (mainCollider.x + halfWidthMain) - (testedCollider.x + halfWidthTested);
				var distanceY = (mainCollider.y + halfHeightMain) - (testedCollider.y + halfHeightTested);
				aabbResponseData.depthX = distanceX > 0 ? halfWidthMain + halfWidthTested - distanceX : -(halfWidthMain + halfWidthTested) - distanceX;
				aabbResponseData.depthY = distanceY > 0 ? halfHeightMain + halfHeightTested - distanceY : -(halfHeightMain + halfHeightTested) - distanceY;
				
				aabbResponseData.hasCollided = true;
			}
		}
		
		return aabbResponseData;
	}
	
	/**
	 * Checks if a point is in the collider rectangle.
	 * @param	point		The point to check.
	 * @param	collider	The collider rectangle.
	 * @return	True if collided, false otherwise.
	 */
	public static inline function checkCollisionPoint(point:Vector2, collider:Rectangle):Bool {
		var hasCollided:Bool = false;
		if (point.x >= collider.x && point.x <= collider.x + collider.width &&
			point.y >= collider.y && point.y <= collider.y + collider.height) {
				hasCollided = true;
			}
		return hasCollided;
	}
}