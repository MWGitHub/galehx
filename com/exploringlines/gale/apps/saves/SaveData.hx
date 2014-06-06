/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.saves;
import flash.net.SharedObject;
import flash.utils.Dictionary;

/**
 * Holds the data to be saved.
 */
class SaveData 
{
	/**
	 * The saved data.
	 */
	private var data:SharedObject;
	
	/**
	 * The temporary data that is saved.
	 */
	private var dataTable:Dictionary;
	
	/**
	 * True if the data already exists, false otherwise.
	 */
	public var exists:Bool;

	/**
	 * Creates a new saved data or loads already existing saved data.
	 * @param	name		The name of the saved data.
	 * @example
	 * var save:SaveData = new SaveData("gale/gamename/savename", "/");
	 */
	public function new(name:String = "Default", path:String = "/") 
	{
		exists = false;
		data = SharedObject.getLocal(name, path);
		if (!Reflect.hasField(data.data, "exists")) {
			dataTable = new Dictionary();
			data.data.exists = true;
			save();
		} else {
			exists = true;
			dataTable = cast(data.data.dataTable, Dictionary);
		}
	}
	
	/**
	 * Sets a variable in the temporary data.
	 * @param	name		The name of the variable.
	 * @param	v			The value of the variable.
	 */
	public function setVariable(name:String, v:Dynamic):Void {
		untyped dataTable[name] = v;
	}
	
	/**
	 * Retrieves the variable from the temporary data.
	 * @param	name		The name of the variable.
	 * @return	If the variable exists then it will be returned, otherwise null.
	 */
	public function getVariable(name:String):Dynamic {
		if (!Reflect.hasField(dataTable, name)) {
			return null;
		}
		
		return untyped dataTable[name];
	}
	
	/**
	 * Saves the temporary data into the saved data.
	 */
	public function save():Void {
		data.data.dataTable = dataTable;
		data.flush();
	}
	
	/**
	 * Deletes the saved data but the temporary data will still remain.
	 */
	public function clear():Void {
		data.clear();
	}
	
	/**
	 * Deletes the temporary data.
	 * @return	The deleted temporary data.
	 */
	public function deleteTemporaryData():Dictionary {
		var dataCopy:Dictionary = dataTable;
		dataTable = new Dictionary();
		
		return dataCopy;
	}
	
	/**
	 * Returns the size of the data.
	 * @return The size of the data in kb.
	 */
	public function getSize():Float {
		return round2(data.size / 1024, 2);
	}
	
	public function serializeData():Dictionary {
		return dataTable;
	}
	
	/**
	 * Rounds a float with a set precision.
	 * @param	number		The number to round.
	 * @param	precision	The precision of the float.
	 * @return	The rounded number.
	 */
	private inline function round2( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}
}