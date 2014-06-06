/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.resourceloader;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.Lib;
import flash.media.Sound;
import flash.text.Font;
import flash.utils.ByteArray;

class ResourceLoader implements IResourceLoader
{
	private var sounds:Hash<Sound>;
	private var bitmaps:Hash<Bitmap>;
	private var images:Hash<BitmapData>;
	private var data:Hash<ByteArray>;
	private var movieClips:Hash<MovieClip>;
	private var libraries:Hash<Dynamic>;
	
	private var isDataCompressed:Bool;
	
	/**
	 * Creates new resources.
	 */
	public function new(isDataCompressed:Bool = true) 
	{
		this.isDataCompressed = isDataCompressed;
		
		sounds = new Hash<Sound>();
		bitmaps = new Hash<Bitmap>();
		images = new Hash<BitmapData>();
		data = new Hash<ByteArray>();
		movieClips = new Hash<MovieClip>();
		libraries = new Hash<Dynamic>();
	}
	
	/**
	 * Retrieves a bitmap from the resources.
	 * @param	key		The name of the image.
	 * @return	The bitmap retrieved.
	 */
	inline public function getBitmap(key:String):Bitmap {
		if (!bitmaps.exists(key)) {
			try {
				bitmaps.set(key, Type.createInstance(Type.resolveClass("resources.classes." + key), []));
			} catch (e:Dynamic) {
				throw("Error - The file " + key + " has not been found! Make sure the case is correct.\n" + e);
			}
		}
		return bitmaps.get(key);
	}
	
	inline public function setBitmap(key:String, value:Bitmap):Void {
		bitmaps.set(key, value);
		images.set(key, value.bitmapData);
	}
	
	/**
	 * Retrieves a bitmapData from the resources.
	 * @param	key		The name of the image.
	 * @return	The bitmapData retrieved.
	 */
	inline public function getBitmapData(key:String):BitmapData {
		if (!images.exists(key)) {
			try {
				images.set(key, Type.createInstance(Type.resolveClass("resources.classes." + key), []).bitmapData);
			} catch (e:Dynamic) {
				trace("ResourceLoader: The file " + key + " has not been found! Make sure the case is correct.");
				throw("Error - The file " + key + " has not been found! Make sure the case is correct.");
			}
		}
		return images.get(key);
	}
	
	inline public function setBitmapData(key:String, value:BitmapData):Void {
		images.set(key, value);
	}
	
	/**
	 * Retrieve a cached bitmapData.
	 * @param	key			The name of the image to retrieve.
	 * @return	The cachedBitmapData.
	 */
	public inline function getCachedBitmapData(key:String):CachedBitmapData {
		var bitmapData:BitmapData = getBitmapData(key);
		var cachedBitmapData:CachedBitmapData = new CachedBitmapData(bitmapData, bitmapData.rect, key);
		
		return cachedBitmapData;
	}
	
	/**
	 * Retrieves a sound from the resources.
	 * @param	key		The name of the sound.
	 * @return	The sound retrieved.
	 */
	inline public function getSound(key:String):Sound {
		if (!sounds.exists(key)) {
			try {
				sounds.set(key, Type.createInstance(Type.resolveClass("resources.classes." + key), []));
			} catch (e:Dynamic) {
				throw("Error - The file " + key + " has not been found! Make sure the case is correct.\n" + e);
			}
		}
		return sounds.get(key);
	}
	
	inline public function setSound(key:String, value:Sound):Void {
		sounds.set(key, value);
	}
	
	/**
	 * Retrieves arbirary data frm the resources.
	 * @param	key		The name of the data.
	 * @return	The data retrieved.
	 */
	inline public function getData(key:String):ByteArray {
		if (!data.exists(key)) {
			if (isDataCompressed) {
				try {
					var file:ByteArray = Type.createInstance(Type.resolveClass("resources.classes." + key), []);
					file.uncompress();
					data.set(key, file);
				} catch (e:Dynamic) {
					throw("Error - The file " + key + " has not been found! Make sure the case is correct.\n" + e);
				}
			} else {
				try {
					data.set(key, Type.createInstance(Type.resolveClass("resources.classes." + key), []));
				} catch (e:Dynamic) {
					throw("Error - The file " + key + " has not been found! Make sure the case is correct.\n" + e);
				}
			}
		}
		return data.get(key);
	}
	
	inline public function setData(key:String, value:ByteArray):Void {
		data.set(key, value);
	}
	
	/**
	 * Retrieves an swf file.
	 * @param	key		The name of the swf file.
	 * @return	The swf retrieved.
	 */
	inline public function getMovieClip(key:String):MovieClip {
		if (!movieClips.exists(key)) {
			try {
				movieClips.set(key, Type.createInstance(Type.resolveClass(key), []));
			} catch (e:Dynamic) {
				throw("Error - The file " + key + " has not been found! Make sure the case is correct.\n" + e);
			}
		}
		return movieClips.get(key);
	}
	
	inline public function setMovieClip(key:String, value:MovieClip):Void {
		movieClips.set(key, value);
	}
	
	/**
	 * Retrieves an swf library.
	 * Import files in the swf by using the names of the classes.
	 * @param	key		The name of the swf file.
	 * @return	The swf retrieved.
	 */
	inline public function getLibrary(key:String, ?arguments:Array<Dynamic>):Dynamic {
		if (arguments == null) {
			arguments = [];
		}
		if (!libraries.exists(key)) {
			libraries.set(key, Type.createInstance(Type.resolveClass(key), arguments));
		}
		return libraries.get(key);
	}
	
	inline public function setLibrary(key:String, value:Dynamic):Void {
		libraries.set(key, value);
	}
	
	/**
	 * Retrieves a font.
	 * @param	key		The name of the font.
	 * @return	The font retrieved.
	 */
	inline public function getFont(key:String):Class<Dynamic> {
		var fontClass:Class<Dynamic> = Type.resolveClass("resources.classes." + key);
		return fontClass;
	}
	
	/**
	 * Registers a font.
	 * @param	font	The font class.
	 */
	inline public function setFont(font:Class<Font>):Void {
		Font.registerFont(font);
	}
}