/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.core.renderer.IRenderer;
import com.exploringlines.gale.core.resourceloader.IResourceLoader;
import com.exploringlines.gale.core.resourceloader.ResourceLoader;
import com.exploringlines.gale.core.sound.ISoundPlayer;
import flash.display.Stage;

class Globals
{
	public static var rootScene:RootScene;
	public static var inputData:InputData;
	public static var resourceLoader:IResourceLoader;
	public static var soundPlayer:ISoundPlayer;
	public static var renderer:IRenderer;
	public static var stage:Stage;
}