/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.datastructures.quadtree;
import com.exploringlines.gale.apps.math.geom.Rect;
import com.exploringlines.gale.core.Globals;
import flash.display.Shape;
import flash.Lib;

/**
 * The node of the quadtree.
 */
class QuadTreeNode {
	public var x:Float;
	private var y:Float;
	private var width:Float;
	private var height:Float;
	private var maxX:Float;
	private var maxY:Float;
	private var subnodes:Array<QuadTreeNode>;
	private var collidables:Array<QuadTreeCollidable>;
	
	// When true the node will be displayed.
	private var isDebugged:Bool;
	private var debugShape:Shape;
	
	/**
	 * Creates an empty node.
	 * @param	x				The x location of the node.
	 * @param	y				The y location of the node.
	 * @param	width			The width of the node.
	 * @param	height			The height of the node.
	 * @param	?subnodes		The subnodes, if any.
	 */
	public function new(x:Float, y:Float, width:Float, height:Float, ?subnodes:Array<QuadTreeNode>, isDebugged:Bool = false) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.subnodes = subnodes;
		this.isDebugged = isDebugged;
		collidables = [];
		
		maxX = x + width;
		maxY = y + height;
		
		if (isDebugged) {
			debugShape = new Shape();
			Globals.stage.addChild(debugShape);
		}
	}
	
	/**
	 * Creates four children nodes split equally within the parent node if the node has no children.
	 */
	public function subdivide() {
		if (subnodes == null) {
			subnodes = [];
			var width:Float = this.width/2;
			var height:Float = this.height/2;
			
			subnodes.push(new QuadTreeNode(x, y, width, height, null, isDebugged));
			subnodes.push(new QuadTreeNode(x + width, y, width, height, null, isDebugged));
			subnodes.push(new QuadTreeNode(x + width, y + height, width, height, null, isDebugged));
			subnodes.push(new QuadTreeNode(x, y + height, width, height, null, isDebugged));
		} else {
			for (i in 0...4) {
				subnodes[i].subdivide();
			}
		}
	}
	
	/**
	 * Adds an object to the quadtree.
	 * @param	object				The object to be added to the quadtree must have a rectangle variable.
	 */
	public function addObject(object:QuadTreeCollidable):Void {
		if (subnodes == null) {
			collidables.push(object);
			
			if (isDebugged) {
				drawRegions();
			}
		} else {
			var subnodeCollide:Array<Int> = [];
			var sumX:Float, sumY:Float, centerX:Float, centerY:Float;
			for (i in 0...4) {
				sumX = subnodes[i].width + object.collisionRectangle.width;
				sumY = subnodes[i].height + object.collisionRectangle.height;
				centerX = (object.collisionRectangle.x + object.collisionRectangle.right) - (subnodes[i].x + subnodes[i].maxX);
				centerY = (object.collisionRectangle.y + object.collisionRectangle.bottom) - (subnodes[i].y + subnodes[i].maxY);
				
				if (centerX < 0) {
					centerX *= -1;
				}
				if (centerY < 0) {
					centerY *= -1;
				}
				if (centerX < sumX && centerY < sumY) {
					subnodeCollide.push(i);
				}
			}
			
			for (i in 0...subnodeCollide.length) {
				subnodes[subnodeCollide[i]].addObject(object);
			}
		}
	}
	
	/**
	 * Removes an object from the node.
	 * @param	object				The object to remove.
	 */
	public inline function removeObject(object:QuadTreeCollidable):Void {
	}
	
	/**
	 * Returns the objects within the nodes the object to be tested resides.
	 * @param	object				The object to be tested.
	 * @return						The objects that are in the collided nodes.
	 */
	public function getCollidableObjects(object:QuadTreeCollidable):Array<QuadTreeCollidable> {
		if (subnodes == null) {
			return collidables;
		} else {
			var collidedObjects:Array<QuadTreeCollidable> = [];
			var subnodeCollide:Array<Int> = [];
			var sumX:Float, sumY:Float, centerX:Float, centerY:Float;
			for (i in 0...subnodes.length) {
				sumX = subnodes[i].width + object.collisionRectangle.width;
				sumY = subnodes[i].height + object.collisionRectangle.height;
				centerX = (object.collisionRectangle.x + object.collisionRectangle.right) - (subnodes[i].x + subnodes[i].maxX);
				centerY = (object.collisionRectangle.y + object.collisionRectangle.bottom) - (subnodes[i].y + subnodes[i].maxY);
				
				if (centerX < 0) {
					centerX *= -1;
				}
				if (centerY < 0) {
					centerY *= -1;
				}
				if (centerX * centerX < sumX * sumX && centerY * centerY < sumY * sumY) {
					subnodeCollide.push(i);
				}
			}
			
			for (i in 0...subnodeCollide.length) {
				collidedObjects = collidedObjects.concat(subnodes[subnodeCollide[i]].getCollidableObjects(object));
			}
			
			return collidedObjects;
		}
	}
	
	/**
	 * Retrieves collidable objects in a rectangle.
	 * @param	rect	The area to check.
	 * @return	The collided nodes.
	 */
	public function getCollidableObjectsInRect(rect:Rect):Array<QuadTreeCollidable> {
		if (subnodes == null) {
			return collidables;
		} else {
			var collidedObjects:Array<QuadTreeCollidable> = [];
			var subnodeCollide:Array<Int> = [];
			var sumX:Float, sumY:Float, centerX:Float, centerY:Float;
			for (i in 0...subnodes.length) {
				sumX = subnodes[i].width + rect.width;
				sumY = subnodes[i].height + rect.height;
				centerX = (rect.x + rect.right) - (subnodes[i].x + subnodes[i].maxX);
				centerY = (rect.y + rect.bottom) - (subnodes[i].y + subnodes[i].maxY);
				
				if (centerX < 0) {
					centerX *= -1;
				}
				if (centerY < 0) {
					centerY *= -1;
				}
				if (centerX * centerX < sumX * sumX && centerY * centerY < sumY * sumY) {
					subnodeCollide.push(i);
				}
			}
			
			for (i in 0...subnodeCollide.length) {
				collidedObjects = collidedObjects.concat(subnodes[subnodeCollide[i]].getCollidableObjectsInRect(rect));
			}
			
			return collidedObjects;
		}
	}
	
	/**
	 * Removes all objects from the quadtree.
	 */
	public function removeAllObjects():Void {
		if (subnodes == null) {
			collidables = [];
		} else {
			for (i in 0...subnodes.length) {
				subnodes[i].removeAllObjects();
			}
		}
		
		if (isDebugged) {
			debugShape.graphics.clear();
		}
	}
	
	/**
	 * Draws the current node as a rectangle with a random color.
	 */
	public inline function drawRegions():Void {
		
		var color:Int = Math.floor(Math.random() * 10);
		var col:UInt = 0xFFFFFF;
		switch (color) {
			case 0: col = 0xFFFF66;
			case 1: col = 0x66FFFF;
			case 2: col = 0xFF66FF;
			case 3: col = 0xFF3366;
			case 4: col = 0x33FF66;
			case 5: col = 0xFFFFFF;
			case 6: col = 0x2FA266;
			case 7: col = 0x66FC66;
			case 8: col = 0xFCFA66;
			case 9: col = 0xFAAF66;
			case 10: col = 0xFFAF6C;
		}
		
		debugShape.graphics.beginFill(col, 0.3);
		debugShape.graphics.drawRect(x+1, y+1, this.width-2, this.height-2);
	}
}