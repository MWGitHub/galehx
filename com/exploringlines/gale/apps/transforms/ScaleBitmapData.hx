/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.transforms;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRendererPlugin;
import com.exploringlines.gale.core.renderer.RendererCacheObject;
import com.exploringlines.gale.core.resourceloader.CachedBitmapData;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * Rotates a bitmap.
 */
class ScaleBitmapData implements IRendererPlugin
{
	public var name:String;
	public var type:String;
	private static var tempBitmapData:BitmapData;
	private static inline var origin:Point = new Point(0, 0);
	private static var effectsMatrix:Matrix;
	private static var defaultParams:String = "1,1,false,false";
	
	public function new() {
		name = "scale";
		type = "pre";
	}
	
	/**
	 * Resizes a bitmapData.
	 * @param	bitmapData		The bitmapData to resize.
	 * @param	rectangle		The rectangle of the bitmapData.
	 * @param	width			The new width.
	 * @param	height			The new height.
	 * @return	The transformed bitmapData.
	 */
	public static inline function resizeBitmap(bitmapData:BitmapData, rectangle:Rectangle, width:Float, height:Float):CachedBitmapData {
		tempBitmapData = new BitmapData(Std.int(rectangle.width), Std.int(rectangle.height), true, 0xFFFFFF);
		tempBitmapData.copyPixels(bitmapData, rectangle, origin);
	
		effectsMatrix = new Matrix();
		effectsMatrix.scale(width / rectangle.width, height / rectangle.height);
		
		var transformedBitmap:BitmapData = new BitmapData(Std.int(width), Std.int(height), true, 0xFFFFFF);
		transformedBitmap.draw(tempBitmapData, effectsMatrix, null, null, null, true);
		
		var transformedRectangle:Rectangle = new Rectangle(0, 0, width, height);
			
		return new CachedBitmapData(transformedBitmap, transformedRectangle);
	}
	
	/**
	 * Scales a bitmapData on both the X and the Y axis.
	 * @param	bitmapData		The bitmapData to transform.
	 * @param	rectangle		The rectangle of the bitmapData.
	 * @param	scaleX			The scale X ratio.
	 * @param	scaleY			The scale Y ratio.
	 * @return
	 */
	public static inline function scaleBitmap(bitmapData:BitmapData, rectangle:Rectangle, scaleX:Float = 1, scaleY:Float = 1, flipHorizontal:Bool = false, flipVertical:Bool = false):CachedBitmapData {
		var sX:Float = scaleX <= 0 ? 0.01 : scaleX;
		var sY:Float = scaleY <= 0 ? 0.01 : scaleY;
		
		var width:Int = GaleMath.ceil(rectangle.width * sX);
		var height:Int = GaleMath.ceil(rectangle.height * sY);
		if (width == 0) {
			width = 1;
		}
		if (height == 0) {
			height = 1;
		}
		
		effectsMatrix = new Matrix();
		if (flipVertical && flipHorizontal) {
			effectsMatrix.scale( -1 * sX, -1 * sY);
			effectsMatrix.translate(width, height);
		} else if (flipVertical) {
			effectsMatrix.scale(1 * sX, -1 * sY);
			effectsMatrix.translate(0, height);
		} else if (flipHorizontal) {
			effectsMatrix.scale( -1 * sX, 1 * sY);
			effectsMatrix.translate(width, 0);
		} else {
			effectsMatrix.scale(sX, sY);
		}
		
		tempBitmapData = new BitmapData(Std.int(rectangle.width), Std.int(rectangle.height), true, 0xFFFFFF);
		tempBitmapData.copyPixels(bitmapData, rectangle, origin);
		
		var transformedBitmap:BitmapData = new BitmapData(width, height, true, 0xFFFFFF);
		transformedBitmap.draw(tempBitmapData, effectsMatrix, null, null, null, true);
		
		var transformedRectangle:Rectangle = new Rectangle(0, 0, width, height);
			
		return new CachedBitmapData(transformedBitmap, transformedRectangle);
	}
	
	/**
	 * Change the scale on an object.
	 * @param	object			The object to transform.
	 * @param	data			The scale separated by ',' for x and y.
	 * @return	The transformed object.
	 */
	public inline function apply(entity:IEntity, object:RendererCacheObject, data:String):RendererCacheObject {
		if (data == defaultParams) {
			if (object.center != null) {
				object.center.x = object.rectangle.width / 2;
				object.center.y = object.rectangle.height / 2;
			} else {
				object.center = new Point(object.rectangle.width / 2, object.rectangle.height / 2);
			}
			return object;
		}
		
		var params:Array < String > = data.split(',');
		var flipHorizontal:Bool = params[2] == "true" ? true : false;
		var flipVertical:Bool = params[3] == "true" ? true : false;
		var cb:CachedBitmapData = scaleBitmap(object.bitmapData, object.rectangle, Std.parseFloat(params[0]), Std.parseFloat(params[1]), flipHorizontal, flipVertical);
		
		return new RendererCacheObject(cb.bitmapData, cb.rectangle, new Point(cb.rectangle.width / 2, cb.rectangle.height / 2));
	}
	
}