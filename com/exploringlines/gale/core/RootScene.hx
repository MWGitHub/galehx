/**
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.apps.datastructures.DLinkedList;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.renderer.Camera;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.EntityAnimationFrame;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRenderer;
import com.exploringlines.gale.core.resourceloader.CachedBitmapData;
import com.exploringlines.gale.core.resourceloader.IResourceLoader;
import com.exploringlines.gale.core.sound.ISoundData;
import com.exploringlines.gale.core.sound.SoundData;
import com.exploringlines.gale.core.sound.ISoundPlayer;
import com.exploringlines.gale.apps.text.Text;
import com.exploringlines.gale.shortcuts.AnimationCreator;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.geom.Point;
import flash.media.SoundChannel;
import flash.utils.ByteArray;

/**
 * This creates and removes entities in specified layers and will also clean up entities
 * without a parent or a removed parent.
 * This also plays and updates sound.
 */
class RootScene 
{
	public var resourceLoader:IResourceLoader;
	public var soundPlayer:ISoundPlayer;
	public var renderer:IRenderer;
	
	public var animationCreator(default, null):AnimationCreator;
	
	public var entities:Array<DLinkedList<Entity>>;
	public var flattenedEntityArray:Array<Entity>;

	/**
	 * The view of the scene for rendering.
	 */
	public var camera:Camera;
	
	private var soundCounter:Int;

	/**
	 * This creates and removes entities in specified layers and will also clean up entities
	 * without a parent or a removed parent.
	 * @param	resourceLoader
	 */
	public function new(resourceLoader:IResourceLoader, renderer:IRenderer, soundPlayer:ISoundPlayer) 
	{
		this.resourceLoader = resourceLoader;
		this.renderer = renderer;
		this.soundPlayer = soundPlayer;
		
		entities = [];
		flattenedEntityArray = [];
		
		animationCreator = new AnimationCreator(resourceLoader);
		
		soundCounter = 10;
		
		camera = new Camera();
	}
	
	/**
	 * Creates an entity and adds it to the scene.
	 * @param	index			The index of the bitmapData to be used.
	 * @param	frame			The frame of the bitmapData to be used.
	 * @param	layer			The layer the entity resides in.
	 * @param	?offset			The offset of the entity from the node point.
	 * @return The created entity.
	 */
	public inline function createEntity(key:String, layer:Int = 0, ?offset:Point, name:String = "Empty"):Entity {
		var entityName:String = name;
		var resource:CachedBitmapData = resourceLoader.getCachedBitmapData(key);
		if (entityName == "Empty") {
			entityName = key;
		}
		var entity:Entity = new Entity(entityName, resource.bitmapData, resource.rectangle.clone(), offset, layer);
		addEntity(entity);
		
		return entity;
	}
	
	/**
	 * Adds an entity to a layer.
	 * @param	entity
	 */
	public inline function addEntity(entity:Entity):Void {
		if (entities[entity.layer] == null) {
			entities[entity.layer] = new DLinkedList<Entity>();
		}
		entities[entity.layer].add(entity);
		
		flattenEntityArray();
	}
	
	/**
	 * Adds a list of entities.
	 * @param entities	A list of entities to add.
	 */
	public inline function addEntities(entities:DLinkedList<Entity>):Void {
		var iter = entities.head;
		while (iter != null) {
			addEntity(iter.elt);
			iter = iter.next;
		}
	}
	
	/**
	 * Creates a text entity.
	 * @return Returns the created text.
	 */
	public inline function createText(layer:Int = 0, string:String = "", ?offset:Point, size:Int = 16, color:UInt = 0xFFFFFF, font:String = "Helvetica", ?align:Align):Text {
		var text:Text = new Text(offset, layer, size, color, font);
		text.text = string;
		if (align != null) {
			text.align = align;
		}
		
		addEntity(text);
		
		return text;
	}
	
	/**
	 * Removes an entity from the display list.
	 * @param	entity	The entity to be removed.
	 * @return	Returns true if successful and false when no matching entity is found.
	 */
	public inline function removeEntity(entity:IEntity):Void {
		var success:Bool = false;
		var iter;
		for (i in 0...entities.length) {
			if (entities[i] != null) {
				iter = entities[i].head;
				while (iter != null) {
					if (iter.elt == entity) {
						entities[i].remove(iter.elt);
						success = true;
						break;
					}
					iter = iter.next;
				}
			}
			if (success)
				break;
		}
		flattenEntityArray();
	}
	
	/**
	 * Removes all entities without a valid parent or a removed parent.
	 */
	public inline function removeEntities():Void {
		var hasRemoved:Bool = false;
		var iter;
		
		for (i in 0...entities.length) {
			if (entities[i] != null) {
				iter = entities[i].head;
				while (iter != null) {
					if (iter.elt.parent == null || iter.elt.parent.isRemoved) {
						entities[i].remove(iter.elt);
						hasRemoved = true;
					}
					iter = iter.next;
				}
			}
		}
		
		if (hasRemoved) {
			flattenEntityArray();
		}
	}
	
