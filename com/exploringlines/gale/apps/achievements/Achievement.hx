/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.achievements;

/**
 * An achievement's data.
 */
class Achievement 
{
	// 
	public static inline var TYPE_GTE:Int = 0;
	public static inline var TYPE_GT:Int = 1;
	public static inline var TYPE_EQUALS:Int = 2;
	public static inline var TYPE_LT:Int = 3;
	public static inline var TYPE_LTE:Int = 4;
	
	// The name of the achievement
	public var name:String;
	
	// The type of ording the achievement will have
	private var type:Int;
	
	// The value required for the achievement to be unlocked
	private var value:Float;
	
	// The key used for the achievement image.
	public var imageKey:String;
	
	// The description of the achievement
	public var description:String;
	
	// True if the achievement is completed
	public var isComplete:Bool;

	/**
	 * Creates a new achievement.
	 * @param	name			The name of the achievement.
	 * @param	type			The type of achievement.
	 * @param	value			The value needed to obtain the achievement.
	 * @param	imageKey		The image used for the achievement.
	 * @param	description		The description of the achievement.
	 */
	public function new(name:String, type:Int, value:Float, imageKey:String, description:String = "") 
	{
		this.name = name;
		this.type = type;
		this.value = value;
		this.imageKey = imageKey;
		this.description = description;
		
		isComplete = false;
	}
	
	/**
	 * Checks if the achievement can be obtained from the amount given.
	 * @param	amount	The value to check with.
	 * @return	True if it can be obtained, false otherwise.
	 */
	public function checkIfObtained(amount:Float):Bool {
		var isObtained:Bool = false;
		
		if (type == TYPE_LT && amount < value) {
			isObtained = true;
		} else if (type == TYPE_LTE && amount <= value) {
			isObtained = true;
		} else if (type == TYPE_GT && amount > value) {
			isObtained = true;
		} else if (type == TYPE_GTE && amount >= value) {
			isObtained = true;
		} else if (type == TYPE_EQUALS && amount == value) {
			isObtained = true;
		}
		
		return isObtained;
	}
	
	/**
	 * Checks if the achievement has been obtained.
	 * @param	amount			The value to check with.
	 * @return	If true, the achievement is obtained.
	 */
	public function checkIfJustObtained(amount:Float):Bool {
		var isObtained:Bool = false;
		
		if (!isComplete) {
			isObtained = checkIfObtained(amount);
		}
		
		if (isObtained) {
			isComplete = true;
		}
		
		return isObtained;
	}
}