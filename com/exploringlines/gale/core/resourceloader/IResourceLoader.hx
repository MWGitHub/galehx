/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.resourceloader;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.media.Sound;
import flash.text.Font;
import flash.utils.ByteArray;

interface IResourceLoader {
	
	/**
	 * Retrieves a bitmap from the resources.
	 * @param	key		The name of the image.
	 * @return	The bitmap retrieved.
	 */
	public function getBitmap(key:String):Bitmap;
	
	/**
	 * Sets the bitmap.
	 * @param	key		The name of the bitmap.
	 * @param	bitmap	The bitmap to set.
	 */
	public function setBitmap(key:String, value:Bitmap):Void;
	
	/**
	 * Retrieves a bitmapData from the resources.
	 * @param	key		The name of the image.
	 * @return	The bitmapData retrieved.
	 */
	public function getBitmapData(key:String):BitmapData;
	
	public function setBitmapData(key:String, value:BitmapData):Void;
	
	/**
	 * Retrieve a cached bitmapData.
	 * @param	key			The name of the image to retrieve.
	 * @return	The cachedBitmapData.
	 */
	public function getCachedBitmapData(key:String):CachedBitmapData;
	
	/**
	 * Retrieves a sound from the resources.
	 * @param	key		The name of the sound.
	 * @return	The sound retrieved.
	 */
	public function getSound(key:String):Sound;
	
	public function setSound(key:String, value:Sound):Void;
	
	/**
	 * Retrieves arbirary data frm the resources.
	 * @param	key		The name of the data.
	 * @return	The data retrieved.
	 */
	public function getData(key:String):ByteArray;
	
	public function setData(key:String, value:ByteArray):Void;
	
	/**
	 * Retrieves an swf file.
	 * @param	key		The name of the swf file.
	 * @return	The swf retrieved.
	 */
	public function getMovieClip(key:String):MovieClip;
	
	public function setMovieClip(key:String, value:MovieClip):Void;
	
	/**
	 * Retrieves an swf library.
	 * Import files in the swf by using the names of the classes.
	 * @param	key		The name of the swf file.
	 * @return	The swf retrieved.
	 */
	public function getLibrary(key:String, ?arguments:Array<Dynamic>):Dynamic;
	
	public function setLibrary(key:String, value:Dynamic):Void;
	
	/**
	 * Retrieves a font.
	 * @param	key		The name of the font.
	 * @return	The font retrieved.
	 */
	public function getFont(key:String):Class<Dynamic>;
	
	/**
	 * Registers a font.
	 * @param	font	The font class.
	 */
	public function setFont(font:Class<Font>):Void;
}