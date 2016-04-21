#Galehx
Gale haXe is a 2d game framework written in haXe.
It handles everything from the game loop, rendering, sound, input, and game object handling.

###Some of the games made with galehx
###Blockgineer 2:

[![blockgineer2]](http://www.submu.com/showcase/blockgineer-2/)

###Blockstachio

[![blockstachio]](http://www.submu.com/showcase/blockstachio/)

###Technical Details:
* Gale haXe uses a mix between inheritance and composition for the main game objects which most objects will inherit from. Composition can be used to add behaviors to entities either at run time or initialization. This allows the programmer to choose if behaviors should be able to be inherited which trades easier entity creation at the cost of coupling.

```
/**
 * Base class for a node component.
 */
class NodeComponent implements INodeComponent {
	public var priority:Int;
	public var updatesBefore:Bool;
	public var isComplete:Bool;
	public var completeCallback:INodeComponent->Void;

	public function new(priority:Int = 0, updatesBefore:Bool = true, completeCallback:INodeComponent->Void = null) {
		this.priority = priority;
		this.updatesBefore = updatesBefore;
		this.isComplete = false;
		this.completeCallback = completeCallback;
	}

	public function update(deltaTime:Int = 0):Void {

	}
}
```

```
// Snippet of the node class showing how components are updated if used
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
```

* The renderer uses bitmaps to increase performance and updates entities, which are displayable children of nodes (game objects). Having a separate object as a renderable allows the renderer to update at different rates than the logic, allowing for interpolation without logic updating.

```
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
```

* Plugins can also be added to the renderer which the transform cache plugin uses. Caching transforms allows nodes to be operated on seamlessly without having to re-transform if properties such as the angle or scale change. Caching is optional as it is a tradeoff between memory usage and processing time.

```
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
```

###Features
* High performance 2D rendering using bitmap blitting.
* Ability to use MovieClips attached to layers which allows bitmaps and MovieClips to be rendered in different orders.
* Spatial sound for more realistic in-game sounds.
* Inputs with hotkey support allows for multiple keys bound to a single hotkey.
* Separate loop for logic and rendering allows for separate timing.
* Node as the main game object used for components included in the framework.
* Entity as the main display object that is attached to a node. A node may have multiple entities.
* Dynamic transforms for entities allows for rapid prototyping and provides great performance by caching the transforms lazily.
* Inheritance support for nodes to add specific functionality to game objects.
* Component support for nodes which allows for lower coupling when adding functionality to game objects.
* Export as a MovieClip which can be embedded in an AS3 project when one requires AS3 components.
* Export as a SWC library which allows for the game specific logic to be written in AS3 while the framework handles everything else.

[blockgineer2]: ./docs/images/blockgineer2.png
[blockstachio]: ./docs/images/blockstachio.png
