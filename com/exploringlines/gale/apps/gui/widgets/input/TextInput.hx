/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.gui.widgets.input;
import com.exploringlines.gale.apps.graphics.Draw;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.apps.text.Text;
import com.exploringlines.gale.apps.timers.CountdownTimer;
import com.exploringlines.gale.apps.timers.PeriodicTimer;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.core.input.KeyCodes;
import com.exploringlines.gale.core.Node;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.RootScene;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

typedef TextInputStyle = {
	var font:String;
	var fontSize:Int;
	var fontColor:UInt;
	var width:Float;
	var height:Float;
	var backgroundColor:UInt;
	var roundedCornerAmount:Float;
}

/**
 * Captures input and converts it to a string while active.
 * Includes a display and field for users to type in.
 */
class TextInput extends Node {
	private var rootScene:RootScene;
	private var inputData:InputData;
	private var layer:Int;
	private var style:TextInputStyle;
	
	private var lastKeyIndex:Int;
	private var initialRepeatRate:CountdownTimer;
	private var keyRepeatRate:PeriodicTimer;
	private var isActive:Bool;
	private var text:Text;
	
	// The valid keys for input.
	private var validKeys:Array<Int>;
	
	/**
	 * If set to true, the field will be able to become active.
	 */
	public var isEnabled:Bool;
	
	/**
	 * The string currently in the input field.
	 */
	public var inputString(default, setInputString):String;
	
	/**
	 * The maximum characters allowed in the field.
	 */
	public var charLimit:Int;
	
	/**
	 * The area to be clicked for the input to be active.
	 */
	public var rectangle:Rectangle;
	
	// Shows the text input beam when true.
	public var showIBeam:Bool;

	public function new(rootScene:RootScene, inputData:InputData, layer:Int = 0, ?position:Vector2, ?style:TextInputStyle) {
		super(position);
		
		this.rootScene = rootScene;
		this.inputData = inputData;
		this.layer = layer;

		if (style == null) {
			this.style = { font : "DroidSans", fontSize : 14, fontColor : 0x000000, 
						   width : 150.0, height : 20.0, backgroundColor : 0xFFFFFF, roundedCornerAmount : 3.0};
		} else {
			this.style = style;
		}
		
		rectangle = new Rectangle(position.x, position.y, this.style.width, this.style.height);
		lastKeyIndex = InputData.NEUTRAL_KEY_INDEX;
		var defaultInitialRepeatRate:Int = 250;
		var defaultKeyRepeatRate:Int = 50;
		this.initialRepeatRate = new CountdownTimer(defaultInitialRepeatRate);
		this.keyRepeatRate = new PeriodicTimer(defaultKeyRepeatRate);

		drawTextInput(this.style);
		
		showIBeam = true;
		charLimit = 20;
		isActive = false;
		isEnabled = true;
		inputString = "";
	}
	
	/**
	 * Sets the valid characters for input.
	 * @param	characters	The characters to set.
	 */
	public function setValidCharacters(characters:String):Void {
		var charCode:Int;
		validKeys = [];
		for (i in 0...characters.length) {
			charCode = characters.charCodeAt(i);
			validKeys.push(charCode);
			
			// Also add the numpad keys for input.
			if (charCode >= KeyCodes.K0 && charCode <= KeyCodes.K9) {
				validKeys.push(charCode + (KeyCodes.KP0 - KeyCodes.K0));
			}
		}
	}
	
	/**
	 * Checks if the key is within the restricted characters.
	 * @param	keyCode	The code of the key.
	 * @return	True if valid, false otherwise.
	 */
	private inline function isKeyValid(keyCode:Int):Bool {
		var isValid = false;
		
		if (validKeys == null) {
			isValid = true;
		} else {
			for (i in 0...validKeys.length) {
				if (validKeys[i] == keyCode) {
					isValid = true;
					break;
				}
			}
		}
		
		return isValid;
	}
	
