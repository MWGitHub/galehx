/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.input;

/**
 * Assign multiple keys to commands and allow for repeating presses or triggers.
 */
class ControlData 
{
	private var inputData:InputData;
	
	/**
	 * Keys to check.
	 */
	public var keys:Array<Int>;
	
	/**
	 * True if pressed, false otherwise.
	 */
	public var isPressed:Bool;
	
	/**
	 * True if the key has been released.
	 */
	public var isReleased:Bool;
	
	// When set to true the key will no longer be pressed if held down after a set persistance.
	public var isTriggered:Bool;
	
	// Time to continue pressing the button after release (only used with triggering).
	public var persistance:Int;
	private var timer:Int;

	public function new(inputData:InputData, isTriggered:Bool, keys:Array<Int>, persistance:Int = 0) 
	{
		this.inputData = inputData;
		this.keys = keys;
		this.isTriggered = isTriggered;
		isPressed = false;
		isReleased = true;
		this.persistance = persistance;
		timer = 0;
	}
	
	/**
	 * Check the keys to see if they should be pressed, released, or triggered.
	 * @param	deltaTime	Time passed since the last update (used only with triggers).
	 */
	public function checkKeys(deltaTime:Int = 0):Void {
		timer += deltaTime;
		// Check if the key should be released based on keys down.
		if (isTriggered && timer >= persistance) {
			isPressed = false;
		}
		var areKeysPressed:Bool = false;
		for (i in 0...keys.length) {
			if (inputData.isKeyDown[keys[i]]) {
				areKeysPressed = true;
				break;
			}
		}
		if (!areKeysPressed) {
			isReleased = true;
			if (!isTriggered) {
				isPressed = false;
			}
		}
		// Check each key to see if pressed if not triggered else just check keys if the keys have been released before.
		if (!isTriggered) {
			for (i in 0...keys.length) {
				if (inputData.isKeyDown[keys[i]]) {
					isPressed = true;
					isReleased = false;
					timer = 0;
					break;
				}
			}
		} else {
			if (isReleased) {
				for (i in 0...keys.length) {
					if (inputData.isKeyDown[keys[i]]) {
						isPressed = true;
						isReleased = false;
						timer = 0;
						break;
					}
				}
			}
		}
	}
	
	/**
	 * Resets the trigger persistance
	 */
	public function resetTrigger():Void {
		timer = persistance;
		isPressed = false;
	}
}