	/**
	 * Retrieves all the entities on a layer.
	 * @param	layer	The layer to retrieve entities from.
	 * @return	The list of entities on the layer.
	 */
	public inline function getEntitiesInLayer(layer:Int):DLinkedList<Entity> {
		return entities[layer];
	}
	
	/**
	 * Copies the linked list to an array form for the renderer.
	 */
	private inline function flattenEntityArray():Void {
		flattenedEntityArray = [];
		
		var iter;
		for (i in 0...entities.length) {
			if (entities[i] != null) {
				iter = entities[i].tail;
				while (iter != null) {
					flattenedEntityArray.push(iter.elt);
					iter = iter.prev;
				}
			}
		}
	}
	
	/**
	 * Creates a base sound with only the cached sound.
	 * @param	index		The cached sound to be played.
	 * @return	The soundData created.
	 */
	public function createSound(key:String, channel:Int = -1):SoundData {
		var sound:SoundData = new SoundData(resourceLoader.getSound(key));
		if (channel != -1) {
			sound.channel = channel;
		} else {
			sound.channel = soundCounter;
			soundCounter++;
			if (soundCounter >= soundPlayer.maximumChannels) {
				soundCounter = 0;
			}
		}
		
		return sound;
	}
	
	/**
	 * Plays a sound using the soundData.
	 * @param	sound		The data for the sound to be played.
	 */
	public function playSound(sound:ISoundData):SoundChannel {
		return soundPlayer.playSound(sound);
	}
	
	public function playMusic(music:ISoundData):SoundChannel {
		music.isMusic = true;
		soundPlayer.stopChannel(music.channel, true);
		return soundPlayer.playSound(music);
	}
	
	/**
	 * Updates a sound using the soundData.
	 * @param	sound		The data to be updated.
	 */
	public function updateSound(sound:ISoundData):Void {
		soundPlayer.updateSound(sound);
	}
	
	public function stopChannel(channel:Int):Void {
		soundPlayer.stopChannel(channel);
	}
	
	public function getChannel(channel:Int, isMusic:Bool = false):SoundChannel {
		return soundPlayer.getChannel(channel, isMusic);
	}
	
	public function getChannelData(channel:Int, isMusic:Bool):ISoundData {
		return soundPlayer.getChannelData(channel, isMusic);
	}
	
	/**
	 * Sets if the game is muted.
	 * @param	isMute		Sound muted when true.
	 */
	public function setMute(isMute:Bool):Void {
		soundPlayer.isMute = isMute;
	}
	
	/**
	 * Gets the current mute state.
	 * @return	If true, the sound player is muted.
	 */
	public function getMute():Bool {
		return soundPlayer.isMute;
	}
	
	/**
	 * Sets if the music is muted.
	 * @param	isMute	Mutes the music if true.
	 * @param	?music	Plays the music if is not mute.
	 */
	public function setMusicMute(isMute:Bool, ?music:ISoundData):Void {
		soundPlayer.isMusicMute = isMute;
		if (!isMute && music != null) {
			playMusic(music);
		}
	}
	
	/**
	 * Gets the current music state.
	 * @return	If true, the music channels are muted.
	 */
	public function getMusicMute():Bool {
		return soundPlayer.isMusicMute;
	}
	
	/**
	 * Resets the scene.
	 */
	public function reset():Void {
		entities = [];
		flattenedEntityArray = [];
		camera.position.x = Globals.stage.stageWidth / 2;
		camera.position.y = Globals.stage.stageHeight / 2;
		camera.rotation = 0;
		camera.scaleX = 1;
		camera.scaleY = 1;
	}
	
	/**
	 * Retrieves a bitmap from the resources.
	 * @param	key		The image to retrieve.
	 * @return	The bitmap.
	 */
	public inline function getBitmap(key:String):Bitmap {
		return resourceLoader.getBitmap(key);
	}
	
	/**
	 * Retrieves a bitmapdata from the resources.
	 * @param	key	The name of the image to retrieve.
	 * @return	The bitmapData.
	 */
	public inline function getBitmapData(key:String):BitmapData {
		return resourceLoader.getBitmapData(key);
	}
	
	/**
	 * Retrieves a cached bitmapData from the resources.
	 * @return	The CachedBitmapData
	 */
	public inline function getCachedBitmapData(key:String):CachedBitmapData {
		return resourceLoader.getCachedBitmapData(key);
	}
	
	/**
	 * Retrieves a data from the resources.
	 * @return	The data
	 */
	public inline function getData(key:String):ByteArray {
		return resourceLoader.getData(key);
	}
	
	/**
	 * Retrieves an animation from the resources.
	 * @param	key	The name of the swf.
	 * @return	The swf animation.
	 */
	public inline function getMovieClip(key:String):MovieClip {
		return resourceLoader.getMovieClip(key);
	}
	
	/**
	 * Retrieves a swf from the resources.
	 * @param	key	The name of the swf.
	 * @return	The swf
	 */
	public inline function getLibrary(key:String):Dynamic {
		return resourceLoader.getLibrary(key);
	}
}