/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.gui.widgets.buttons;
import com.exploringlines.gale.apps.graphics.Draw;
import com.exploringlines.gale.apps.math.geom.Vector2;
import com.exploringlines.gale.apps.text.Text;
import com.exploringlines.gale.core.Button;
import com.exploringlines.gale.core.input.InputData;
import com.exploringlines.gale.core.renderer.Entity;
import com.exploringlines.gale.core.renderer.IEntity;
import com.exploringlines.gale.core.resourceloader.CachedBitmapData;
import com.exploringlines.gale.core.RootScene;
import flash.display.BitmapData;
import flash.filters.GlowFilter;

typedef TextButtonTheme = {
	var font:String;
	var fontSize:Int;
	var hasGlow:Bool;
	var glowColor:UInt;
	var glowOffset:Float;
	var idleColor:UInt;
	var hoverColor:UInt;
	var align:Align;
	var isCentered:Bool;
}

/**
 * A rounded button that changes color on hover.
 */
class TextButton extends Button
{
	private var rootScene:RootScene;
	private var theme:TextButtonTheme;
	private var idleText:Text;
	private var hoverText:Text;
	private var text:Text;

	public function new(rootScene:RootScene, inputData:InputData, layer:Int, stageLayer:Int = 0, position:Vector2, text:String, ?theme:TextButtonTheme, name:String = "") 
	{
		super(inputData, position);
		this.rootScene = rootScene;
		
		if (theme == null) {
			this.theme = { font : "DroidSans", fontSize : 16,
						   hasGlow : false, glowColor : 0x000000, glowOffset : 5.0,
					       idleColor : 0x000000, hoverColor : 0x82C8FB,
					       align : Align.LEFT, isCentered : false
						 }
		} else {
			this.theme = theme;
		}
		
		isCentered = this.theme.isCentered;
		
		this.text = rootScene.createText(layer, text, null, this.theme.fontSize, this.theme.idleColor, this.theme.font, this.theme.align);
		this.text.stageLayer = stageLayer;
		this.text.isCentered = this.theme.isCentered;
		attachObject(this.text);
		
		callbackInitialHover = onInitialHover;
		callbackReleaseAny = onReleaseAny;
		callbackHoverOut = onHoverOut;
	}
	
	/**
	 * Sets the image to the hovered image on first hover.
	 */
	private inline function onInitialHover(button:Button):Void {
		text.color = theme.hoverColor;
	}
	
	/**
	 * Sets the image to the released image only if the mouse is not hovering the button.
	 */
	private inline function onReleaseAny(button:Button):Void {
		if (!isMouseHovering) {
			text.color = theme.idleColor;
		}
	}
	
	/**
	 * Sets the image to the released image only if the button is not held.
	 */
	private inline function onHoverOut(button:Button):Void {
		if (!isPositiveEdgeClicked) {
			text.color = theme.idleColor;
		}
	}
}