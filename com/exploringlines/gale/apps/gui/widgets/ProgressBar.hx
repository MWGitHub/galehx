/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.gui.widgets;
import com.exploringlines.gale.core.resourceloader.CachedBitmapData;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * The direction of the bar.
 */
enum BarDirection {
	VERTICAL;
	HORIZONTAL;
}

/**
 * The direction the bar increases.
 */
enum GrowDirection {
	POSITIVE;
	NEGATIVE;
}

/**
 * A progress bar.
 */
class ProgressBar 
{
	private var width:Int;
	private var height:Int;
	private var borderThickness:Int;
	private var color:UInt;
	private var borderColor:UInt;
	
	private var progressPoint:Point;
	private var display:BitmapData;
	private var progressBitmapData:BitmapData;
	private var progressRectangle:Rectangle;
	private var borderBitmapData:BitmapData;
	private var direction:BarDirection;
	private var growDirection:GrowDirection;
	private var neededProgress:Float;
	
	private var cachedBitmapData:CachedBitmapData;

	public function new(neededProgress:Float, direction:BarDirection, growDirection:GrowDirection, width:Int = 100, 
						height:Int = 10, borderThickness:Int = 2, color:UInt = 0x000000, borderColor:UInt = 0xFFFFFF) 
	{
		this.width = width;
		this.height = height;
		this.borderThickness = borderThickness;
		this.color = color;
		this.borderColor = borderColor;
		this.neededProgress = neededProgress;
		this.direction = direction;
		this.growDirection = growDirection;
		
		progressPoint = new Point(borderThickness * 1.5, borderThickness * 1.5);
		display = new BitmapData(width + borderThickness, height + borderThickness, true, 0xFFFFFF);
		progressBitmapData = new BitmapData(width, height, true, 0xFFFFFF);
		progressRectangle = new Rectangle(0, 0, width, height);
		
		var shape:Shape = new Shape();
		shape.graphics.beginFill(color);
		shape.graphics.drawRect(0, 0, width, height);
		shape.graphics.endFill();
		progressBitmapData.draw(shape);
		
		
		borderBitmapData = new BitmapData(width + borderThickness * 2, height + borderThickness * 2, true, 0xFFFFFF);
		
		var borderCommands:flash.Vector<Int> = new flash.Vector<Int>(5, true);
		borderCommands[0] = 1;
		borderCommands[1] = 2;
		borderCommands[2] = 2;
		borderCommands[3] = 2;
		borderCommands[4] = 2;
		var borderCoordinates:flash.Vector<Float> = new flash.Vector<Float>(10, true);
		borderCoordinates[0] = borderThickness; borderCoordinates[1] = borderThickness;
		borderCoordinates[2] = borderThickness; borderCoordinates[3] = height + borderThickness;
		borderCoordinates[4] = width + borderThickness; borderCoordinates[5] = height + borderThickness;
		borderCoordinates[6] = width + borderThickness; borderCoordinates[7] = borderThickness;
		borderCoordinates[8] = borderThickness; borderCoordinates[9] = borderThickness;
		shape.graphics.clear();
		shape.graphics.lineStyle(borderThickness, borderColor);
		shape.graphics.drawPath(borderCommands, borderCoordinates);
		borderBitmapData.draw(shape);
		
		cachedBitmapData = new CachedBitmapData(display, display.rect);
	}
	
	public inline function setNeededProgress(neededProgress:Float):Void {
		this.neededProgress = neededProgress;
		update(0);
	}
	
	public inline function update(progress:Float):Void {
		var progressRatio:Float = progress / neededProgress;
		if (progressRatio > 1) 
			progressRatio = 1;
			
		if (direction == BarDirection.VERTICAL) {
			progressRectangle.width = width;
			progressRectangle.height = progressRatio * height;
			if (growDirection == GrowDirection.NEGATIVE) {
				progressPoint.y = height - progressRectangle.height + borderThickness * 1.5;
			}
		} else {
			progressRectangle.width = progressRatio * width;
			progressRectangle.height = height;
			if (growDirection == GrowDirection.NEGATIVE) {
				progressPoint.x = width - progressRectangle.width + borderThickness * 2;
			}
		}
		
		display.lock();
		display.copyPixels(borderBitmapData, borderBitmapData.rect, GuiCommon.originPoint);
		display.copyPixels(progressBitmapData, progressRectangle, progressPoint);
		display.unlock();
	}
	
	public inline function getDisplay():CachedBitmapData {
		return cachedBitmapData;
	}
}