	/**
	 * Logs the key as long as the string is not at the character limit.
	 * @param	keyCode		The key being logged.
	 */
	private inline function logKey(keyCode:Int):Void {
		// If backspace is pressed, delete the last key.
		if (inputData.currentKeyDown == KeyCodes.BACK) {
			if (inputString.length > 1) {
				inputString = inputString.substr(0, inputString.length - 1);
			} else {
				inputString = "";
			}
		} else {
			if (inputString.length < charLimit) {
				if (isKeyValid(keyCode)) {
					if (!inputData.isShiftDown) {
						inputString += String.fromCharCode(keyCode).toLowerCase();
					} else {
						inputString += String.fromCharCode(keyCode);
					}
				}
			}
		}
	}
	
	/**
	 * Checks the user input.
	 * @param	deltaTime	The time passed since the last update.
	 */
	private inline function checkKeyInput(deltaTime:Int = 0):Void {
		if (inputData.currentKeyUp != InputData.NEUTRAL_KEY_INDEX) {
			lastKeyIndex = InputData.NEUTRAL_KEY_INDEX;
		}
		if (inputData.currentKeyDown != InputData.NEUTRAL_KEY_INDEX && inputData.currentKeyDown != KeyCodes.SHIFT && inputData.currentKeyDown != KeyCodes.CONTROL) {
			if (inputData.currentKeyDown != lastKeyIndex) {
				logKey(inputData.currentKeyDown);
				initialRepeatRate.reset();
				keyRepeatRate.reset();
			} else {
				initialRepeatRate.update(deltaTime);
				if (initialRepeatRate.isReady) {
					keyRepeatRate.update(deltaTime);
					if (keyRepeatRate.isReady) {
						logKey(inputData.currentKeyDown);
					}
				}
			}
			lastKeyIndex = inputData.currentKeyDown;
		}
	}
	
	/**
	 * Checks if the TextInput should be activated.
	 */
	private inline function checkIfActive():Void {
		if (inputData.isMouseClicked) {
			if (isCoordinateInRectangle(inputData.mouseClickLocationX, inputData.mouseClickLocationY)) {
				isActive = true;
			} else {
				isActive = false;
			}
		}
		if (showIBeam) {
			if (isCoordinateInRectangle(inputData.mouseLocationX, inputData.mouseLocationY)) {
				inputData.isMouseIBeam = true;
			} else {
				inputData.isMouseIBeam = false;
			}
		}
	}
	
	override public function update(deltaTime:Int = 0):Void {
		super.update(deltaTime);
		
		if (isEnabled) {
			rectangle.x = derivedPosition.x - rectangle.width / 2;
			rectangle.y = derivedPosition.y - rectangle.height / 2;
			
			checkIfActive();
			if (isActive) {
				checkKeyInput(deltaTime);
			}
		}
	}
	
	/**
	 * Draws the text input field and adds them to the node.
	 * This can be overriden to change the display.
	 * @param	style	The style used in the field.
	 */
	private function drawTextInput(style:TextInputStyle):Void {
		var field:BitmapData = Draw.drawRoundedRect(style.width, style.height, style.roundedCornerAmount, style.roundedCornerAmount, style.backgroundColor, 1, 0, 0);
		var entity:IEntity = rootScene.createEntity("Dummy", layer, null, "TextInput" + Std.string(style.width) + Std.string(style.height) + Std.string(style.backgroundColor));
		entity.bitmapData = field;
		entity.rectangle = field.rect;
		attachObject(entity);
		
		text = rootScene.createText(layer, "", new Point(-style.width / 2, -style.height / 2), style.fontSize, style.fontColor, style.font, Align.LEFT);
		text.isCentered = false;
		text.width = style.width;
		attachObject(text);
	}
	
	/**
	 * Tests if a coordinate is inside the rectangle.
	 * @param	x		The x coordinate.
	 * @param	y		The y coordinate.
	 * @return	Returns true if the coordinates are inside the rectangle.
	 */
	private inline function isCoordinateInRectangle(x:Float, y:Float):Bool {
		return (x >= rectangle.x && x <= rectangle.right) && (y >= rectangle.y && y <= rectangle.bottom);
	}
	
	/**
	 * Sets the string of the input and the display text.
	 * @param	v	The string to set.
	 * @return	The inputString.
	 */
	private inline function setInputString(v:String):String {
		inputString = v;
		text.text = v;
		
		return inputString;
	}
}