/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.sort.InsertionSort;
import com.exploringlines.gale.core.renderer.IRenderable;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.renderer.IEntity;
import haxe.FastList;

/**
 * @inheritDoc
 */
class Node implements INode
{
	private static var indexCounter:Int = 0;
	
	/**
	 * @inheritDoc
	 */
	public var index(default, null):Int;
	
	/**
	 * @inheritDoc
	 */
	public var name:String;
	
	/**
	 * @inheritDoc
	 */
	public var isRemoved(default, setIsRemoved):Bool;
	
	/**
	 * @inheritDoc
	 */
	public var isLocked(default, setIsLocked):Bool;
	
	/**
	 * @inheritDoc
	 */
	public var isVisible(default, setIsVisible):Bool;
	
	/**
	 * @inheritDoc
	 */
	public var parent:INode;
	
	/**
	 * @inheritDoc
	 */
	public var children:haxe.FastList<INode>;
	
	/**
	 * @inheritDoc
	 */
	public var entities:haxe.FastList<IEntity>;
	
	/**
	 * Components for the node.
	 */
	public var areComponentsSorted:Bool;
	private var preUpdateComponents:FastList<INodeComponent>;
	private var postUpdateComponents:FastList<INodeComponent>;
	
	/**
	 * @inheritDoc
	 */
	public var serializedEntities:Array<IEntity>;
	
	/**
	 * @inheritDoc
	 */
	public var position:Vector2;
	public var derivedPosition:Vector2;
	
	/**
	 * @inheritDoc
	 */
	public var speed:Vector2;
	public var derivedSpeed:Vector2;
	
	// If true then the position will be updated depending on the speed.
	public var isInterpolated:Bool;
	
	/**
	 * @inheritDoc
	 */
	public var derivedRotation:Dynamic;
	public var rotation(default, setRotation):Dynamic;
	public var cameraRotation(default, setCameraRotation):Dynamic;
	
	/**
	 * @inheritDoc
	 */
	public var alpha(default, setAlpha):Dynamic;
	
	/**
	 * @inheritDoc
	 */
	public var derivedScaleX:Dynamic;
	public var derivedScaleY:Dynamic;
	public var scaleX(default, setScaleX):Dynamic;
	public var scaleY(default, setScaleY):Dynamic;
	public var cameraScaleX(default, setCameraScaleX):Dynamic;
	public var cameraScaleY(default, setCameraScaleY):Dynamic;
	
	/**
	 * @inheritDoc
	 */
	public var flipHorizontal(default, setFlipHorizontal):Dynamic;
	public var flipVertical(default, setFlipVertical):Dynamic;
	
	/**
	 * @inheritDoc
	 */
	public var redOffset(default, setRedOffset):Dynamic;
	public var greenOffset(default, setGreenOffset):Dynamic;
	public var blueOffset(default, setBlueOffset):Dynamic;
	
	/**
	 * The first check to see if the entity cache should be updated.
	 */
	private var isCacheUpdated:Bool;
	
	/**
	 * Creates a new node.
	 * @param	?position	The position of the node, the default is x=0, y=0.
	 * @param	?speed		The speed of the node, the default is x=0, y=0.
	 */
	public function new(?position:Vector2, ?speed:Vector2) 
	{
		name = "";
		children = new FastList<INode>();
		entities = new FastList<IEntity>();
		preUpdateComponents = new FastList<INodeComponent>();
		postUpdateComponents = new FastList<INodeComponent>();
		serializedEntities = [];
		
		index = indexCounter;
		indexCounter++;
		isRemoved = false;
		isLocked = false;
		isVisible = true;
		areComponentsSorted = false;
		
		if (position != null) {
			this.position = position;
		} else {
			this.position = new Vector2();
		}
		
		if (speed != null) {
			this.speed = speed;
		} else {
			this.speed = new Vector2();
		}
		
		derivedPosition = this.position.clone();
		derivedSpeed = this.speed.clone();
		isInterpolated = true;
		
		derivedRotation = 0;
		rotation = 0;
		cameraRotation = 0;
		alpha = 1;
		derivedScaleX = 1;
		derivedScaleY = 1;
		scaleX = 1;
		scaleY = 1;
		cameraScaleX = 1;
		cameraScaleY = 1;
		flipHorizontal = false;
		flipVertical = false;
		redOffset = 0;
		greenOffset = 0;
		blueOffset = 0;
		
		isCacheUpdated = true;
	}
	
