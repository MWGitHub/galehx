package com.exploringlines.gale.core.input;
/**
 * Holds the data for the keyboard and mouse inputs.
 * @author MW
 */
 
class InputData 
{
	public static var NEUTRAL_MOUSE_POSITION:Float = -100000;
	public static var NEUTRAL_KEY_INDEX:Int = -100000;
	
	/**
	 * Holds the flags of keys pressed based on a code.
	 */
	public var isKeyDown:Array<Bool>;
	
	/**
	 * Holds the current key index that is pressed.
	 */
	public var currentKeyDown:Int;
	
	/**
	 * Holds the flags of keys that are recently pressed.
	 */
	public var isKeyTriggered:Array<Bool>;
	
	/**
	 * Holds the flags of keys that are released.
	 */
	public var isKeyReleased:Array<Bool>;
	
	/**
	 * Holds the current key index that is released.
	 */
	public var currentKeyUp:Int;
	
	/**
	 * The clicked X coordinate of the mouse.
	 */
	public var mouseClickLocationX:Float;
	
	/**
	 * The clicked Y coordinate of the mouse.
	 */
	public var mouseClickLocationY:Float;
	
	/**
	 * The X coordinate of when the mouse button was released.
	 */
	public var mouseReleaseLocationX:Float;
	
	/**
	 * The Y coordinate of when the mouse button was released.
	 */
	public var mouseReleaseLocationY:Float;
	
	/**
	 * The current X coordinate of the mouse.
	 */
	public var mouseLocationX:Float;
	
	/**
	 * The current Y coordinate of the mouse.
	 */
	public var mouseLocationY:Float;
	
	/**
	 * The status of the primary mouse button which can be either true if held down or false when up.
	 */
	public var isMouseDown:Bool;
	
	/**
	 * True if the mouse has been clicked.
	 * This is only true for one update.
	 */
	public var isMouseClicked:Bool;
	
	/**
	 * True if the mouse has been released.
	 * This is only true for one update.
	 */
	public var isMouseReleased:Bool;
	
	/**
	 * The status of the shift key which can be either true if held down or false when up.
	 */
	public var isShiftDown:Bool;
	
	/**
	 * The status of the control key which can be either true if held down or false when up.
	 */
	public var isCtrlDown:Bool;
	
	/**
	 * If set to true, the mouse cursor will be a hand over a button.
	 */
	public var isMouseHandButton:Bool;
	
	/**
	 * If set to true, the mouse cursor will be a hand.
	 */
	public var isMouseHand:Bool;
	
	// If set to true, the mouse cursor will be the text input cursor.
	public var isMouseIBeam:Bool;
	
	/**
	 * If set to true, the mouse will be hidden.
	 */
	public var isMouseHidden:Bool;
	
	/**
	 * True if mouse is outside of the flash frame.
	 */
	public var isMouseOut:Bool;
	
	public function new() 
	{
		isKeyDown = [];
		isKeyTriggered = [];
		isKeyReleased = [];
		currentKeyDown = NEUTRAL_KEY_INDEX;
		currentKeyUp = NEUTRAL_KEY_INDEX;
		mouseClickLocationX = NEUTRAL_MOUSE_POSITION;
		mouseClickLocationY = NEUTRAL_MOUSE_POSITION;
		mouseReleaseLocationX = NEUTRAL_MOUSE_POSITION;
		mouseReleaseLocationY = NEUTRAL_MOUSE_POSITION;
		mouseLocationX = 0;
		mouseLocationY = 0;
		isMouseDown = false;
		isMouseClicked = false;
		isMouseReleased = false;
		isShiftDown = false;
		isCtrlDown = false;
		isMouseHandButton = false;
		isMouseHand = false;
		isMouseIBeam = false;
		isMouseHidden = false;
	}
}