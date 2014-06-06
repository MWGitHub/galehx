/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.achievements;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.Globals;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.core.Node;
import com.exploringlines.gale.core.RootScene;

class AchievementPanel extends Node
{
	private var rootScene:RootScene;
	private var inputData:InputData;
	
	// Styling data
	private static var panelKey:String;

	public function new(rootScene:RootScene, inputData:InputData, layer:Int) 
	{
		super(new Vector2(Globals.stage.stageWidth / 2, Globals.stage.stageHeight / 2));
		this.rootScene = rootScene;
		this.inputData = inputData;
		
		attachObject(rootScene.createEntity(panelKey, layer));
	}
	
	override public function update(deltaTime:Int = 0):Void 
	{
		super.update(deltaTime);
	}
	
	/**
	 * Loads the images and style of the achievement display.
	 */
	public static function loadStyle(data:Dynamic):Void {
		panelKey = data.panelImage;
	}
}