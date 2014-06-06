/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.Globals;

class Camera 
{
	/**
	 * The center point of the camera.
	 */
	public var position:Vector2;
	
	public var width:Float;
	public var height:Float;
	
	public var scaleX(default, setScaleX):Float;
	public var scaleY(default, setScaleY):Float;
	
	public var rotation(default, setRotation):Float;
	
	public var isCameraUpdated:Bool;

	public function new() 
	{
		width = Globals.stage.stageWidth;
		height = Globals.stage.stageHeight;
		
		position = new Vector2(Globals.stage.stageWidth / 2, Globals.stage.stageHeight / 2);
		
		scaleX = 1;
		scaleY = 1;
		
		rotation = 0;
		
		isCameraUpdated = true;
	}
	
	/**
	 * Set the scale in the X axis while making sure the value is between 0.01 and infinity.
	 * @param	v		The scale value.
	 * @return	The scale value.
	 */
	private inline function setScaleX(v:Float):Float {
		if (v != scaleX) {
			if (v <= 0) {
				scaleX = 0.01;
			} else {
				scaleX = v;
			}
			scaleX = GaleMath.toFixed(scaleX, 100);
			
			isCameraUpdated = true;
		}
		
		return v;
	}
	
	/**
	 * Set the scale in the X axis while making sure the value is between 0.01 and infinity.
	 * @param	v		The scale value.
	 * @return	The scale value.
	 */
	private inline function setScaleY(v:Float):Float {
		if (v != scaleY) {
			if (v <= 0) {
				scaleY = 0.01;
			} else {
				scaleY = v;
			}
			scaleY = GaleMath.toFixed(scaleY, 100);
			
			isCameraUpdated = true;
		}
		
		return v;
	}
	
	/**
	 * Sets the rotation of the node in degrees while ensuring the value is between -180 and 180.
	 * @param	v	The rotation of the node in degrees
	 * @return	The rotation of the node in degrees.
	 */
	private inline function setRotation(v:Float):Float {
		var degrees:Float = v;
		if (v < -180) {
			degrees = v + Math.ceil(v / -360) * 360;
		} else if (v > 180) {
			degrees = v - Math.ceil(v / 360) * 360;
		} else {
			degrees = v;
		}
		rotation = degrees;
		
		isCameraUpdated = true;
		
		return v;
	}
	
}