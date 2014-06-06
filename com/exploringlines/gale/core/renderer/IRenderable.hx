/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import com.exploringlines.gale.apps.math.geom.Vector2;

/**
 * Any object that needs to be displayed using the renderer will need to implement this.
 */
interface IRenderable 
{
	public var derivedPosition:Vector2;
	public var derivedSpeed:Vector2;
	public var isRemoved(default, setIsRemoved):Bool;
	public var isLocked(default, setIsLocked):Bool;
	public var isVisible(default, setIsVisible):Bool;
	public var rotation(default, setRotation):Dynamic;
	public var alpha(default, setAlpha):Dynamic;
	public var scaleX(default, setScaleX):Dynamic;
	public var scaleY(default, setScaleY):Dynamic;
	public var flipHorizontal(default, setFlipHorizontal):Dynamic;
	public var flipVertical(default, setFlipVertical):Dynamic;
	public var redOffset(default, setRedOffset):Dynamic;
	public var greenOffset(default, setGreenOffset):Dynamic;
	public var blueOffset(default, setBlueOffset):Dynamic;
}