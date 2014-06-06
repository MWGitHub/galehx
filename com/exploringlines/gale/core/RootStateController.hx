/**
 * Controls root states added and determines if a state changes.
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;

class RootStateController
{
	private var states:Hash<IRootState>;
	
	/**
	 * The current state of the controller.
	 */
	public var currentState(default, setCurrentState):IRootState;

	public function new() 
	{
		states = new Hash<IRootState>();
	}
	
	/**
	 * Updates the current state and returns a list of renderable objects.
	 * @param	deltaTime The time that passed between updates.
	 * @return The list of renderable objects.
	 */
	public inline function update(deltaTime:Int):Array<Entity> {
		checkState();
		return currentState.update(deltaTime);
	}
	
	/**
	 * Checks if the state changed.
	 */
	public inline function checkState():Void {
		if (currentState.nextState != null) {
			if (states.exists(currentState.nextState)) {
				var nextState:IRootState = states.get(currentState.nextState);
				currentState.leave();
				currentState.nextState = null;
				currentState = nextState;
				Globals.rootScene = getRootScene();
			} else {
				var msg:String = "Trying to switch to the state \"" + currentState.nextState + "\" but it does not exist.";
				trace("Error occurred: " + msg);
				currentState.nextState = null;
			}
		}
	}
	
	/**
	 * Add a state to the allowed states.
	 * @param	state The state to be added.
	 */
	public function addState(state:IRootState):Void {
		states.set(state.name, state);
	}
	
	/**
	 * Remove a state from the allowed states.
	 * @param	state The state to be removed.
	 * @return The removed state.
	 */
	public function removeState(state:IRootState):IRootState {
		states.remove(state.name);
		return state;
	}
	
	/**
	 * Retrieves the scene from the state.
	 * @return
	 */
	public inline function getRootScene():RootScene {
		return currentState.rootScene;
	}
	
	/**
	 * Sets the current state and enters it.
	 * @param	state	The state to be entered.
	 */
	private function setCurrentState(state:IRootState) {
		currentState = state;
		Globals.rootScene = currentState.rootScene;
		currentState.enter();
		
		return state;
	}
}