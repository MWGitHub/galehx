/**
 * TODO: Decouple from input.
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRenderable;
import com.exploringlines.gale.core.resourceloader.CachedBitmapData;
import flash.geom.Rectangle;

/**
 * Tests if the mouse is inside a rectangle.
 */
class Button extends Node
{
	/**
	 * A custom ID for the button.
	 */
	public var id:Int;
	
	private var inputData:InputData;
	
	/**
	 * The original rectangle of the button before any transformations take place.
	 */
	private var originalRectangle:Rectangle;
	
	/**
	 * The rectangle of the button.
	 */
	public var rectangle(default, setRectangle):Rectangle;
	
	/**
	 * If true, the mouse will display a hand icon when hovered.
	 */
	public var isHoverable:Bool;
	
	/**
	 * If true, the mouse is over the button.
	 */
	public var isMouseHovering(default, null):Bool;
	
	/**
	 * If true, the button has been clicked and released.
	 * Returns to false on the next update after retrieval.
	 */
	public var isClicked(getIsClicked, null):Bool;
	
	/**
	 * When true the button is centered with the given rectangle.
	 */
	public var isCentered:Bool;
	
	/**
	 * If true, the click will only be true on first isClicked check until the next update.
	 */
	public var isOneShot:Bool;
	
	/**
	 * The states of the button.
	 */
	private var isPositiveEdgeClicked:Bool;
	private var wasMouseHovering:Bool;
	
	/**
	 * The callback function that is run when the button is clicked.
	 */
	public var callbackClick:Button->Void;
	
	/**
	 * The callback function that is run when the mouse initially hovers over the button.
	 */
	public var callbackInitialHover:Button->Void;
	
	/**
	 * The callback function that is run every update where the mouse is hovering over the button.
	 */
	public var callbackHover:Button->Void;
	
	/**
	 * The callback function that is run when the mouse moves off the button.
	 */
	public var callbackHoverOut:Button->Void;
	
	/**
	 * The callback function that is run when the button is being held down.
	 */
	public var callbackHold:Button->Void;
	
	/**
	 * The callback function that is run when the button is clicked and the mouse releases on the button.
	 */
	public var callbackRelease:Button->Void;
	
	/**
	 * The callback function that is run when the button is released with the mouse outside the button.
	 */
	public var callbackReleaseOutside:Button->Void;
	
	/**
	 * The callback function that is run when the button is released anywhere.
	 */
	public var callbackReleaseAny:Button->Void;

	/**
	 * Creates a new button node.
	 * @param	?position		The position of the button.
	 * @param	?speed			The speed of the button.
	 * @param	rectangle		The collision rectangle of the button.
	 * @param	inputData		The inputData.
	 */
	public function new(inputData:InputData, ?position:Vector2, ?speed:Vector2) 
	{
		super(position, speed);
		
		this.inputData = inputData;
		
		isCentered = true;
		isHoverable = true;
		id = 0;
		isOneShot = true;
		
		wasMouseHovering = false;
		isPositiveEdgeClicked = false;
	}
	
	override public function updatePreCache(deltaTime:Int = 0):Void {
		super.updatePreCache(deltaTime);
		
		// Update the rectangle size if the scale is changed.
		if (isCacheUpdated) {
			rectangle.width = originalRectangle.width * scaleX * cameraScaleX;
			rectangle.height = originalRectangle.height * scaleX * cameraScaleY;
		}
		
		// Update the rectangle position.
		if (!isCentered) {
			rectangle.x = derivedPosition.x * cameraScaleX;
			rectangle.y = derivedPosition.y * cameraScaleX;
		} else {
			rectangle.x = (derivedPosition.x * cameraScaleX) - rectangle.width / 2;
			rectangle.y = (derivedPosition.y * cameraScaleY) - rectangle.height / 2;
		}
	}
	
	/**
	 * Updates the button and checks if the button is being hovered or clicked on the negative edge.
	 * @param	deltaTime		The time passed in milliseconds.
	 */
	override public function update(deltaTime:Int = 0):Void {
		super.update(deltaTime);
		
		// Reset states.
		isMouseHovering = false;
		isClicked = false;
		
		// On mouse hover.
		if (isCoordinateInRectangle(inputData.mouseLocationX, inputData.mouseLocationY)) {
			if (!wasMouseHovering && callbackInitialHover != null) {
				callbackInitialHover(this);
			}
			
			isMouseHovering = true;
			if (isHoverable) {
				inputData.isMouseHandButton = true;
				if (callbackHover != null) {
					callbackHover(this);
				}
			}
		}
		if (!isMouseHovering && wasMouseHovering && callbackHoverOut != null) {
			callbackHoverOut(this);
		}
		wasMouseHovering = isMouseHovering;
		
		// On mouse initial click.
		if (isCoordinateInRectangle(inputData.mouseClickLocationX, inputData.mouseClickLocationY)) {
			isPositiveEdgeClicked = true;
			if (callbackClick != null) {
				callbackClick(this);
			}
		}
		
		// On mouse held when the button has been clicked.
		if (isPositiveEdgeClicked && callbackHold != null) {
			callbackHold(this);
		}
		
		// On mouse release after clicked in the button.
		if (isCoordinateInRectangle(inputData.mouseReleaseLocationX, inputData.mouseReleaseLocationY) && isPositiveEdgeClicked) {
			isClicked = true;
			if (callbackRelease != null) {
				callbackRelease(this);
			}
		}
		
		// On mouse released anywhere.
		if (inputData.isMouseReleased) {
			// On mouse released outside of the button while being clicked.
			if (isPositiveEdgeClicked && !isClicked && callbackReleaseOutside != null) {
				callbackReleaseOutside(this);
			}
			if (callbackReleaseAny != null) {
				callbackReleaseAny(this);
			}
			isPositiveEdgeClicked = false;
		}
	}
	
	/**
	 * Attaches the object normally and sets the rectangle of the button on the first object.
	 * @param	object	The object to attach.
	 * @return	The object to attach.
	 */
	override public function attachObject(object:IEntity):IEntity 
	{
		super.attachObject(object);
		if (rectangle == null) {
			this.rectangle = new Rectangle( -object.rectangle.width / 2, -object.rectangle.height / 2, object.rectangle.width, object.rectangle.height);
		}
		
		return object;
	}
	
	/**
	 * If the button is clicked, the click is reset to false.
	 * @return		The state of the button click.
	 */
	private inline function getIsClicked():Bool {
		var wasClicked:Bool = isClicked;
		if (isClicked && isOneShot) {
			isClicked = false;
		}
		
		return wasClicked;
	}
	
	/**
	 * Tests if a coordinate is inside the button rectangle.
	 * @param	x		The x coordinate.
	 * @param	y		The y coordinate.
	 * @return	Returns true if the coordinates are inside the rectangle.
	 */
	private inline function isCoordinateInRectangle(x:Float, y:Float):Bool {
		return (x >= rectangle.x && x <= rectangle.right) && (y >= rectangle.y && y <= rectangle.bottom);
	}
	
	private inline function setRectangle(v:Rectangle):Rectangle {
		originalRectangle = v;
		rectangle = originalRectangle.clone();
		
		return rectangle;
	}
}