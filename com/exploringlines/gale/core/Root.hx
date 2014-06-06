/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.apps.benchmark.Profiler;
import com.exploringlines.gale.core.input.IInputListener;
import com.exploringlines.gale.core.input.InputListener;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRenderer;
import com.exploringlines.gale.core.resourceloader.IResourceLoader;
import com.exploringlines.gale.core.sound.ISoundPlayer;
import com.exploringlines.gale.apps.mainloops.IMainLoop;
import flash.display.Stage;
import flash.events.Event;
import flash.Lib;

/**
 * The main loop of the application and creator of all display, sound, and resource modules.
 */
class Root 
{
	private var profiler:Profiler;
	private var isProfiled:Bool;
	
	private var renderer:IRenderer;
	
	private var mainLoop:IMainLoop;
	
	/**
	 * The cached resource retriever.
	 */
	public var resourceLoader:IResourceLoader;
	
	/**
	 * Plays sounds.
	 */
	public var soundPlayer:ISoundPlayer;
	
	/**
	 * The input of the user.
	 */
	public var inputListener:IInputListener;
	
	/**
	 * The current state and the state controller.
	 */
	private var stateController:RootStateController;
	
	private var lastUpdateEntities:Array<Entity>;
	
	private var stage:Stage;
	
	/**
	 * Function run after updating.
	 */
	public var updateCallback:Void->Void;
	
	/**
	 * Function run after drawing.
	 */
	public var drawUpdateCallback:Void->Void;
	
	/**
	 * Creates the game timer, renderer, resources, sound, and input.
	 * @param	updateTicksPerSecond	The number of updates per second.
	 * @param	displayTicksPerSecond	The number of renders per second.
	 * @param	maximumMissedUpdates	The maximum number of missed updates before skipping over.
	 * @param	keyPersistance			The amount of time a key stays triggered.
	 */
	public function new(mainLoop:IMainLoop, renderer:IRenderer, soundPlayer:ISoundPlayer, inputListener:IInputListener, resourceLoader:IResourceLoader, ?stage:Stage, isProfiled:Bool = false) {
		if (stage != null) {
			this.stage = stage;
		} else {
			this.stage = Lib.current.stage;
		}
		this.mainLoop = mainLoop;
		
		this.renderer = renderer;
		this.soundPlayer = soundPlayer;
		this.resourceLoader = resourceLoader;
		this.inputListener = inputListener;
		
		Globals.inputData = this.inputListener.inputData;
		Globals.resourceLoader = this.resourceLoader;
		Globals.soundPlayer = this.soundPlayer;
		Globals.renderer = this.renderer;
		Globals.stage = this.stage;
		
		this.isProfiled = isProfiled;
		if (isProfiled) {
			profiler = new Profiler(0xFFD222);
		}
	}
	
	/**
	 * Enables the framework.
	 * @param	initialState		The initial state the framework will be in.
	 * @param	stateController		The state controller used for switching states.
	 */
	public function enableFramework(initialState:IRootState, stateController:RootStateController):Void {
		this.stateController = stateController;
		stateController.currentState = initialState;
		mainLoop.enable();
		lastUpdateEntities = [];
		Globals.stage.addEventListener(Event.ENTER_FRAME, loopProgram);
	}
	
	/**
	 * Disables the framework.
	 */
	public function disableFramework():Void {
		Globals.stage.removeEventListener(Event.ENTER_FRAME, loopProgram);
	}
	
	// Run through state updates and display object updates.
	private function loopProgram(e:Event):Void {
		var startTime:Int = 0;
		if (isProfiled) {
			startTime = Lib.getTimer();
		}
		
		mainLoop.update();
		
		if (mainLoop.isUpdating) {
			for (i in 0...mainLoop.timesToUpdate) {
				update(mainLoop.updateStepSize);
			}
		}
		
		if (mainLoop.isRendering) {
			for (i in 0...mainLoop.timesToRender) {
				updateDisplay(lastUpdateEntities, mainLoop.interpolation, mainLoop.displayStepSize);
			}
		}
		
		if (isProfiled) {
			profiler.update(startTime, Lib.getTimer());
			//trace(1 / ((Lib.getTimer() - startTime) / 1000));
		}
	}
	
	/**
	 * Updates the current state.
	 * @param	deltaTime	The time in milliseconds since the last update.
	 */
	private inline function update(deltaTime:Int):Void {
		var startTime:Int = 0;
		if (isProfiled) {
			startTime = Lib.getTimer();
		}
		
		lastUpdateEntities = stateController.update(deltaTime);
		renderer.camera = stateController.getRootScene().camera;
		
		inputListener.update(deltaTime);
		inputListener.checkCursor();
		inputListener.resetModifiers();
		inputListener.resetMouseClick();
		
		if (isProfiled) {
			profiler.updateLogicFps(startTime, Lib.getTimer());
		}
		
		if (updateCallback != null) {
			updateCallback();
		}
	}
	
	/**
	 * Updates the renderer.
	 * @param	entities	The entities to be rendered.
	 * @param	deltaTime	The time in milliseconds since the last update.
	 */
	private inline function updateDisplay(entities:Array<Entity> , deltaTime:Int, deltaTimeAnimation:Int):Void {
		var startTime:Int = 0;
		if (isProfiled) {
			startTime = Lib.getTimer();
		}
		
		renderer.clearCanvases();
		renderer.renderEntitiesToCanvas(entities, deltaTime, deltaTimeAnimation);
		
		if (isProfiled) {
			profiler.updateDisplayFps(startTime, Lib.getTimer());
		}
		
		if (drawUpdateCallback != null) {
			drawUpdateCallback();
		}
	}
}