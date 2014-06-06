/**
 * @author MW
 */

package com.exploringlines.gale.apps.benchmark;
import com.exploringlines.gale.core.Globals;
import flash.display.Stage;
import flash.Lib;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * Displays the frames per second and memory usage.
 */
class Profiler 
{
	private var stage:Stage;
	
	private var textFormat:TextFormat;
	
	private var framesPerSecond:Int;
	private var frameTimer:Int;
	private var lastTime:Int;
	private var lastUpdateTime:Int;
	private var interval:Int;
	private var framesText:TextField;
	private var timer:Int;
	
	private var logicText:TextField;
	private var logicFps:Int;
	private var logicInterval:Int;
	private var logicLastTime:Int;
	private var logicCurrentTime:Int;
	private var logicTimer:Int;
	
	private var displayText:TextField;
	private var displayFps:Int;
	private var displayInterval:Int;
	private var displayLastTime:Int;
	private var displayCurrentTime:Int;
	private var displayTimer:Int;
	
	private var memoryText:TextField;

	/**
	 * Creates a frames per second and memory usage counter.
	 */
	public function new(color:UInt) 
	{
		stage = Globals.stage;
		
		textFormat = new TextFormat();
		textFormat.size = 11;
		textFormat.color = color;
		textFormat.bold = true;
		
		createFramesPerSecondLogger();
		createDisplayFpsLogger();
		createLogicFpsLogger();
		createMemoryUsageLogger();
	}
	
	/**
	 * Updates the frames per second and memory usage.
	 */
	public function update(startTime:Int, endTime:Int) {
		updateFramesPerSecond(startTime, endTime);
		updateMemoryUsage();
	}
	
	/**
	 * Creates a new frames per second counter.
	 */
	public function createDisplayFpsLogger():Void {
		displayText = new TextField();
		displayText.selectable = false;
		displayText.x = 100;
		displayText.y = 18;
		stage.addChild(displayText);
		displayText.text = "Display: 0";
		displayText.setTextFormat(textFormat);
		
		displayFps = 0;
		displayInterval = 1000;
		displayLastTime = Lib.getTimer();
		displayTimer = 0;
	}
	
	/**
	 * Updates the frames per second.
	 */
	public inline function updateDisplayFps(beginTime:Int, endTime:Int):Void {
		displayFps++;
		
		displayCurrentTime = Lib.getTimer();
		displayTimer += displayCurrentTime - displayLastTime;
		displayLastTime = displayCurrentTime;
		
		var timeTaken:Int = endTime - beginTime;
		
		if (displayTimer >= displayInterval) {
			displayTimer = 0;
			displayText.text = "Display: " + Std.string(displayFps) + " - " + Std.string(timeTaken) + "ms";
			displayText.setTextFormat(textFormat);
			displayFps = 0;
		}
	}
	
	/**
	 * Creates a new frames per second counter.
	 */
	public function createLogicFpsLogger():Void {
		logicText = new TextField();
		logicText.selectable = false;
		logicText.x = 100;
		logicText.y = 0;
		stage.addChild(logicText);
		logicText.text = "Logic: 0";
		logicText.setTextFormat(textFormat);
		
		logicFps = 0;
		logicInterval = 1000;
		logicLastTime = Lib.getTimer();
		logicTimer = 0;
	}
	
	/**
	 * Updates the frames per second.
	 */
	public inline function updateLogicFps(beginTime:Int, endTime:Int):Void {
		logicFps++;
		
		logicCurrentTime = Lib.getTimer();
		logicTimer += logicCurrentTime - logicLastTime;
		logicLastTime = logicCurrentTime;
		
		var timeTaken:Int = endTime - beginTime;
		
		if (logicTimer >= logicInterval) {
			logicTimer = 0;
			logicText.text = "Logic: " + Std.string(logicFps) + " - " + Std.string(timeTaken) + "ms";
			logicText.setTextFormat(textFormat);
			logicFps = 0;
		}
	}
	
	/**
	 * Creates a new frames per second counter.
	 */
	public function createFramesPerSecondLogger():Void {
		framesText = new TextField();
		framesText.selectable = false;
		framesText.x = 0;
		framesText.y = 0;
		stage.addChild(framesText);
		framesText.text = "Root: 0";	
		framesText.setTextFormat(textFormat);
		
		lastTime = 0;
		interval = 1000;
		lastUpdateTime = 0;
		frameTimer = 0;
		framesPerSecond = 0;
	}
	
	/**
	 * Updates the frames per second.
	 */
	private inline function updateFramesPerSecond(beginTime:Int, endTime:Int):Void {
		if (framesText != null) {
			timer = Lib.getTimer();
			frameTimer += timer - lastTime;
			lastTime = timer;
			framesPerSecond++;
			
			var timeTaken:Int = endTime - beginTime;
			if (frameTimer > lastUpdateTime + interval) {
				lastUpdateTime += interval;
				framesText.text = "Root: " + Std.string(framesPerSecond) + " - " + Std.string(timeTaken) + "ms";
				framesText.setTextFormat(textFormat);
				framesPerSecond = 0;
			}
		}
	}
	
	/**
	 * Creates the memory usage counter.
	 */
	private function createMemoryUsageLogger():Void {
		memoryText = new TextField();
		memoryText.selectable = false;
		memoryText.x = 0;
		memoryText.y = 18;
		stage.addChild(memoryText);
		memoryText.text = "Mem: 0";
		memoryText.setTextFormat(textFormat);
	}
	
	/**
	 * Updates the memory usage.
	 */
	private inline function updateMemoryUsage():Void {
		if (memoryText != null) {
			memoryText.text = "Mem: " + Std.string(round2(System.totalMemory / 1024 / 1024, 2)) + " Mb";
			memoryText.setTextFormat(textFormat);
		}
	}
	
	/**
	 * Rounds a float with a set precision.
	 * @param	number		The number to round.
	 * @param	precision	The precision of the float.
	 * @return	The rounded number.
	 */
	private inline function round2( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}

}