/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.collision.aabb;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.geom.Rect;
import flash.geom.Rectangle;

/**
 * Handles the collision response of rectangles and returns the corrected one for the non-static object.
 */
class AABBResolve
{
	private static inline var DIRECTION_LEFT:Int = -1;
	private static inline var DIRECTION_RIGHT:Int = 1;
	private static inline var DIRECTION_UP:Int = -1;
	private static inline var DIRECTION_DOWN:Int = 1;
	private static inline var DIRECTION_NONE:Int = 0;
	private static inline var MAX_VALUE:Float = 10000;
	
	private static var verticalCollidable:Rectangle;
	private static var horizontalCollidable:Rectangle;
	private static var correctedRectangle:Rectangle;
	
	/**
	 * Checks if tiles are colliding with the collider.
	 * @param	tiles		The tiles to check.
	 * @param	collider	The object to check.
	 * @return	Returns true if the collider is colliding with a tile.
	 */
	private static inline function isCollidingWithCollidables(collidables:Array<Rectangle>, collider:Rectangle):Bool {
		var isColliding:Bool = false;
		for (i in 0...collidables.length) {
			if (AABBCheck.checkCollision(collider, collidables[i]).hasCollided) {
				isColliding = true;
				break;
			}
		}
		
		return isColliding;
	}
	
	/**
	 * Moves the position of the collider depending on the depth and direction.
	 * @param	collider				The colliding object to correct.
	 * @param	depth					The amount to move the colliding object.
	 * @param	correctHorizontal		If true then the correction will be horizontal, else vertical.
	 */
	private static inline function correctCollision(collider:Rectangle, depth:Float, correctHorizontal:Bool):Void {
		if (depth != MAX_VALUE) {
			if (correctHorizontal) {
				correctedRectangle.x += depth;
			}
			else {
				correctedRectangle.y += depth;
			}
		}
	}
	
	/**
	 * Calculates the smallest depth in from either the left or right side in the X axis.
	 * @param	directionX		The direction to get the depth from.
	 * @param	tileResponses	The tiles to check the depth of.
	 * @return	The smallest depth in the X axis depending on the direction.
	 */
	private static inline function getSmallestDepthX(directionX:Int, collidableResponses:Array<AABBResponseData>):Float {
		var smallest:Float = MAX_VALUE;
		
		for (i in 0...collidableResponses.length) {
			var absSmallest:Float = GaleMath.absFloat(smallest);
			//trace("Smallest X: " + directionX + "		Depth: " + tileResponses[i].depthX + "		Smallest: " + smallest + "		Abs Smallest: " + absSmallest);
			if (directionX == DIRECTION_LEFT && collidableResponses[i].depthX < 0 && GaleMath.absFloat(collidableResponses[i].depthX) < absSmallest) {
				smallest = collidableResponses[i].depthX;
				horizontalCollidable = collidableResponses[i].data;
			}
			else if (directionX == DIRECTION_RIGHT && collidableResponses[i].depthX > 0 && GaleMath.absFloat(collidableResponses[i].depthX) < absSmallest) {
				smallest = collidableResponses[i].depthX;
				horizontalCollidable = collidableResponses[i].data;
			}
		}
		
		return smallest;
	}
	
	/**
	 * Calculates the smallest depth in from either the left or right side in the Y axis.
	 * @param	directionX		The direction to get the depth from.
	 * @param	tileResponses	The tiles to check the depth of.
	 * @return	The smallest depth in the Y axis depending on the direction.
	 */
	private static inline function getSmallestDepthY(directionY:Int, collidableResponses:Array<AABBResponseData>):Float {
		var smallest:Float = MAX_VALUE;
		
		for (i in 0...collidableResponses.length) {
			var absSmallest:Float = GaleMath.absFloat(smallest);
			if (directionY == DIRECTION_LEFT && collidableResponses[i].depthY < 0 && GaleMath.absFloat(collidableResponses[i].depthY) < absSmallest) {
				smallest = collidableResponses[i].depthY;
				verticalCollidable = collidableResponses[i].data;
			}
			else if (directionY == DIRECTION_RIGHT && collidableResponses[i].depthY > 0 && GaleMath.absFloat(collidableResponses[i].depthY) < absSmallest) {
				smallest = collidableResponses[i].depthY;
				horizontalCollidable = collidableResponses[i].data;
			}
		}
		
		return smallest;
	}
	
