/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;

/**
 * Renders entities into the visible area.
 */
class Renderer implements IRenderer
{	
	// The stage to draw on.
	private var stage:Stage;
	
	// The initial canvas color.
	private var canvasColor:UInt;
	
	// The layers the canvases are on.
	private var layers:Array<Sprite>;
	
	// The canvases
	private var canvases:Array<Bitmap>;
	
	// The canvas data
	private var canvasDatas:Array<BitmapData>;
	
	// The eraser for each canvas.
	private var canvasEraser:BitmapData;
	private var eraserRectangle:Rectangle;
	private var point:Point;
	private var eraserPoint:Point;
	private var rectangle:Rectangle;
	private var cache:RendererCache;
	private var rendererObject:RendererCacheObject;
	private var uncachedRendererObject:RendererCacheObject;
	
	private var preRenderPlugins:flash.Vector<IRendererPlugin>;
	private var postRenderPlugins:flash.Vector<IRendererPlugin>;
	
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
	
	// When true points will be rounded, else floored.
	public var arePointsEstimated:Bool;

	/**
	 * Creates a new drawable area and attaches itself to the stage.
	 */
	public function new(?stage:Stage, canvasColor:UInt = 0x00000000, stageLayers:Int = 1) 
	{
		if (stage != null) {
			this.stage = stage;
		} else {
			this.stage = Lib.current.stage;
		}
		this.canvasColor = canvasColor;
		
		// Create common variables used for all layers.
		rectangle = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		eraserRectangle = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		point = new Point();
		eraserPoint = new Point(0, 0);
		canvasEraser = new BitmapData(this.stage.stageWidth, this.stage.stageHeight, true, canvasColor);
		
		// Create layers
		layers = [];
		canvases = [];
		canvasDatas = [];
		for (i in 0...stageLayers) {
			canvases.push(null);
			canvasDatas.push(null);
			var sprite:Sprite = new Sprite();
			this.stage.addChild(sprite);
			layers.push(sprite);
			createCanvas(i);
		}
		
		camera = new Camera();
		
		preRenderPlugins = new flash.Vector<IRendererPlugin>();
		postRenderPlugins = new flash.Vector<IRendererPlugin>();
		
		// Create cache
		cache = new RendererCache();
		isCaching = true;
		uncachedRendererObject = new RendererCacheObject(new BitmapData(5, 5), new Rectangle());
		
		isPaused = false;
		arePointsEstimated = false;
	}
	
	/**
	 * Renders multiple entities to the canvas with the first entity rendered first.
	 * @param	entities The entities to be rendered.
	 * @param	deltaTime The time passed since the last update.
	 */
	public inline function renderEntitiesToCanvas(entities:Array<Entity> , deltaTime:Int = 0, deltaTimeAnimation:Int = 0):Void {
		for (i in 0...canvases.length) {
			//canvasDatas[i].lock();
		}
		
		var updateDeltaTime:Int = deltaTime;
		var displayDeltaTime:Int = deltaTimeAnimation;
		var pluginInfo:String = "";
		
		if (isPaused) {
			updateDeltaTime = 0;
			displayDeltaTime = 0;
		}
		/*
		var isCameraActive:Bool = false;
		if (camera.scaleX != 1 || camera.scaleY != 1 || camera.rotation != 0) {
			isCameraActive = true;
		}
		*/
		for (i in 0...entities.length) {
			if (entities[i].parent != null && entities[i].parent.isVisible && entities[i].isVisible) {
				if (camera.isCameraUpdated && entities[i].isProcessed && !entities[i].parent.isLocked) {
					entities[i].parent.cameraScaleX = camera.scaleX;
					entities[i].parent.cameraScaleY = camera.scaleY;
					entities[i].parent.cameraRotation = camera.rotation;
					entities[i].parent.updateCache();
				}
				if (entities[i].isCacheUpdated) {
					entities[i].updateCache();
					entities[i].isCacheUpdated = false;
				}
				entities[i].update(updateDeltaTime, displayDeltaTime);
				
				if (isCaching && entities[i].isCached && entities[i].cacheKey != "Empty") {
					if (cache.isInCache(entities[i].cacheKey)) {
						rendererObject = cache.retrieveFromCache(entities[i].cacheKey);
						entities[i].rendererCacheObject = rendererObject;
					} else {
						rendererObject = applyPlugins(entities[i], entities[i].cacheKey, true);
						entities[i].rendererCacheObject = rendererObject;
					}
				} else {
					if (entities[i].isProcessed) {						
						uncachedRendererObject = applyPlugins(entities[i], entities[i].cacheKey, false);
						entities[i].rendererCacheObject = uncachedRendererObject;
					} else {
						uncachedRendererObject.bitmapData = entities[i].bitmapData;
						uncachedRendererObject.rectangle = entities[i].rectangle;
					}
					rendererObject = uncachedRendererObject;
					if (!entities[i].isProcessed) {
						rendererObject.center.x = entities[i].center.x;
						rendererObject.center.y = entities[i].center.y;
					}
				}
				if (entities[i].isCentered) {
					if (!entities[i].parent.isLocked) {
						if (arePointsEstimated) {
							point.x = Math.round((entities[i].interpolatedPosition.x - camera.position.x) * camera.scaleX + (camera.width - rendererObject.rectangle.width) / 2);
							point.y = Math.round((entities[i].interpolatedPosition.y - camera.position.y) * camera.scaleY + (camera.height - rendererObject.rectangle.height) / 2);
						} else {
							point.x = Std.int((entities[i].interpolatedPosition.x - camera.position.x) * camera.scaleX + (camera.width - rendererObject.rectangle.width) / 2);
							point.y = Std.int((entities[i].interpolatedPosition.y - camera.position.y) * camera.scaleY + (camera.height - rendererObject.rectangle.height) / 2);
						}
					} else {
						if (arePointsEstimated) {
							point.x = Math.round(entities[i].interpolatedPosition.x - rendererObject.center.x);
							point.y = Math.round(entities[i].interpolatedPosition.y - rendererObject.center.y);
						} else {
							point.x = Std.int(entities[i].interpolatedPosition.x - rendererObject.center.x);
							point.y = Std.int(entities[i].interpolatedPosition.y - rendererObject.center.y);
						}
					}
				} else {
					if (!entities[i].parent.isLocked) {
						if (arePointsEstimated) {
							point.x = Math.round((entities[i].interpolatedPosition.x - camera.position.x) * camera.scaleX + (camera.width) / 2);
							point.y = Math.round((entities[i].interpolatedPosition.y - camera.position.y) * camera.scaleY + (camera.height) / 2);
						} else {
							point.x = Std.int((entities[i].interpolatedPosition.x - camera.position.x) * camera.scaleX + (camera.width) / 2);
							point.y = Std.int((entities[i].interpolatedPosition.y - camera.position.y) * camera.scaleY + (camera.height) / 2);
						}
					} else {
						if (arePointsEstimated) {
							point.x = Math.round(entities[i].interpolatedPosition.x);
							point.y = Math.round(entities[i].interpolatedPosition.y);
						} else {
							point.x = Std.int(entities[i].interpolatedPosition.x);
							point.y = Std.int(entities[i].interpolatedPosition.y);
						}
					}
				}
				
				canvasDatas[entities[i].stageLayer].copyPixels(rendererObject.bitmapData, rendererObject.rectangle, point, null, null, true);
			}
		}
		
		for (i in 0...canvases.length) {
			canvasDatas[i].unlock();
		}
	}
	
