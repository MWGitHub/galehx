/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.datastructures.quadtree;
import com.exploringlines.gale.apps.math.geom.Rect;
import flash.Lib;

/**
 * A quadtree that holds IQuadTreeCollidable objects in the nodes.
 */
class QuadTree {
	/**
	 * The root of the quadtree.
	 */
	private var rootNode:QuadTreeNode;
	private var width:Float;
	private var height:Float;
	
	// When true there will be a display for debugging.
	private var isDebugged:Bool;
	
	/**
	 * Creates an empty quadtree with the set parameters.
	 * @param	subdivisions		The amount of times the quadtree is subdivided. A subdivision of 0 indicates only the root node.
	 * @param	x					The x position of where the quadtree begins.
	 * @param	y					The y position of where the quadtree begins.
	 * @param	?width				The width of the quadtree. The default is the stage width.
	 * @param	?height				The height of the quadtree. The default is the stage height.
	 */
	public function new (subdivisions:Int, x:Float = 0, y:Float = 0, ?width:Float, ?height:Float, isDebugged:Bool = false) {
		if (width == null) {
			this.width = Lib.current.stage.stageWidth;
		} else {
			this.width = width;
		}
		if (height == null) {
			this.height = Lib.current.stage.stageHeight;
		} else {
			this.height = height;
		}
		this.isDebugged = isDebugged;
		
		rootNode = new QuadTreeNode(x, y, this.width, this.height, null, isDebugged);
		
		for (i in 0...subdivisions) {
			rootNode.subdivide();
		}
	}
	
	/**
	 * Adds an object to the quadtree.
	 * @param	object				The object to be added to the quadtree must have a rectangle variable.
	 */
	public inline function addObject(object:QuadTreeCollidable):Void {
		rootNode.addObject(object);
	}
	
	/**
	 * Removes an object from the quadtree.
	 * @param	object				The object to remove from the quadtree.
	 */
	public inline function removeObject(object:QuadTreeCollidable):Void {
		rootNode.removeObject(object);
	}
	
	/**
	 * Returns the objects within the nodes the object to be tested resides.
	 * @param	object				The object to be tested.
	 * @return						The objects that are in the collided nodes.
	 */
	public inline function getCollidableObjects(object:QuadTreeCollidable, areDuplicatesRemoved:Bool = false):Array<QuadTreeCollidable> {
		if (!areDuplicatesRemoved) {
			return rootNode.getCollidableObjects(object);
		} else {
			var objects:Array<QuadTreeCollidable> = rootNode.getCollidableObjects(object);
			var uniqueObjects:Array<QuadTreeCollidable> = [];
			var containsObjects:Bool;
			for (i in 0...objects.length) {
				containsObjects = false;
				for (j in 0...uniqueObjects.length) {
					if (objects[i] == uniqueObjects[j]) {
						containsObjects = true;
						break;
					}
				}
				if (!containsObjects) {
					uniqueObjects.push(objects[i]);
				}
			}
			return uniqueObjects;
		}
	}
	
	/**
	 * Retreives the collidable objects in a rect.
	 * @param	rect					The area to test.
	 * @param	areDuplicatesRemoved	If true then duplicates are removed.
	 * @return	The collided objects.
	 */
	public inline function getCollidableObjectsInRect(rect:Rect, areDuplicatesRemoved:Bool = false):Array<QuadTreeCollidable> {
		if (!areDuplicatesRemoved) {
			return rootNode.getCollidableObjectsInRect(rect);
		} else {
			var objects:Array<QuadTreeCollidable> = rootNode.getCollidableObjectsInRect(rect);
			var uniqueObjects:Array<QuadTreeCollidable> = [];
			var containsObjects:Bool;
			for (i in 0...objects.length) {
				containsObjects = false;
				for (j in 0...uniqueObjects.length) {
					if (objects[i] == uniqueObjects[j]) {
						containsObjects = true;
						break;
					}
				}
				if (!containsObjects) {
					uniqueObjects.push(objects[i]);
				}
			}
			return uniqueObjects;
		}
	}
	
	/**
	 * Removes all objects from the quadtree.
	 */
	public inline function removeAllObjects():Void {
		rootNode.removeAllObjects();
	}
	
	/**
	 * Returns all objects in the tree with duplicates removed.
	 * @return	The objects in the tree.
	 */
	/*
	public inline function getObjects():Array<QuadTreeCollidable> {
		return getCollidableObjects(new QuadTreeCollidable(new Rect(0, 0, width, height)), true);
	}
	*/
}