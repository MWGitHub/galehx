package com.exploringlines.gale.core.input;

import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.Lib;
import flash.ui.MouseCursor;

/**
 * Manages and updates the inputs for the keyboard and mouse.
 * The inputs can be retrieved by passing the inputData variable.
 */
class InputListener implements IInputListener {
	private var stage:Stage;
	private var isMouseOut:Bool;
	
	private var keyCodeIndices:Array<Int>;
	
	/**
	 * The time elapsed since the beginning of the game, updated through each update.
	 */
	private var timeElapsed:Int;
	
	/**
	 * The time elapsed before triggered is set to false.
	 */
	private var persistence:Int;
	private var keyPressTime:Array<Int>;
	
	/**
	 * The input data for the keyboard and mouse.
	 */
	public var inputData:InputData;
	
	/**
	 * Used to shift the camera mouse positions.
	 */
	public var scaleX:Float;
	public var scaleY:Float;
	public var position:Point;

	/**
	 * Assigns key and mouse event listeners to the stage.
	 * @param	s The stage where the event listeners will be assigned to.
	 */
	public function new(?stage:Stage, persistence:Int = 45) { 
		if (stage != null) {
			this.stage = stage;
		} else {
			this.stage = Lib.current.stage;
		}
		
		this.persistence = persistence;
		timeElapsed = 0;
		keyPressTime = [];
		
		inputData = new InputData();
		isMouseOut = true;
		inputData.isMouseOut = true;
		
		keyCodeIndices = [];
		var keys = Type.getClassFields(KeyCodes);
		var index:Int;
		for (i in 0...keys.length) {
			index = Reflect.field(KeyCodes, keys[i]);
			keyCodeIndices.push(index);
			inputData.isKeyReleased[index] = true;
			keyPressTime[index] = 0;
		}
		
		this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		this.stage.addEventListener(Event.MOUSE_LEAVE, onMouseOut);
		
		scaleX = 1;
		scaleY = 1;
		position = new Point();
	}
	
	public function update(deltaTime:Int) {
		timeElapsed += deltaTime;
	}

	/**
	 * Resets the mouse click locations.
	 */
	public function resetMouseClick():Void {
		inputData.isMouseClicked = false;
		inputData.isMouseReleased = false;
		inputData.mouseClickLocationX = InputData.NEUTRAL_MOUSE_POSITION;
		inputData.mouseClickLocationY = InputData.NEUTRAL_MOUSE_POSITION;
		inputData.mouseReleaseLocationX = InputData.NEUTRAL_MOUSE_POSITION;
		inputData.mouseReleaseLocationY = InputData.NEUTRAL_MOUSE_POSITION;
	}
	
	/**
	 * Resets the cursor to an arrow.
	 */
	public function checkCursor():Void {
		if (!isMouseOut) {
			if (inputData.isMouseHidden) {
				Mouse.cursor = MouseCursor.AUTO;
				Mouse.hide();
			} else {
				Mouse.show();
				if (inputData.isMouseHandButton) {
					Mouse.cursor = MouseCursor.BUTTON;
					inputData.isMouseHandButton = false;
				} else if (inputData.isMouseHand) {
					Mouse.cursor = MouseCursor.HAND;
					inputData.isMouseHand = false;
				} else if (inputData.isMouseIBeam) {
					Mouse.cursor = MouseCursor.IBEAM;
				} else {
					Mouse.cursor = MouseCursor.AUTO;
				}
			}
		}
	}
	
	public function onMouseOut(e:Event):Void {
		Mouse.cursor = MouseCursor.AUTO;
		Mouse.show();
		isMouseOut = true;
		inputData.isMouseOut = true;
	}
	
	/**
	 * Resets the shift and control inputs.
	 */
	public function resetModifiers():Void {
		inputData.isMouseClicked = false;
		inputData.isKeyTriggered = [];
		
		for (i in 0...keyCodeIndices.length) {
			if (inputData.isKeyDown[keyCodeIndices[i]]) {
				if (keyPressTime[keyCodeIndices[i]] + persistence >= timeElapsed) {
					inputData.isKeyTriggered[keyCodeIndices[i]] = true;
				}
			}
		}
	}
	
	/**
	 * Resets key inputs. Key inputs can be manually reset to prevent errors or locked keys.
	 */
	private function onKeyUp(e:KeyboardEvent):Void {
		inputData.isCtrlDown = e.ctrlKey;
		inputData.isShiftDown = e.shiftKey;
		inputData.isKeyDown[e.keyCode] = false;
		inputData.isKeyReleased[e.keyCode] = true;
		inputData.currentKeyDown = InputData.NEUTRAL_KEY_INDEX;
		inputData.currentKeyUp = e.keyCode;
		//trace(e.keyCode);
	}
	
	/**
	 * Sets key inputs when pressed based on the keyCode.
	 */
	private function onKeyDown(e:KeyboardEvent):Void {
		inputData.isCtrlDown = e.ctrlKey;
		inputData.isShiftDown = e.shiftKey;
		inputData.isKeyDown[e.keyCode] = true;
		inputData.currentKeyDown = e.keyCode;
		inputData.currentKeyUp = InputData.NEUTRAL_KEY_INDEX;
		if (inputData.isKeyReleased[e.keyCode]) {
			inputData.isKeyTriggered[e.keyCode] = true;
			inputData.isKeyReleased[e.keyCode] = false;
			keyPressTime[e.keyCode] = timeElapsed;
		}
		//trace(e.keyCode);
	}
	
	/**
	 * Updates the mouse coordinates.
	 */
	private function onMouseMove(e:MouseEvent):Void {
		inputData.mouseLocationX = (e.stageX + position.x) * scaleX;
		inputData.mouseLocationY = (e.stageY + position.y) * scaleY;
		isMouseOut = false;
		inputData.isMouseOut = false;
	}
	
	/**
	 * Sets the mouse click location and sets the mouse primary button as down.
	 */
	private function onMouseDown(e:MouseEvent):Void {
		inputData.mouseClickLocationX = (e.stageX + position.x) * scaleX;
		inputData.mouseClickLocationY = (e.stageY + position.y) * scaleY;
		inputData.isMouseDown = true;
		inputData.isMouseClicked = true;
	}
	
	/**
	 * Resets the mouse when the primary button is released.
	 */
	private function onMouseUp(e:MouseEvent):Void {
		inputData.mouseReleaseLocationX = (e.stageX + position.x) * scaleX;
		inputData.mouseReleaseLocationY = (e.stageY + position.y) * scaleY;
		inputData.isMouseReleased = true;
		inputData.isMouseDown = false;
	}
}