	/**
	 * Resolves the collision of tiles touching the collider.
	 * @param	tiles		The tiles to check.
	 * @param	collider	The collider to check.
	 * @return	Returns true if there are collisions.
	 */
	private static inline function resolveCollidableCollisionStep(collidables:Array<Rectangle>, collider:Rectangle):Bool {
		var collidingObjects:Array<AABBResponseData> = [];
		var horizontalSum:Int = 0;
		var verticalSum:Int = 0;
		var directionX:Int = DIRECTION_NONE;
		var directionY:Int = DIRECTION_NONE;
		
		for (i in 0...collidables.length) {
			var response:AABBResponseData = AABBCheck.checkCollision(collider, collidables[i]);
			response.data = collidables[i];
			if (response.hasCollided) {
				collidingObjects.push(response);
				if (response.depthX > 0) {
					horizontalSum += DIRECTION_RIGHT;
				} else if (response.depthX < 0) {
					horizontalSum += DIRECTION_LEFT;
				}
				if (response.depthY > 0) {
					verticalSum += DIRECTION_DOWN;
				} else if (response.depthY < 0) {
					verticalSum += DIRECTION_UP;
				}
			}
		}
		
		if (horizontalSum <= DIRECTION_LEFT)
			directionX = DIRECTION_LEFT;
		else if (horizontalSum >= DIRECTION_RIGHT)
			directionX = DIRECTION_RIGHT;
		else
			directionX = DIRECTION_NONE;
			
		if (verticalSum <= DIRECTION_UP)
			directionY = DIRECTION_UP;
		else if (verticalSum >= DIRECTION_DOWN)
			directionY = DIRECTION_DOWN;
		else
			directionY = DIRECTION_NONE;
			
		// The amount to move the object's position by.
		if (collidingObjects.length > 0) {
			var smallestCorrectionX:Float = getSmallestDepthX(directionX, collidingObjects);
			var smallestCorrectionY:Float = getSmallestDepthY(directionY, collidingObjects);
			//trace(smallestCorrectionX + "	" + smallestCorrectionY + "	" + horizontalSum + "	" + verticalSum);
			
			// If the object collides more on the Y axis then first resolve on the Y
			if (GaleMath.absInt(verticalSum) > GaleMath.absInt(horizontalSum)) {
				correctCollision(collider, smallestCorrectionY, false);
				if (isCollidingWithCollidables(collidables, collider))
					correctCollision(collider, smallestCorrectionX, true);
				else
					directionX = DIRECTION_NONE;
			} else if (GaleMath.absInt(horizontalSum) > GaleMath.absInt(verticalSum)) {
				correctCollision(collider, smallestCorrectionX, true);
				if (isCollidingWithCollidables(collidables, collider))
					correctCollision(collider, smallestCorrectionY, false);
				else
					directionY = DIRECTION_NONE;
			}
			else { // When both vertical and horizontal sums are equal
				if (GaleMath.absFloat(smallestCorrectionX) > GaleMath.absFloat(smallestCorrectionY)) {
					correctCollision(collider, smallestCorrectionY, false);
					if (isCollidingWithCollidables(collidables, collider))
						correctCollision(collider, smallestCorrectionX, true);
					else
						directionX = DIRECTION_NONE;
				} else {
					correctCollision(collider, smallestCorrectionX, true);
					if (isCollidingWithCollidables(collidables, collider))
						correctCollision(collider, smallestCorrectionY, false);
					else
						directionY = DIRECTION_NONE;
				}
			}
		}
		
		var hasCollided:Bool = false;
		if (horizontalSum != 0 || verticalSum != 0)
			hasCollided = true;
		return hasCollided;
	}
	
	/**
	 * Resolves tile collisions with the collider.
	 * @param	tiles		The tiles to check.
	 * @param	collider	The colliding object.
	 */
	public static inline function resolveCollisions(collidables:Array<Rectangle>, collider:Rectangle, colliderLast:Rectangle = null, steps:Int = 10):Rectangle {
		correctedRectangle = collider.clone();
		if (colliderLast != null) {
			var hasCollided:Bool = false;
			for (i in 1...steps) {
				correctedRectangle.x = colliderLast.x + (collider.x - colliderLast.x) * i / steps;
				correctedRectangle.y = colliderLast.y + (collider.y - colliderLast.y) * i / steps;
				if (resolveCollidableCollisionStep(collidables, correctedRectangle)) {
					hasCollided = true;
					break;
				}
			}
			if (!hasCollided) {
				correctedRectangle.x = collider.x;
				correctedRectangle.y = collider.y;
			}
		} else {
			resolveCollidableCollisionStep(collidables, correctedRectangle);
		}
		return correctedRectangle;
	}
	
	public static inline function resolveCollisionsSimple(collidables:Array<Rectangle>, collider:Rectangle):Rectangle {
		correctedRectangle = collider.clone();
		for (i in 0...collidables.length) {
			var collisionData:AABBResponseData = AABBCheck.checkCollision(collidables[i], collider);
			if (collisionData.hasCollided) {
				if (GaleMath.absFloat(collisionData.depthY) < GaleMath.absFloat(collisionData.depthX)) {
					correctedRectangle.y -= collisionData.depthY;
				} else {
					correctedRectangle.x -= collisionData.depthX;
				}
			}
		}
		
		return correctedRectangle;
	}
}