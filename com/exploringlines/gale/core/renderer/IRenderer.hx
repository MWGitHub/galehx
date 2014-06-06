/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;

interface IRenderer 
{
	/**
	 * The camera for the scene.
	 */
	public var camera:Camera;
	
	/**
	 * If true the rendering will not interpolate objects.
	 */
	public var isPaused:Bool;
	
	/**
	 * Caching will be turned on if true.
	 */
	public var isCaching:Bool;
	
	/**
	 * Renders multiple entities to the canvas with the first entity rendered first.
	 * @param	entities The entities to be rendered.
	 * @param	deltaTime The time passed since the last update.
	 */
	public function renderEntitiesToCanvas(entities:Array<Entity> , deltaTime:Int = 0, deltaTimeAnimation:Int = 0 ):Void;
	
	/**
	 * Render a single entity to the canvas.
	 * @param	entity The object to be rendered.
	 * @param	deltaTime The time passed since the last update.
	 */
	public function renderEntityToCanvas(entity:Entity, deltaTime:Int = 0, deltaTimeAnimation:Int = 0):Void;
	
	/**
	 * Clears the canvas.
	 */
	public function clearCanvas(index:Int = 0):Void;
	
	/**
	 * Clears all canvases.
	 */
	public function clearCanvases():Void;
	
	/**
	 * Add a plugin to be run either before or after rendering.
	 * @param	plugin	The plugin to be added.
	 */
	public function addPlugin(plugin:IRendererPlugin):Void;
	
	/**
	 * Gets the canvas bitmap.
	 * @param	index	The canvas layer.
	 * @return	The bitmap for the canvas.
	 */
	public function getCanvas(index:Int):Bitmap;
	
	/**
	 * Gets the data drawn on the canvas.
	 * @param	index	The canvas data layer.
	 * @return	The data for the canvas.
	 */
	public function getCanvasData(index:Int):BitmapData;
	
	/**
	 * Gets the layer sprite.
	 * @param	index	The index of the layer.
	 * @return	The sprite matching the layer.
	 */
	public function getLayer(index:Int):Sprite;
	
	/**
	 * Adds a display object to the layer.
	 * @param	object	The object to add.
	 * @param	index	The index of the object.
	 */
	public function addDisplayToLayer(object:DisplayObject, index:Int):Void;
	
	/**
	 * Removes a display object from the layer.
	 * @param	object	The object to remove.
	 * @param	index	The index of the object.
	 */
	public function removeDisplayFromLayer(object:DisplayObject, index:Int):Void;
}