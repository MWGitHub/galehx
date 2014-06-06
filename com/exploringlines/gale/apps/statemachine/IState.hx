/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.statemachine;

/**
 * A state in a state machine.
 */
interface IState 
{
	/**
	 * The name of the state.
	 */
	public var name:String;
	
	/**
	 * The next state to go into.
	 */
	public var nextState:String;
	
	/**
	 * The update function.
	 */
	function update():Void;
	
	/**
	 * The function that is run when entering the state.
	 */
	function enter():Void;
	
	/**
	 * The function that is run when leaving the state.
	 */
	function leave():Void;
}