/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.math.geom;

class Shapes {
	public static function plotLine(startX:Int, endX:Int, startY:Int, endY:Int):Array<Array<Int>> {
		var x1:Int = startX;
		var x2:Int = endX;
		var y1:Int = startY;
		var y2:Int = endY;
		
		var deltaX:Int = GaleMath.absInt(x2 - x1);
		var deltaY:Int = GaleMath.absInt(y2 - y1);
		var x:Int = x1;
		var y:Int = y1;
		
		var xInc1:Int = 0;
		var xInc2:Int = 0;
		var yInc1:Int = 0;
		var yInc2:Int = 0;
		if (x2 >= x1) {
			xInc1 = 1;
			xInc2 = 1;
		} else {
			xInc1 = -1;
			xInc2 = -1;
		}
		
		if (y2 >= y1) {
			yInc1 = 1;
			yInc2 = 1;
		} else {
			yInc1 = -1;
			yInc2 = -1;
		}
		
		var den:Float = 0;
		var num:Float = 0;
		var numAdd:Int = 0;
		var steps:Int = 0;
		if (deltaX >= deltaY) {
			xInc1 = 0;
			yInc2 = 0;
			den = deltaX;
			num = deltaX / 2;
			numAdd = deltaY;
			steps = deltaX;
		} else {
			xInc2 = 0;
			yInc1 = 0;
			den = deltaY;
			num = deltaY / 2;
			numAdd = deltaX;
			steps = deltaY;
		}
		
		var output:Array<Array<Int>> = [];
		for (step in 0...steps) {
			output.push([x, y]);
			num += numAdd;
			if (num >= den) {
				num -= den;
				x += xInc1;
				y += yInc1;
			}
			x += xInc2;
			y += yInc2;
		}
		
		return output;
	}
}