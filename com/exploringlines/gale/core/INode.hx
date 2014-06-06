/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRenderable;

/**
 * An interface for a node, which represents objects in the framework.
 */
interface INode implements IRenderable
{
	/**
	 * The index of the node. This is unique for every node created.
	 */
	public var index(default, null):Int;
	
	/**
	 * The name of the node.
	 */
	public var name:String;
	
	/**
	 * Sets if the node has been removed.
	 */
	public var isRemoved(default, setIsRemoved):Bool;
	
	/**
	 * When true the rendering position will be relative to the window and the camera will not be applied.
	 */
	public var isLocked(default, setIsLocked):Bool;
	
	/**
	 * Sets if the node entities should be rendered.
	 */
	public var isVisible(default, setIsVisible):Bool;
	
	/**
	 * The parent node if the node is a child.
	 */
	public var parent:INode;
	
	/**
	 * Children nodes will follow the position of the parent nodes.
	 */
	public var children:haxe.FastList<INode>;
	
	/**
	 * The entities attached to the node.
	 */
	public var entities:haxe.FastList<IEntity>;
	
	/**
	 * The flattened entities of the node.
	 */
	public var serializedEntities:Array<IEntity>;
	
	/**
	 * The position of the node.
	 */
	public var position:Vector2;
	
	/**
	 * The derived position of the node. This is used in the rendering stage.
	 */
	public var derivedPosition:Vector2;
	
	/**
	 * The speed of the node.
	 */
	public var speed:Vector2;
	
	/**
	 * The derived speed of the node. This is used in the rendering stage.
	 */
	public var derivedSpeed:Vector2;
	
	// If true then the position will be updated depending on the speed.
	public var isInterpolated:Bool;
	
	/**
	 * The angle the node in degrees.
	 */
	public var derivedRotation:Dynamic;
	public var rotation(default, setRotation):Dynamic;
	public var cameraRotation(default, setCameraRotation):Dynamic;
	
	/**
	 * The opacity of the node from 0 to 1.
	 * Automatically set to a precision of 2.
	 */
	public var alpha(default, setAlpha):Dynamic;
	
	/**
	 * The scale of the node with a precision of 2.
	 */
	public var derivedScaleX:Dynamic;
	public var derivedScaleY:Dynamic;
	public var scaleX(default, setScaleX):Dynamic;
	public var scaleY(default, setScaleY):Dynamic;
	public var cameraScaleX(default, setCameraScaleX):Dynamic;
	public var cameraScaleY(default, setCameraScaleY):Dynamic;
	
	/**
	 * The horizontal and vertical flipping.
	 */
	public var flipHorizontal(default, setFlipHorizontal):Dynamic;
	public var flipVertical(default, setFlipVertical):Dynamic;
	
	/**
	 * Color offsets
	 */
	public var redOffset(default, setRedOffset):Dynamic;
	public var greenOffset(default, setGreenOffset):Dynamic;
	public var blueOffset(default, setBlueOffset):Dynamic;
	
	/**
	 * If set to true then the components will be sorted based on priority.
	 */
	public var areComponentsSorted:Bool;
	
	/**
	 * If true, the entities of the node will have the cache regenerated on the next rendering pass.
	 */
	private var isCacheUpdated:Bool;
	
	/**
	 * Updates the node.
	 * @param	deltaTime	The time passed in milliseconds from the last update.
	 */
	public function update(deltaTime:Int = 0):Void;
	
	/**
	 * Updates only the position of the node.
	 * @param	deltaTime	The time passed in milliseconds from the last update.
	 */
	public function updatePosition(deltaTime:Int):Void;
	
	/**
	 * Checks if the entities should have updated caches.
	 */
	public function updateCache():Void;
	
	/**
	 * Adds a node as a child.
	 * @param	node	The child node to be added.
	 */
	public function addChild(node:INode):Void;
	
	/**
	 * Removes a child in the node.
	 * @param	node	The child to be removed.
	 */
	public function removeChild(node:INode):Void;
	
	/**
	 * Removes all children from the node.
	 */
	private function removeAllChildren():Void;
	
	/**
	 * Attaches a renderable object to the node.
	 * @param	object		The object to be attached.
	 * @return	The object attached to the node.
	 */
	public function attachObject(object:IEntity):IEntity;
	
	/**
	 * Removes an object from the node.
	 * @param	object		The object to be removed.
	 * @return	The removed object.
	 */
	public function removeObject(object:IEntity):IEntity;
	
	/**
	 * Removes all objects from the node.
	 */
	public function removeAllObjects():Void;
	
	/**
	 * Flattens the entity list of the node.
	 */
	public function rebuildEntities():Void;
	
	/**
	 * Adds a component to the node.
	 * @param	component	The component to add.
	 */
	public function addComponent(component:INodeComponent):INodeComponent;
	
	/**
	 * Removes a component from the node.
	 * @param	component	The component to remove.
	 */
	public function removeComponent(component:INodeComponent):Void;
}