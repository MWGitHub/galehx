/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.commonstates.credits;
import com.exploringlines.gale.apps.gui.widgets.buttons.TextButton;
import com.exploringlines.gale.apps.stateeffects.StateEffectFade;
import com.exploringlines.gale.core.Globals;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.renderer.IRenderer;
import com.exploringlines.gale.core.resourceloader.IResourceLoader;
import com.exploringlines.gale.core.sound.ISoundPlayer;
import com.exploringlines.gale.apps.text.Text;
import com.exploringlines.gale.core.Button;
import com.exploringlines.gale.core.Node;
import com.exploringlines.gale.core.RootState;
import flash.geom.Point;
import flash.Lib;
import haxe.FastList;
import json.JSON;

/**
 * A state that displays credits from a JSON file.
 */
class CreditsState extends RootState
{
	private var font:String;
	private var creditsLayers:CreditsLayers;
	private var returnState:String;
	private var returnButton:TextButton;
	
	private var background:Node;
	private var credits:Dynamic;
	private var text:FastList<Node>;
	
	private var fade:StateEffectFade;

	/**
	 * Displays scrolling credits on the screen and returns to the returnState once finished.
	 * @param	name			The name of the state.
	 * @param	returnState		The state to return to when complete.
	 * @param	font			The font of the credits.
	 * @param	credits			The JSON file or data containing the credits.
	 */
	public function new(name:String, inputData:InputData, resourceLoader:IResourceLoader, renderer:IRenderer, soundPlayer:ISoundPlayer, returnState:String, font:String, credits:Dynamic) 
	{
		super(name, inputData, resourceLoader, renderer, soundPlayer);
		
		this.returnState = returnState;
		this.font = font;
		
		creditsLayers = new CreditsLayers();
		
		this.credits = JSON.decode(credits);
		fade = new StateEffectFade(this);
	}
	
	override public function enter():Void 
	{
		rootScene.reset();
		
		// Create the background shades on the top and bottom.
		background = new Node(new Vector2(Globals.stage.stageWidth / 2, Globals.stage.stageHeight / 2));
		var backgroundWidth:Float = rootScene.getBitmapData("CreditsUpperShadow").rect.width;
		var backgroundOffset:Float = rootScene.getBitmapData("CreditsUpperShadow").rect.height / 2;
		var numberOfShades:Int = Math.ceil(Globals.stage.stageWidth / backgroundWidth);
		for (i in 0...numberOfShades) {
			background.attachObject(rootScene.createEntity("CreditsUpperShadow", creditsLayers.shades, new Point(-Globals.stage.stageWidth / 2 + backgroundWidth / 2 + backgroundWidth * i, -Globals.stage.stageHeight / 2 + backgroundOffset - 3)));
			background.attachObject(rootScene.createEntity("CreditsLowerShadow", creditsLayers.shades, new Point(-Globals.stage.stageWidth / 2 + backgroundWidth / 2 + backgroundWidth * i, Globals.stage.stageHeight / 2 - backgroundOffset + 3)));
		}
		
		// Create the menu button using the user specified font.
		var theme:TextButtonTheme = { font : font, fontSize : 20, hasGlow : false, glowColor : 0, glowOffset : 0.0,
									idleColor : 0xFFFFFF, hoverColor : 0xFFF0C4, align : Align.CENTER, isCentered : true };
		returnButton = new TextButton(rootScene, inputData, creditsLayers.buttons, 0, new Vector2(), "Menu", theme);
		returnButton.position.x = Globals.stage.stageWidth - returnButton.rectangle.width / 2 - 5;
		returnButton.position.y = returnButton.rectangle.height / 2 + 5;
		returnButton.callbackRelease = onMenuClick;
		
		// Create all the text for the credits.
		text = new FastList<Node>();
		var y:Float = Globals.stage.stageHeight - background.entities.head.elt.rectangle.height / 2;
		var moveSpeed:Float = 35;
		var headColor:UInt = 0xFFF0C4;
		var headSize:Int = 18;
		var nameColor:UInt = 0xFFFFFF;
		var nameSize:Int = 14;
		var textDisplay:Text;
		for (i in 0...credits.credits.length) {
			var title:Node = new Node(new Vector2(Globals.stage.stageWidth / 2, y), new Vector2(0, -moveSpeed));
			textDisplay = rootScene.createText(creditsLayers.text, credits.credits[i].type, null, headSize, headColor, font, Align.CENTER);
			title.attachObject(textDisplay);
			text.add(title);
			for (j in 0...credits.credits[i].names.length) {
				y += 30;
				var name:Node = new Node(new Vector2(Globals.stage.stageWidth / 2, y), new Vector2(0, -moveSpeed));
				textDisplay = rootScene.createText(creditsLayers.text, credits.credits[i].names[j], null, nameSize, nameColor, font, Align.CENTER);
				name.attachObject(textDisplay);
				text.add(name);
			}
			y += 60;
		}
	}
	
	/**
	 * Scrolls the text up every update and returns to menu when completed.
	 */
	override public function update(deltaTime:Int):Array<Entity>
	{
		fade.update(deltaTime);
		background.update(deltaTime);
		
		// Return to menu if the menu button is clicked.
		returnButton.update(deltaTime);
		
		// Check the text speed; if the text is above a certain point the text will be removed.
		var iter = text.head;
		var count:Int = 0;
		while (iter != null) {
			count++;
			iter.elt.update(deltaTime);
			if (iter.elt.position.y < -30) {
				iter.elt.isRemoved = true;
			}
			if (iter.elt.isRemoved) {
				text.remove(iter.elt);
			}
			iter = iter.next;
		}
		
		// When all text are removed the state changes to the returnState.
		if (count == 0) {
			nextState = returnState;
		}
		
		return rootScene.flattenedEntityArray;
	}
	
	private function onMenuClick(button:Button):Void {
		if (fade.isFadeComplete) {
			fade.fadeOut(300, 0, returnState);
		}
	}
	
	override public function leave():Void 
	{
		fade.leave();
	}
}