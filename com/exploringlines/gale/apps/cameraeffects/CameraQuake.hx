/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.cameraeffects;
import com.exploringlines.gale.apps.math.GaleMath;
import com.exploringlines.gale.apps.math.Random;
import com.exploringlines.gale.apps.timers.CountdownTimer;
import com.exploringlines.gale.apps.timers.PeriodicTimer;
import com.exploringlines.gale.core.renderer.Camera;

/**
 * Shakes the camera.
 */
class CameraQuake {
	private var camera:Camera;
	private var duration:CountdownTimer;
	private var frequency:PeriodicTimer;
	private var lastXoffset:Float;
	private var lastYoffset:Float;
	private var magX:Float;
	private var magY:Float;
	
	private var isActive:Bool;

	public function new() {
		isActive = false;
		duration = new CountdownTimer(0);
		frequency = new PeriodicTimer(0, true);
	}
	
	/**
	 * Apply a quake effect to the camera.
	 * @param	camera		The camera to have quake applied.
	 * @param	duration	The duration of the quake.
	 * @param	magnitudeX	The amount the X direction can shake on both sides.
	 * @param	magnitudeY	The amount the Y direction can shake on both sides.
	 * @param	frequency	The time between each shake.
	 */
	public function applyEffect(camera:Camera, duration:Int, magnitudeX:Float, magnitudeY:Float, frequency:Int = 0):Void {
		if (!isActive) {
			this.camera = camera;
			this.duration.period = duration;
			this.duration.reset();
			this.magX = magnitudeX;
			this.magY = magnitudeY;
			this.frequency.period = frequency;
			this.frequency.counter = frequency;
			
			lastXoffset = 0;
			lastYoffset = 0;
			
			isActive = true;
		} else {
			this.duration.period = duration;
			this.duration.reset();
			this.magX = magnitudeX;
			this.magY = magnitudeY;
			this.frequency.period = frequency;
			this.frequency.counter = frequency;
			this.frequency.reset();
		}
	}
	
	/**
	 * Updates the quake effect.
	 * @param	deltaTime	The time step to update by.
	 */
	public function update(deltaTime:Int):Void {
		if (isActive) {
			duration.update(deltaTime);
			if (duration.isReady) {
				isActive = false;
				camera.position.x -= lastXoffset;
				camera.position.y -= lastYoffset;
			} else {
				frequency.update(deltaTime);
				if (frequency.isReady) {
					camera.position.x -= lastXoffset;
					camera.position.y -= lastYoffset;
				
					lastXoffset = Random.range( -magX, magX);
					lastYoffset = Random.range( -magY, magY);
				
					camera.position.x += lastXoffset;
					camera.position.y += lastYoffset;
				}
			}
		}
	}
}