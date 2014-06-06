/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.math.geom;

/**
 * Deprecated
 */
class Vector3 
{
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;
	
	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0) 
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public inline function add(vector:Vector3):Vector3 {
		x += vector.x;
		y += vector.y;
		z += vector.z;
		
		return this;
	}
	
	public inline function subtract(vector:Vector3):Vector3 {
		x -= vector.x;
		y -= vector.y;
		z -= vector.z;
		
		return this;
	}
	
	public inline function multiply(scalar:Float):Vector3 {
		x *= scalar;
		y *= scalar;
		z *= scalar;
		
		return this;
	}
}