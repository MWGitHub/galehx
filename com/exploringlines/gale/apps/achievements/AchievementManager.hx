/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.achievements;

import com.exploringlines.gale.apps.datastructures.Map;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.core.RootScene;

class AchievementManager 
{
	// The rootScene to add entities to
	private var rootScene:RootScene;
	// The input of the framework
	private var inputData:InputData;
	// The layer to add within the rootScene
	private var layer:Int;
	
	// The achievements
	private var achievements:Map<String, Achievement>;
	
	// The display that pops up when an achievement is unlocked.
	private var unlockDisplay:AchievementUnlockDisplay;
	// The achievements queue for when multiple achievements are earned while still animating.
	private var queue:Array<Achievement>;
	
	// The panel to browse all achievements.
	private var achievementPanel:AchievementPanel;

	public function new() 
	{
		achievements = new Map<String, Achievement>();
		queue = [];
	}
	
	/**
	 * Loads achievements from a data file along with the style.
	 * @param	data	The data to load.
	 */
	public function loadAchievements(data:Dynamic):Void {
		var rawAchievements:Array<Dynamic> = data.achievements;
		var type:Int;
		for (i in 0...rawAchievements.length) {
			switch (rawAchievements[i].type) {
				case "gt":
					type = Achievement.TYPE_GT;
				case "gte":
					type = Achievement.TYPE_GTE;
				case "equals":
					type = Achievement.TYPE_EQUALS;
				case "lte":
					type = Achievement.TYPE_LTE;
				case "lt":
					type = Achievement.TYPE_LT;
				default:
					type = 0;
			}
			
			var achievement:Achievement = new Achievement(rawAchievements[i].name, type, rawAchievements[i].value, rawAchievements[i].image, rawAchievements[i].description);
			achievements.set(achievement.name, achievement);
		}
		
		AchievementUnlockDisplay.loadStyle(data.style);
		AchievementUnlockItem.loadStyle(data.pageStyleItem);
		AchievementPanel.loadStyle(data.pageStyle);
	}
	
	/**
	 * Retrieves an achievement based on the name.
	 * @return	The achievement to retrieve.
	 */
	public function getAchievement(key:String):Achievement {
		return achievements.get(key);
	}
	
	/**
	 * Sets the value for the achievement and choose if the achievement display should be shown.
	 * @param	key				The name of the achievement.
	 * @param	value			The value to check the achievement with.
	 * @param	showDisplay		If true, the display for the achievement will be shown.
	 */
	public function setAchievementValue(key:String, value:Float, showDisplay:Bool):Void {
		var achievement:Achievement = achievements.get(key);
		if (achievement != null && achievement.checkIfJustObtained(value)) {
			if (showDisplay) {
				showAchievementUnlocked(achievement);
			}
		}
	}
	
	/**
	 * Shows a single achievement being unlocked if possible, otherwise it adds to the queue.
	 * @param	achievement		The achievement to show.
	 */
	private function showAchievementUnlocked(achievement:Achievement):Void {
		if (unlockDisplay != null && !unlockDisplay.isRemoved) {
			queue.push(achievement);
		} else {
			unlockDisplay = new AchievementUnlockDisplay(rootScene, layer, achievement);
		}
	}
	
	/**
	 * Show the achievement panel.
	 */
	public function showAchievementWindow():Void {
		achievementPanel = new AchievementPanel(rootScene, inputData, layer);
	}
	
	/**
	 * Hide the achievement panel.
	 */
	public function hideAchievementWindow():Void {
		if (achievementPanel != null) {
			achievementPanel.isRemoved = true;
			achievementPanel.isVisible = false;
		}
	}
	
	/**
	 * Updates the achievement displays.
	 * @param	deltaTime	Time passed in milliseconds.
	 */
	public function update(deltaTime:Int):Void {
		if (unlockDisplay != null) {
			if (!unlockDisplay.isRemoved) {
				unlockDisplay.update(deltaTime);
			}
			
			if (queue.length > 0) {
				if (unlockDisplay.isRemoved) {
					showAchievementUnlocked(queue.pop());
				}
			}
		}
		if (achievementPanel != null) {
			achievementPanel.update(deltaTime);
		}
	}
	
	/**
	 * Sets up the achievement manager for the scene.
	 * @param	rootScene	The current rootScene being displayed.
	 * @param	layer		The layer to be displayed on.
	 */
	public function enter(rootScene:RootScene, inputData:InputData, layer:Int):Void {
		this.rootScene = rootScene;
		this.inputData = inputData;
		this.layer = layer;
	}
	
	/**
	 * Cleans up the achievement states and removes all active panels.
	 */
	public function leave():Void {
		rootScene = null;
		
		if (unlockDisplay != null) {
			unlockDisplay.isRemoved = true;
			unlockDisplay = null;
		}
	}
}