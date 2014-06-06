/**
 * A state for the gale framework.
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.resourceloader.IResourceLoader;
import com.exploringlines.gale.core.resourceloader.ResourceLoader;
import com.exploringlines.gale.core.sound.ISoundPlayer;

/**
 * A state for the gale framework.
 */
interface IRootState 
{
	/**
	 * The name of the state.
	 * This is used when switching to another state.
	 */
	public var name:String;
	
	/**
	 * The name of the next state.
	 * Setting the state to anything other than null will signify that you want to change states.
	 */
	public var nextState:String;
	
	/**
	 * User input to be passed to the scene.
	 */
	private var inputData:InputData;
	
	/**
	 * Used to load bitmaps and cache bitmaps in the state to be passed to the scene.
	 */
	private var resourceLoader:IResourceLoader;
	
	/**
	 * Manages played sounds.
	 */
	private var soundPlayer:ISoundPlayer;
	
	/**
	 * Manages all nodes and entities.
	 */
	public var rootScene:RootScene;
	
	/**
	 * Runs every update.
	 * @param	deltaTime The time between updates.
	 * @return The list of entities that are to be displayed.
	 */
	public function update(deltaTime:Int):Array<Entity>;
	
	/**
	 * Called only when the state changes into this state.
	 */
	public function enter():Void;
	
	/**
	 * Called only when the state is changing to the next state.
	 */
	public function leave():Void;
}