	/**
	 * Render a single entity to the canvas.
	 * @param	entity The object to be rendered.
	 * @param	deltaTime The time passed since the last update.
	 */
	public inline function renderEntityToCanvas(entity:Entity, deltaTime:Int = 0, deltaTimeAnimation:Int = 0):Void {
		canvasDatas[entity.stageLayer].lock();
		entity.update(deltaTime, deltaTimeAnimation);
		canvasDatas[entity.stageLayer].copyPixels(entity.bitmapData, entity.rectangle, entity.interpolatedPosition);
		canvasDatas[entity.stageLayer].unlock();
	}
	
	/**
	 * Clears the canvas.
	 */
	public inline function clearCanvas(index:Int = 0):Void {
		canvasDatas[index].lock();
		canvasDatas[index].copyPixels(canvasEraser, eraserRectangle, eraserPoint);
		canvasDatas[index].unlock();
	}
	
	/**
	 * @inheritDoc
	 */
	public inline function clearCanvases():Void {
		for (i in 0...canvases.length) {
			clearCanvas(i);
		}
	}
	
	/**
	 * Add a plugin to be run either before or after rendering.
	 * @param	plugin	The plugin to be added.
	 */
	public function addPlugin(plugin:IRendererPlugin):Void {
		if (plugin.type == "pre") {
			preRenderPlugins.push(plugin);
		} else {
			postRenderPlugins.push(plugin);
		}
	}
	
	/**
	 * Flushes the cache.
	 */
	public inline function flushCache():Void {
		cache.flush();
	}
	
	/**
	 * Applies all plugins added in the prerender step.
	 * @param	entity		The entity being worked on.
	 * @param	key			The values of the entity which is used in both caching and transforming.
	 * @return	The transformed object.
	 */
	private inline function applyPlugins(entity:IEntity, key:String, isCached:Bool):RendererCacheObject {
		var object:RendererCacheObject = new RendererCacheObject(entity.bitmapData, entity.rectangle);
		var plugins:Array < String > = key.split(";");
		var plugin:Array<String> = [];
		
		for (i in 0...plugins.length) {
			plugin = plugins[i].split("=");
			for (j in 0...preRenderPlugins.length) {
				if (plugin[0] == preRenderPlugins[j].name) {
					object = preRenderPlugins[j].apply(entity, object, plugin[1]);
					break;
				}
			}
		}
		if (isCached) {
			cache.addToCache(key, object);
		}
		
		return object;
	}
	
	/**
	 * Creates a new canvas to draw on.
	 */
	private function createCanvas(index:Int):Void {
		canvasDatas[index] = new BitmapData(stage.stageWidth, stage.stageHeight, true, canvasColor);
		canvases[index] = new Bitmap(canvasDatas[index], PixelSnapping.NEVER, true);
		canvases[index].x = 0;
		canvases[index].y = 0;
		layers[index].addChild(canvases[index]);
		
		rendererObject = new RendererCacheObject(canvasEraser, eraserRectangle);
	}
	
	/**
	 * The index of the canvas.
	 * @param	index	The index of the layer.
	 * @return	The canvas on the layer.
	 */
	public function getCanvas(index:Int):Bitmap {
		return canvases[index];
	}
	
	/**
	 * @inheritDoc
	 */
	public function getCanvasData(index:Int):BitmapData {
		return canvasDatas[index];
	}
	
	/**
	 * Get the sprite a layer resides on.
	 * @param	index	The index of the layer.
	 * @return	The spirte of the layer.
	 */
	public function getLayer(index:Int):Sprite {
		return layers[index];
	}
	
	/**
	 * @inheritDoc
	 */
	public function addDisplayToLayer(object:DisplayObject, index:Int):Void {
		layers[index].addChild(object);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeDisplayFromLayer(object:DisplayObject, index:Int):Void {
		if (layers[index].contains(object)) {
			layers[index].removeChild(object);
		}
	}
}