	/**
	 * @inheritDoc
	 */
	public function update(deltaTime:Int = 0):Void {
		updatePreComponents(deltaTime);
		updatePosition(deltaTime);
		updatePostComponents(deltaTime);
		updatePreCache(deltaTime);
		updateCache();
	}
	
	/**
	 * Updates components.
	 * @param	deltaTime	Time step
	 */
	private inline function updatePreComponents(deltaTime:Int = 0):Void {
		var iter = preUpdateComponents.head;
		while (iter != null) {
			iter.elt.update(deltaTime);
			if (iter.elt.isComplete) {
				if (iter.elt.completeCallback != null) {
					iter.elt.completeCallback(iter.elt);
				}
				removeComponent(iter.elt);
			}
			iter = iter.next;
		}
	}
	
	/**
	 * Updates components.
	 * @param	deltaTime	Time step
	 */
	private inline function updatePostComponents(deltaTime:Int = 0):Void {
		var iter = postUpdateComponents.head;
		while (iter != null) {
			iter.elt.update(deltaTime);
			if (iter.elt.isComplete) {
				if (iter.elt.completeCallback != null) {
					iter.elt.completeCallback(iter.elt);
				}
				removeComponent(iter.elt);
			}
			iter = iter.next;
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function updatePosition(deltaTime:Int):Void {
		if (parent == null) {
			derivedSpeed.x = speed.x;
			derivedSpeed.y = speed.y;
			if (isInterpolated) {
				derivedPosition.x = position.x + speed.x * deltaTime / 1000;
				derivedPosition.y = position.y + speed.y * deltaTime / 1000;
			} else {
				derivedPosition.x = position.x;
				derivedPosition.y = position.y;
			}
			position.x = derivedPosition.x;
			position.y = derivedPosition.y;
		} else {
			derivedSpeed.x = parent.derivedSpeed.x + speed.x;
			derivedSpeed.y = parent.derivedSpeed.y + speed.y;
			if (isInterpolated) {
				position.x += speed.x * deltaTime / 1000;
				position.y += speed.y * deltaTime / 1000;
			}
			derivedPosition.x = parent.derivedPosition.x + position.x;
			derivedPosition.y = parent.derivedPosition.y + position.y;
		}
		
		var iter;
		iter = children.head;
		while (iter != null) {
			iter.elt.update(deltaTime);
			iter = iter.next;
		}
	}
	
	/**
	 * Runs before the cache is updated.
	 * @param	deltaTime	The time passed since the last update.
	 */
	public function updatePreCache(deltaTime:Int = 0):Void {
		
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function updateCache():Void {
		if (isCacheUpdated) {
			var iter = entities.head;
			while (iter != null) {
				iter.elt.isCacheUpdated = true;
				iter = iter.next;
			}
		}

		isCacheUpdated = false;
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function addChild(child:INode):Void {
		child.parent = this;
		child.isRemoved = isRemoved;
		child.isVisible = isVisible;
		child.isLocked = isLocked;
		child.isInterpolated = isInterpolated;
		
		child.derivedRotation = derivedRotation + child.rotation;
		child.derivedScaleX = derivedScaleX * child.scaleX;
		child.derivedScaleY = derivedScaleY * child.scaleY;
		child.alpha = alpha;
		child.redOffset = redOffset;
		child.greenOffset = greenOffset;
		child.blueOffset = blueOffset;
		children.add(child);
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function removeChild(child:INode):Void {
		children.remove(child);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeAllChildren():Void {
		children = new haxe.FastList<INode>();
	}
	
	/**
	 * @inheritDoc
	 */
	public function attachObject(object:IEntity):IEntity {
		entities.add(object);
		object.onAttached(this);
		serializedEntities.push(object);
		
		return object;
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeObject(object:IEntity):IEntity {
		entities.remove(object);
		object.parent = null;
		rebuildEntities();
		
		return object;
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeAllObjects():Void {
		var iter = entities.head;
		while (iter != null) {
			iter.elt.parent = null;
			iter = iter.next;
		}
		entities = new FastList<IEntity>();
		serializedEntities = [];
	}
	
	/**
	 * @inheritDoc
	 */
	public function rebuildEntities():Void {
		serializedEntities = [];
		
		var iter;
		iter = entities.head;
		while (iter != null) {
			serializedEntities.push(iter.elt);
			iter = iter.next;
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function addComponent(component:INodeComponent):INodeComponent {
		if (areComponentsSorted) {
			var componentsArray:Array<INodeComponent> = [];
			
			var list:FastList<INodeComponent> = null;
			if (component.updatesBefore) {
				list = preUpdateComponents;
			} else {
				list = postUpdateComponents;
			}
			var iter = list.head;
			while (iter != null) {
				componentsArray.push(iter.elt);
				iter = iter.next;
			}
			componentsArray.push(component);
			componentsArray.reverse();
			InsertionSort.sort(componentsArray, false, "priority");
			
			list = new FastList<INodeComponent>();
			for (i in 0...componentsArray.length) {
				list.add(componentsArray[i]);
			}
			
			if (component.updatesBefore) {
				preUpdateComponents = list;
			} else {
				postUpdateComponents = list;
			}
		} else {
			if (component.updatesBefore) {
				preUpdateComponents.add(component);
			} else {
				postUpdateComponents.add(component);
			}
		}
		
		return component;
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeComponent(component:INodeComponent):Void {
		if (component.updatesBefore) {
			preUpdateComponents.remove(component);
		} else {
			postUpdateComponents.remove(component);
		}
	}
	
	/**
	 * Sets all children's locked status.
	 */
	private inline function setIsLocked(v:Bool):Bool {
		isLocked = v;
		var iter;
		iter = children.head;
		while (iter != null) {
			iter.elt.isLocked = v;
			iter = iter.next;
		}
		
		return v;
	}
	
	/**
	 * Sets all children visibility.
	 */
	private inline function setIsVisible(v:Bool):Bool {
		isVisible = v;
		var iter;
		iter = children.head;
		while (iter != null) {
			iter.elt.isVisible = v;
			iter = iter.next;
		}
		
		return v;
	}
	
	/**
	 * Sets all children to be removed.
	 */
	private inline function setIsRemoved(v:Bool):Bool {
		isRemoved = v;
		var iter;
		iter = children.head;
		while (iter != null) {
			iter.elt.isRemoved = v;
			iter = iter.next;
		}
		
		return v;
	}
	
	/**
	 * Set the alpha of the node while making sure it is between 0 and 1.
	 * @param	v		The alpha to set.
	 * @return	The alpha value.
	 */
	private inline function setAlpha(v:Float):Float {
		if (v <= 0) {
			alpha = 0;
		} else if (v >= 1) {
			alpha = 1;
		} else {
			alpha = v;
		}
		alpha = GaleMath.toFixed(alpha, 100);
		
		var iter = children.head;
		while (iter != null) {
			iter.elt.alpha = alpha;
			iter = iter.next;
		}
		
		isCacheUpdated = true;
		
		return v;
	}
	
	/**
	 * Set the scale in the X axis while making sure the value is between 0.01 and infinity.
	 * @param	v		The scale value.
	 * @return	The scale value.
	 */
	private inline function setScaleX(v:Float):Float {
		if (v != scaleX) {
			if (v <= 0) {
				scaleX = 0.01;
			} else {
				scaleX = v;
			}
			scaleX = GaleMath.toFixed(scaleX, 100);
			
			if (parent != null) {
				derivedScaleX = parent.derivedScaleX * scaleX;
			} else {
				derivedScaleX = scaleX;
			}
			
			var iter = children.head;
			while (iter != null) {
				iter.elt.derivedScaleX = derivedScaleX * iter.elt.scaleX;
				iter.elt.isCacheUpdated = true;
				iter = iter.next;
			}
			
			isCacheUpdated = true;
		}
		
		return v;
	}
	
	/**
	 * Set the scale in the X axis while making sure the value is between 0.01 and infinity.
	 * @param	v		The scale value.
	 * @return	The scale value.
	 */
	private inline function setScaleY(v:Float):Float {
		if (v != scaleY) {
			if (v <= 0) {
				scaleY = 0.01;
			} else {
				scaleY = v;
			}
			scaleY = GaleMath.toFixed(scaleY, 100);
			
			if (parent != null) {
				derivedScaleY = parent.derivedScaleY * scaleY;
			} else {
				derivedScaleY = scaleY;
			}
			
			var iter = children.head;
			while (iter != null) {
				iter.elt.derivedScaleY = derivedScaleY * iter.elt.scaleY;
				iter.elt.isCacheUpdated = true;
				iter = iter.next;
			}
			
			isCacheUpdated = true;
		}
		
		return v;
	}
	
	/**
	 * Set the scale in the X axis while making sure the value is between 0.01 and infinity.
	 * @param	v		The scale value.
	 * @return	The scale value.
	 */
	private inline function setCameraScaleX(v:Float):Float {
		if (v != cameraScaleX) {
			if (v <= 0) {
				cameraScaleX = 0.01;
			} else {
				cameraScaleX = v;
			}
			cameraScaleX = GaleMath.toFixed(cameraScaleX, 100);
			
			isCacheUpdated = true;
		}
		
		return v;
	}
	
	/**
	 * Set the scale in the X axis while making sure the value is between 0.01 and infinity.
	 * @param	v		The scale value.
	 * @return	The scale value.
	 */
	private inline function setCameraScaleY(v:Float):Float {
		if (v != cameraScaleY) {
			if (v <= 0) {
				cameraScaleY = 0.01;
			} else {
				cameraScaleY = v;
			}
			cameraScaleY = GaleMath.toFixed(cameraScaleY, 100);
			
			isCacheUpdated = true;
		}
		
		return v;
	}
	
	/**
	 * Sets the rotation of the node in degrees while ensuring the value is between -180 and 180.
	 * @param	v	The rotation of the node in degrees
	 * @return	The rotation of the node in degrees.
	 */
	private inline function setRotation(v:Float):Float {
		var degrees:Float = v;
		if (v < -180) {
			degrees = v + Math.ceil(v / -360) * 360;
		} else if (v > 180) {
			degrees = v - Math.ceil(v / 360) * 360;
		} else {
			degrees = v;
		}
		
		if (rotation != degrees) {
			rotation = degrees;
			
			if (parent != null) {
				derivedRotation = parent.derivedRotation + rotation;
			} else {
				derivedRotation = rotation;
			}
			
			var iter = children.head;
			while (iter != null) {
				iter.elt.derivedRotation = derivedRotation + iter.elt.rotation;
				iter = iter.next;
			}
		
			isCacheUpdated = true;
		}
		
		return v;
	}
	
	/**
	 * Sets the rotation of the node in degrees while ensuring the value is between -180 and 180.
	 * @param	v	The rotation of the node in degrees
	 * @return	The rotation of the node in degrees.
	 */
	private inline function setCameraRotation(v:Float):Float {
		var degrees:Float = v;
		if (v < -180) {
			degrees = v + Math.ceil(v / -360) * 360;
		} else if (v > 180) {
			degrees = v - Math.ceil(v / 360) * 360;
		} else {
			degrees = v;
		}
		if (cameraRotation != degrees) {
			cameraRotation = degrees;
			
			isCacheUpdated = true;
		}
		
		return v;
	}
	
	private inline function setFlipHorizontal(v:Bool):Bool {
		flipHorizontal = v;
		
		var iter = children.head;
		while (iter != null) {
			iter.elt.flipHorizontal = v;
			iter = iter.next;
		}
		
		isCacheUpdated = true;
		
		return v;
	}
	
	private inline function setFlipVertical(v:Bool):Bool {
		flipVertical = v;
	
		var iter = children.head;
		while (iter != null) {
			iter.elt.flipVertical = v;
			iter = iter.next;
		}
		
		isCacheUpdated = true;
		
		return v;
	}
	
	/**
	 * Set the red offset for the node.
	 * @param	v	The value to change by which is capped at -255 to 255.
	 * @return	The offset amount.
	 */
	private inline function setRedOffset(v:Int):Int {
		redOffset = v;
		
		var iter = children.head;
		while (iter != null) {
			iter.elt.redOffset = v;
			iter = iter.next;
		}
		
		isCacheUpdated = true;
		
		return v;
	}
	
	/**
	 * Set the green offset for the node.
	 * @param	v	The value to change by which is capped at -255 to 255.
	 * @return	The offset amount.
	 */
	private inline function setGreenOffset(v:Int):Int {
		greenOffset = v;
		
		var iter = children.head;
		while (iter != null) {
			iter.elt.greenOffset = v;
			iter = iter.next;
		}
		
		isCacheUpdated = true;
		
		return v;
	}
	
	/**
	 * Set the blue offset for the node.
	 * @param	v	The value to change by which is capped at -255 to 255.
	 * @return	The offset amount.
	 */
	private inline function setBlueOffset(v:Int):Int {
		blueOffset = v;
		
		var iter = children.head;
		while (iter != null) {
			iter.elt.blueOffset = v;
			iter = iter.next;
		}
		
		isCacheUpdated = true;
		
		return v;
	}
}