/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.graphics;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.geom.Vector2;
import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.Vector;
import flash.Vector;
import flash.Vector;

/**
 * Contains functions that draw shapes and places them into a BitmapData.
 */
class Draw 
{	
	public static function drawLine(startX:Float, startY:Float, endX:Float, endY:Float, color:UInt = 0x000000, alpha:Float = 1, thickness:Float = 1):BitmapData {
		var canvas = new Sprite();
		canvas.graphics.lineStyle(thickness, color, alpha);
		canvas.graphics.moveTo(startX, startY);
		canvas.graphics.lineTo(endX, endY);
		
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(canvas.width), GaleMath.ceil(canvas.height), true, 0x00000000);
		bitmapData.draw(canvas);
		return bitmapData;
	}
	
	/**
	 * Creates a rectangular bitmapData.
	 * The color includes alpha.
	 * @param	width	The width of the rectangle.
	 * @param	height	The height of the rectangle.
	 * @param	color	The alpha and the fill color.
	 * @return	The created bitmapData.
	 */
	public static function drawRect(width:Float, height:Float, color:UInt = 0xFF000000):BitmapData {
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(width), GaleMath.ceil(height), true, color);
		
		return bitmapData;
	}
	
	/**
	 * Creates a rounded rectangle and draws it on a bitmapData.
	 * @param	width			The width of the rectangle.
	 * @param	height			The height of the rectangle.
	 * @param	ellipseWidth	The width of the ellipse used to draw the rounded corners.
	 * @param	ellipseHeight	The height fo the ellipse used to draw the rounded corners.
	 * @param	color			The color of the rounded rectangle.
	 * @param	alpha			The transparency of the rounded rectangle.
	 * @return	The drawn bitmapData.
	 */
	public static function drawRoundedRect(width:Float, height:Float, ellipseWidth:Float = 5, ellipseHeight:Float = 5, color:UInt = 0x000000, alpha:Float = 1, thickness:Float = 0, borderColor:UInt = 0x000000):BitmapData {
		var canvas:Sprite = new Sprite();
		canvas.graphics.beginFill(color, alpha);
		if (thickness != 0) {
			canvas.graphics.lineStyle(thickness, borderColor, alpha, true, null, CapsStyle.ROUND);
		}
		canvas.graphics.drawRoundRect(0, 0, width, height, ellipseWidth, ellipseHeight);
		canvas.graphics.endFill();
		
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(canvas.width), GaleMath.ceil(canvas.height), true, 0x00000000);
		bitmapData.draw(canvas);
		return bitmapData;
	}
	
	/**
	 * Draws a circle.
	 * @param	radius	The radius of the circle.
	 * @param	color	The color of the circle.
	 * @param	alpha	The transparency of the circle.
	 * @return	The drawn bitmapData.
	 */
	public static function drawCircle(radius:Float, color:UInt = 0x000000, alpha:Float = 1, thickness:Float = 0, borderColor:UInt = 0x000000):BitmapData {
		var canvas:Sprite = new Sprite();
		canvas.graphics.beginFill(color, alpha);
		if (thickness != 0) {
			canvas.graphics.lineStyle(thickness, borderColor, alpha, true, null, CapsStyle.ROUND);
		}
		canvas.graphics.drawCircle(radius, radius, radius);
		canvas.graphics.endFill();
		
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(canvas.width), GaleMath.ceil(canvas.height), true, 0x00000000);
		bitmapData.draw(canvas);
		
		return bitmapData;
	}
	
	/**
	 * Draws an ellipse.
	 * @param	width	The width of the ellipse.
	 * @param	height	The height of the ellipse.
	 * @param	color	The fill color of the ellipse.
	 * @param	alpha	The transparency of the ellipse.
	 * @return	The drawn ellipse as a bitmapData.
	 */
	public static function drawEllipse(width:Float, height:Float, color:UInt = 0x000000, alpha:Float = 1, thickness:Float = 0, borderColor:UInt = 0x000000):BitmapData {
		var canvas:Sprite = new Sprite();
		canvas.graphics.beginFill(color, alpha);
		if (thickness != 0) {
			canvas.graphics.lineStyle(thickness, borderColor, alpha, true, null, CapsStyle.ROUND);
		}
		canvas.graphics.drawEllipse(0, 0, width, height);
		canvas.graphics.endFill();
		
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(canvas.width), GaleMath.ceil(canvas.height), true, 0x00000000);
		bitmapData.draw(canvas);
		
		return bitmapData;
	}
	
	/**
	 * Draws an outline of a rectangle.
	 * @param	width		The width of the outline.
	 * @param	height		The height of the outline.
	 * @param	thickness	The thickness of the outline.
	 * @param	color		The color of the outline.
	 * @param	alpha		The transparency of the outline.
	 * @return	The rectangle outline.
	 */
	public static function drawRectOutline(width:Float, height:Float, thickness:Float = 1, rounded:Bool = false, color:UInt = 0x000000, alpha:Float = 1):BitmapData {
		var canvas:Sprite = new Sprite();
		var capsStyle:CapsStyle = rounded ? CapsStyle.ROUND : CapsStyle.SQUARE;
		var jointsStyle:JointStyle = rounded ? JointStyle.ROUND : JointStyle.MITER;
		canvas.graphics.beginFill(color, 0);
		canvas.graphics.lineStyle(thickness, color, alpha, true, null, capsStyle, jointsStyle);
		canvas.graphics.drawRect(thickness, thickness, width - thickness * 2, height - thickness * 2);
		canvas.graphics.endFill();
		
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(canvas.width + thickness), GaleMath.ceil(canvas.height + thickness), true, 0x00000000);
		bitmapData.draw(canvas);
		
		return bitmapData;
	}
	
	/**
	 * Draws an outline of a circle.
	 * @param	radius		The radius of the outline.
	 * @param	thickness	The thickness of the outline.
	 * @param	color		The color of the outline.
	 * @param	alpha		The transparency of the outline.
	 * @return	The circle outline.
	 */
	public static function drawCircleOutline(radius:Float, thickness:Float = 1, color:UInt = 0x000000, alpha:Float = 1):BitmapData {
		var canvas:Sprite = new Sprite();
		canvas.graphics.beginFill(color, 0);
		canvas.graphics.lineStyle(thickness, color, alpha, true, null, CapsStyle.ROUND, JointStyle.ROUND);
		canvas.graphics.drawCircle(radius, radius, radius - thickness);
		canvas.graphics.endFill();
		
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(canvas.width + thickness), GaleMath.ceil(canvas.height + thickness), true, 0x00000000);
		bitmapData.draw(canvas);
		
		return bitmapData;
	}
	
	/**
	 * Draws a triangle based on the given vertices.
	 * @param	vertexA		Vertex of the triangle.
	 * @param	vertexB		Vertex of the triangle.
	 * @param	vertexC		Vertex of the triangle.
	 * @param	color		The fill color of the triangle.
	 * @param	alpha		The transparency of the triangle.
	 * @return	The triangle.
	 */
	public static function drawTriangle(vertexA:Vector2, vertexB:Vector2, vertexC:Vector2, color:UInt = 0x000000, alpha:Float = 1):BitmapData {
		var canvas:Sprite = new Sprite();
		
		var commands:Vector<Int> = new Vector<Int>();
		commands[0] = 1;
		commands[1] = 2;
		commands[2] = 2;
		
		var coords:Vector<Float> = new Vector<Float>();
		coords[0] = vertexA.x;	coords[1] = vertexA.y;
		coords[2] = vertexB.x;	coords[3] = vertexB.y;
		coords[4] = vertexC.x;	coords[5] = vertexC.y;
		
		canvas.graphics.beginFill(color, alpha);
		canvas.graphics.drawPath(commands, coords);
		canvas.graphics.endFill();
		
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(canvas.width), GaleMath.ceil(canvas.height), true, 0x00000000);
		bitmapData.draw(canvas);
		
		return bitmapData;
	}
	
	/**
	 * Draws a path which is then filled.
	 * @param	paths	The vertices of the path.
	 * @param	color	The fill color.
	 * @param	alpha	The transparency.
	 * @return	The filled shape.
	 */
	public static function drawPath(commandsArray:Array<Int>, paths:Array<Vector2>, color:UInt = 0x000000, alpha:Float = 1):BitmapData {
		var canvas:Sprite = new Sprite();
		
		var commands:Vector<Int> = new Vector<Int>();
		for (i in 0...commandsArray.length) {
			commands[i] = commandsArray[i];
		}
		
		var coords:Vector<Float> = new Vector<Float>();
		for (i in 0...paths.length) {
			coords[i * 2] = paths[i].x;
			coords[i * 2 + 1] = paths[i].y;
		}
		
		canvas.graphics.beginFill(color, alpha);
		canvas.graphics.drawPath(commands, coords);
		canvas.graphics.endFill();
		
		var bitmapData:BitmapData = new BitmapData(GaleMath.ceil(canvas.width), GaleMath.ceil(canvas.height), true, 0x00000000);
		bitmapData.draw(canvas);
		
		return bitmapData;
	}
}