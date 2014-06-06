/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRenderer;
import com.exploringlines.gale.core.resourceloader.IResourceLoader;

import com.exploringlines.gale.core.sound.ISoundPlayer;

class RootState implements IRootState
{
	public var name:String;
	public var nextState:String;
	private var inputData:InputData;
	private var resourceLoader:IResourceLoader;
	private var renderer:IRenderer;
	private var soundPlayer:ISoundPlayer;
	public var rootScene:RootScene;
	
	public function new(name:String, inputData:InputData, resourceLoader:IResourceLoader, renderer:IRenderer, soundPlayer:ISoundPlayer) {
		this.name = name;
		this.inputData = inputData;
		this.resourceLoader = resourceLoader;
		this.renderer = renderer;
		this.soundPlayer = soundPlayer;
		
		rootScene = new RootScene(resourceLoader, renderer, soundPlayer);
	}
	
	public function update(deltaTime:Int):Array<Entity> {
		return rootScene.flattenedEntityArray;
	}
	
	public function enter():Void {
		
	}
	
	public function leave():Void {
		
	}
}