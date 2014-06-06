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

typedef RoundedTheme = {
	var radius:Float;
	var font:String;
	var fontSize:Int;
	var fontColor:UInt;
	var hasGlow:Bool;
	var glowColor:UInt;
	var glowOffset:Float;
	var idleColor:UInt;
	var hoverColor:UInt;
	var idleAlpha:UInt;
	var hoverAlpha:UInt;
}

/**
 * A rounded button that changes color on hover.
 */
class RoundedButton extends Button
{
	private var rootScene:RootScene;
	private var theme:RoundedTheme;
	private var text:Text;
	
	private var display:Entity;
	private var idleBitmapData:BitmapData;
	private var hoverBitmapData:BitmapData;

	public function new(rootScene:RootScene, inputData:InputData, layer:Int, stageLayer:Int = 0, position:Vector2, width:Float, height:Float, text:String, ?theme:RoundedTheme, name:String = "") 
	{
		super(inputData, position);
		
		if (theme == null) {
			this.theme = { radius : 10.0, font : "DroidSans", 
						   fontSize : Std.int(height * 2/3), fontColor : 0xFFFFFF, hasGlow : false, glowColor : 0x000000, glowOffset : 3.0,
						   idleColor : 0x000000, hoverColor : 0x77C6FF, idleAlpha : 1, hoverAlpha : 1
						 };
		} else {
			this.theme = theme;
		}
		if (name == "") {
			this.name = text + this.theme.fontSize + this.theme.hoverColor + this.theme.radius + this.theme.fontColor + this.theme.glowColor + this.theme.hasGlow + Std.string(width) + Std.string(height);
		} else {
			this.name = name;
		}
		
		idleBitmapData = Draw.drawRoundedRect(width, height, this.theme.radius, this.theme.radius, this.theme.idleColor, this.theme.idleAlpha);
		display = new Entity(this.name + "RoundedButtonIdle", idleBitmapData, idleBitmapData.rect, null, layer);
		display.stageLayer = stageLayer;
		rootScene.addEntity(display);
		attachObject(display);
		
		hoverBitmapData = Draw.drawRoundedRect(width, height, this.theme.radius, this.theme.radius, this.theme.hoverColor, this.theme.hoverAlpha);
		
		this.text = rootScene.createText(layer, text, null, this.theme.fontSize, this.theme.fontColor, this.theme.font);
		this.text.stageLayer = stageLayer;
		if (this.theme.hasGlow) {
			this.text.applyFilter(new GlowFilter(this.theme.glowColor, 1, this.theme.glowOffset, this.theme.glowOffset, 5));
		}
		attachObject(this.text);
		
		callbackInitialHover = onInitialHover;
		callbackReleaseAny = onReleaseAny;
		callbackHoverOut = onHoverOut;
	}
	
	/**
	 * Sets the image to the hovered image on first hover.
	 */
	private inline function onInitialHover(button:Button):Void {
		display.bitmapData = hoverBitmapData;
		display.rectangle = hoverBitmapData.rect;
		display.name = name + "RoundedButtonHover";
		display.isCacheUpdated = true;
	}
	
	/**
	 * Sets the image to the released image only if the mouse is not hovering the button.
	 */
	private inline function onReleaseAny(button:Button):Void {
		if (!isMouseHovering) {
			display.bitmapData = idleBitmapData;
			display.rectangle = idleBitmapData.rect;
			display.name = name + "RoundedButtonIdle";
			display.isCacheUpdated = true;
		}
	}
	
	/**
	 * Sets the image to the released image only if the button is not held.
	 */
	private inline function onHoverOut(button:Button):Void {
		if (!isPositiveEdgeClicked) {
			display.bitmapData = idleBitmapData;
			display.rectangle = idleBitmapData.rect;
			display.name = name + "RoundedButtonIdle";
			display.isCacheUpdated = true;
		}
	}
}