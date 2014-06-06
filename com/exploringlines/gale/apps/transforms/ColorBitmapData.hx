/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.transforms;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRendererPlugin;
import com.exploringlines.gale.core.renderer.RendererCacheObject;
import com.exploringlines.gale.core.resourceloader.CachedBitmapData;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * Change the alpha on a bitmap.
 */
class ColorBitmapData implements IRendererPlugin
{
	public var name:String;
	public var type:String;
	private static var tempBitmapData:BitmapData;
	private static inline var origin:Point = new Point(0, 0);
	private static var colorTransform:ColorTransform = new ColorTransform();
	private static var defaultParams:String = "1,0,0,0";
	
	public function new() {
		name = "color";
		type = "pre";
	}
	
	/**
	 * Change the color on a bitmapData.
	 * @param	bitmapData		The bitmapData to be faded.
	 * @param	rectangle		The rectangle of the bitmapData.
	 * @param	alpha			The opacity of the bitmapdata.
	 * @param	redOffset		The red offset.
	 * @param	greenOffset		The green offset.
	 * @param	blueOffset		The blue offset.
	 * @return	The CachedBitmapData with the new faded bitmapData.
	 */
	public static inline function colorBitmap(bitmapData:BitmapData, rectangle:Rectangle, alpha:Float = 1, redOffset:Int = 0, greenOffset:Int = 0, blueOffset:Int = 0):CachedBitmapData {
		tempBitmapData = new BitmapData(Std.int(rectangle.width), Std.int(rectangle.height), true, 0xFFFFFF);
		tempBitmapData.copyPixels(bitmapData, rectangle, origin);
		colorTransform.alphaMultiplier = alpha;
		colorTransform.redOffset = redOffset;
		colorTransform.greenOffset = greenOffset;
		colorTransform.blueOffset = blueOffset;
		tempBitmapData.colorTransform(rectangle, colorTransform);
		
		var transformedRectangle:Rectangle = rectangle.clone();
		transformedRectangle.x = 0;
		transformedRectangle.y = 0;
			
		return new CachedBitmapData(tempBitmapData, transformedRectangle);
	}
	
	/**
	 * Change the color on an object.
	 * @param	object			The object to transform.
	 * @param	data			The color parameters.
	 * @return	The transformed object.
	 */
	public inline function apply(entity:IEntity, object:RendererCacheObject, data:String):RendererCacheObject {
		if (data == defaultParams) {
			return object;
		}
		
		var params:Array<String> = data.split(',');
		var alpha:Float = Std.parseFloat(params[0]);
		if (alpha < 0) {
			alpha = 0;
		} else if (alpha > 1) {
			alpha = 1;
		}
		
		var cb:CachedBitmapData = colorBitmap(object.bitmapData, object.rectangle, alpha, Std.parseInt(params[1]), Std.parseInt(params[2]), Std.parseInt(params[3]));
		
		return new RendererCacheObject(cb.bitmapData, cb.rectangle);
	}
	
}