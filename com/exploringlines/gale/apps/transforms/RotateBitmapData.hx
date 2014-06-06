/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.transforms;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRendererPlugin;
import com.exploringlines.gale.core.renderer.RendererCacheObject;
import com.exploringlines.gale.core.resourceloader.CachedBitmapData;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;

/**
 * Rotates a bitmap.
 */
class RotateBitmapData implements IRendererPlugin
{
	public var name:String;
	public var type:String;
	private static var tempBitmapData:BitmapData;
	private static var point:Point = new Point(0, 0);
	private static var effectsMatrix:Matrix;
	private static var defaultParams:String = "0";
	
	/**
	 * The multiplier for the new rectangle.
	 * 1.4142 is an approximation of the diagonal of a square's ratio to it's side length.
	 */
	private static var rectangleMultiplier:Float = 1.4142;
	
	/**
	 * If true, the input will be in degrees.
	 */
	private static var isDegrees:Bool = true;
	
	/**
	 * If true, the degree of rotation is estimated.
	 * Estimating the rotation will be faster.
	 */
	private static var isEstimated:Bool = true;
	
	public function new(isDegrees:Bool = true, isEstimated:Bool = true) {
		name = "rotation";
		type = "pre";
		RotateBitmapData.isDegrees = isDegrees;
		RotateBitmapData.isEstimated = isEstimated;
	}
	
	/**
	 * Rotates a bitmapData at the specified angle.
	 * @param	bitmapData		The bitmapData to be rotated.
	 * @param	rectangle		The rectangle of the bitmapData.
	 * @param	angle			The angle of the rotation in radians.
	 * @return	The CachedBitmapData with the new rotated bitmapData.
	 */
	inline public static function rotateBitmap(bitmapData:BitmapData, rectangle:Rectangle, angle:Float):CachedBitmapData {
		var dimensions:Int;
		if (rectangle.width > rectangle.height) {
			rectangleMultiplier = Math.sqrt(rectangle.width * rectangle.width + rectangle.height * rectangle.height) / rectangle.width;
			dimensions = Std.int(rectangle.width * RotateBitmapData.rectangleMultiplier);
		} else {
			rectangleMultiplier = Math.sqrt(rectangle.width * rectangle.width + rectangle.height * rectangle.height) / rectangle.height;
			dimensions = Std.int(rectangle.height * RotateBitmapData.rectangleMultiplier);
		}
		if (dimensions % 2 != 0) {
			dimensions++;
		}
		
		point.x = dimensions / 2 - rectangle.width / 2;
		point.y = dimensions / 2 - rectangle.height / 2;
		tempBitmapData = new BitmapData(dimensions, dimensions, true, 0xFFFFFF);
		tempBitmapData.copyPixels(bitmapData, rectangle, point);
	
		effectsMatrix = new Matrix();
		effectsMatrix.translate( -dimensions / 2, -dimensions / 2);
		effectsMatrix.rotate(angle);
		effectsMatrix.translate(dimensions / 2, dimensions/ 2);
		
		var transformedBitmap:BitmapData = new BitmapData(dimensions, dimensions, true, 0xFFFFFF);
		transformedBitmap.draw(tempBitmapData, effectsMatrix, null, null, null, true);
		
		var transformedRectangle:Rectangle = new Rectangle(0, 0, dimensions, dimensions);
			
		return new CachedBitmapData(transformedBitmap, transformedRectangle);
	}
	
	/**
	 * Change the alpha on an object.
	 * @param	object			The object to transform.
	 * @param	data			The alpha amount.
	 * @return	The transformed object.
	 */
	inline public function apply(entity:IEntity, object:RendererCacheObject, data:String):RendererCacheObject {
		if (data == defaultParams) {
			if (object.center != null) {
				object.center.x = object.rectangle.width / 2;
				object.center.y = object.rectangle.height / 2;
			} else {
				object.center = new Point(object.rectangle.width / 2, object.rectangle.height / 2);
			}
			return object;
		}
		var angle:Float;
		if (isDegrees) {
			if (RotateBitmapData.isEstimated) {
				angle = Std.parseInt(data) * 0.0174532925;
			} else {
				angle = Std.parseInt(data) * Math.PI / 180;
			}
		} else {
			angle = Std.parseFloat(data);
		}
		var cb:CachedBitmapData = rotateBitmap(object.bitmapData, object.rectangle, angle);
		
		return new RendererCacheObject(cb.bitmapData, cb.rectangle, new Point(cb.rectangle.width / 2, cb.rectangle.height / 2));
	}
	
}