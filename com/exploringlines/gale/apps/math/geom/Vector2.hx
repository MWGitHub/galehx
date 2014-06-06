/**
 * A 2D vector.
 * @author MW
 */

package com.exploringlines.gale.apps.math.geom;

/**
 * A two dimensional vector.
 */
class Vector2 
{
	// Tolerance of the x and y values before setting to 0.
	private static inline var tolerance:Float = 0.00000001;
	
	public static var zeroVector:Vector2 = new Vector2();
	
	/**
	 * The x magnitude of the vector.
	 */
	public var x:Float;
	
	/**
	 * The y magnitude of the vector.
	 */
	public var y:Float;
	
	/**
	 * Creates a new two dimensional vector.
	 * @param	x		The x magnitude of the vector.
	 * @param	y		The y magnitude of the vector.
	 * @param	w		The angle of the vector.
	 */
	public function new(x:Float = 0, y:Float = 0) 
	{
		this.x = x;
		this.y = y;
	}
	
	/**
	 * Checks if the vector is zero.
	 * @return	True if zero, false otherwise.
	 */
	public inline function isZero():Bool {
		return (x == 0 && y == 0);
	}
	
	/**
	 * Checks if the vectors are equal.
	 * @param	vector2	Vector to check against.
	 * @return	True if equal, false otherwise.
	 */
	public inline function equals(vector2:Vector2):Bool {
		return (x == vector2.x && y == vector2.y);
	}
	
	/**
	 * Checks if the vector length is 1.
	 * @return	True if normalized, false otherwise.
	 */
	public inline function isNormalized():Bool {
		return getLength() == 1;
	}
	
	/**
	 * Calculates and returns the length of the vector.
	 * @return	Length of the vector.
	 */
	public inline function getLength():Float {
		return Math.sqrt(x * x + y * y);
	}
	
	/**
	 * Sets the length of the vector.
	 * @param	length	Desired length of the vector.
	 */
	public inline function setLength(length:Float):Void {
		var angle:Float = getAngle();
		x = Math.cos(angle) * length;
		y = Math.sin(angle) * length;
		if (Math.abs(x) < Vector2.tolerance)
			x = 0;
		if (Math.abs(y) < Vector2.tolerance)
			y = 0;
	}
	
	/**
	 * Calculates and returns the angle.
	 * @return	Angle of the vector.
	 */
	public inline function getAngle():Float {
		return Math.atan2(y, x);
	}
	
	/**
	 * Sets the angle of the vector.
	 * @param	angle	Angle in radians.
	 */
	public inline function setAngle(angle:Float):Void {
		var length:Float = getLength();
		x = Math.cos(angle) * length;
		y = Math.sin(angle) * length;
		
		if (Math.abs(x) < Vector2.tolerance)
			x = 0;
		if (Math.abs(y) < Vector2.tolerance)
			y = 0;
	}
	
	/**
	 * Normalizes the vector's length to 1.
	 */
	public function normalize():Vector2 {
		// In case the vector has no length.
		if (getLength() == 0) {
			x = 1;
			return this;
		}
		var length:Float = getLength();
		x /= length;
		y /= length;
		return this;
	}
	
	/**
	 * Adds two vectors together and returns the result.
	 * @param	vector The vector to be added.
	 * @return The sum of the vectors.
	 */
	public inline function add(vector:Vector2):Vector2 {
		x += vector.x;
		y += vector.y;
		
		return this;
	}
	
	/**
	 * Subtracts two vectors together and returns the result.
	 * @param	vector The vector to be subtracted.
	 * @return The sum of the vectors.
	 */
	public inline function subtract(vector:Vector2):Vector2 {
		x -= vector.x;
		y -= vector.y;
		
		return this;
	}
	
	/**
	 * Multiplies a scalar to the vector and returns the result.
	 * @param	scalar The value to multiply the vector by.
	 * @return The result.
	 */
	public inline function multiply(scalar:Float):Vector2 {
		x *= scalar;
		y *= scalar;
		
		return this;
	}
	
	/**
	 * Divides the vector's x and y.
	 * @param	scalar	Value to divice the vector by.
	 * @return	This vector.
	 */
	public inline function divide(scalar:Float):Vector2 {
		x /= scalar;
		y /= scalar;
		
		return this;
	}
	
	/**
	 * Calculates the dot product with another vector.
	 * @param	vector	Vector to calculate with.
	 * @return	Dot product of the two vectors.
	 */
	public inline function dotProduct(vector:Vector2):Float {
		return x * vector.x + y * vector.y;
	}
	
	/**
	 * Calculates the cross product with another vector.
	 * @param	vector	Vector to calculate with.
	 * @return	Cross product of the two vectors.
	 */
	public inline function crossProduct(vector:Vector2):Float {
		return x * vector.y - y * vector.x;
	}
	
	/**
	 * Sets the length under the given value.
	 * @param	max	Maximum length the vector can be.
	 * @return	This vector.
	 */
	public inline function truncate(max:Float):Vector2 {
		setLength(Math.min(max, getLength()));
		return this;
	}
	
	/**
	 * Copies the current vector and returns a new one.
	 * @return The clone of the vector.
	 */
	public inline function clone():Vector2 {
		var result:Vector2 = new Vector2();
		result.x = this.x;
		result.y = this.y;
		
		return result;
	}
	
	/**
	 * Outputs the position of the vector as a string.
	 * @return	The position as a string.
	 */
	public inline function toString():String {
		var output:String = '{"x" : ' + Std.string(x) + ', "y" : ' + Std.string(y) + "}";
		
		return output;
	}
}