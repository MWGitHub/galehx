/**
 * TODO: Decouple from renderer.
 * @author MW
 */

package com.exploringlines.gale.apps.text;
import com.exploringlines.gale.core.Node;
import com.exploringlines.gale.core.renderer.Entity;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

enum Align {
	LEFT;
	CENTER;
	RIGHT;
}

/**
 * Creates a text bitmapData from a TextField.
 */
class Text extends Entity
{
	/**
	 * The text BitmapData created.
	 */
	public var textBitmapData(default, null):BitmapData;
	
	/**
	 * The textField.
	 */
	public var textField:TextField;
	
	/**
	 * The format of the text.
	 */
	public var textFormat:TextFormat;
	
	/**
	 * If true, the text will be bold.
	 */
	public var bold(default, setBold):Bool;
	
	/**
	 * Sets the sharpness of the text.
	 */
	public var sharpness(getSharpness, setSharpness):Float;
	
	/**
	 * Set the color of the text.
	 */
	public var color(getColor, setColor):UInt;
	
	/**
	 * The text string.
	 */
	public var text(getText, setText):String;
	
	/**
	 * The alignment of the text.
	 */
	public var align(default, setAlign):Align;
	
	private var lastWidth:Float;
	
	/**
	 * The width and height to pad the text by.
	 */
	public var padding:Int;
	
	/**
	 * Translation used to shift paddings.
	 */
	private var translationMatrix:Matrix;
	
	/**
	 * The width of the text field before it wraps.
	 */
	public var width(default, setWidth):Float;
	
	/**
	 * If set to true, the redrawn function must be called manually.
	 */
	public var isManuallyRedrawn:Bool;

	/**
	 * The text string used for generated the initial cache key.
	 */
	private var textKey:String;
	
	/**
	 * Creates a new textfield and format.
	 * @param	parent		The entity the text is attached to.
	 * @param	size		The size of the font.
	 * @param	color		The color of the text.
	 * @param	font		The type of font.
	 * @param	?align		The alignment of the text.
	 */
	public function new(?offset:Point, layer:Int = 0, size:Int = 16, color:UInt = 0xFFFFFF, font:String = "Helvetica") 
	{
		super("Empty", null, null, offset, layer);
		textKey = "Empty";
		isManuallyRedrawn = false;
		rectangle = new Rectangle(0, 0, 640, 480);
		
		textFormat = new TextFormat(font, size, color);
		
		var areFontsEmbedded = font != "Helvetica" ? true : false;
		textField = new TextField();
		textField.embedFonts = areFontsEmbedded;
		textField.text = "";
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.sharpness = -200;
		textField.setTextFormat(textFormat);
		
		padding = 50;
		translationMatrix = new Matrix();
		
		align = Align.LEFT;
		lastWidth = 0;
		
		convertToBitmap();
	}
	
	private inline function setText(text:String):String {
		if (textField.text != text) {
			this.textKey = text;
			textField.text = text;
			convertToBitmap();
		}
		
		return text;
	}
	
	private inline function getText():String {
		return textField.text;
	}
	
	private inline function setBold(v:Bool):Bool {
		textFormat.bold = v;
		convertToBitmap();
		
		return v;
	}
	
	private inline function setSharpness(v:Float):Float {
		textField.sharpness = v;
		convertToBitmap;
		
		return textField.sharpness;
	}
	
	private inline function getSharpness():Float {
		return textField.sharpness;
	}
	
	private inline function getColor():UInt {
		return textFormat.color;
	}
	
	private inline function setColor(v:UInt):UInt {
		textFormat.color = v;
		convertToBitmap();
		
		return v;
	}
	
	private inline function setWidth(v:Float):Float {
		width = v;
		if (width == 0) {
			textField.wordWrap = false;
		} else {
			textField.wordWrap = true;
			textField.width = width;
		}
		convertToBitmap();
		
		return width;
	}
	
	private inline function setAlign(v:Align):Align {
		align = v;
		convertToBitmap();
		
		return align;
	}
	
	/**
	 * Realigns the text.
	 */
	private function realignOffset():Void {
		if (!isCentered) {
			if (align == Align.RIGHT) {
				offset.x = offset.x + lastWidth - textField.width;
			}
			else if (align == Align.CENTER) {
				offset.x = offset.x + lastWidth / 2 - textField.width / 2;
			}
			lastWidth = textField.width;
		}
		center.x = Std.int(rectangle.width / 2);
		center.y = Std.int(rectangle.height / 2);
	}
	
	/**
	 * Applies a filter to the text.
	 * @param	filter		The filter to be applied.
	 */
	public function applyFilter(filter:Dynamic):Void {
		var filters:Array<Dynamic> = textField.filters;
		filters.push(filter);
		textField.filters = filters;
		convertToBitmap();
	}
	
	/**
	 * Removes all filters.
	 */
	public function removeAllFilters():Void {
		textField.filters = [];
	}
	
	/**
	 * Converts the text into a BitmapData.
	 * @param	forceRedraw		Set to true if you text is on manual redraw mode to redraw.
	 */
	public inline function convertToBitmap(forceRedraw:Bool = false):Void {
		var shouldRedraw:Bool = false;
		if (!isManuallyRedrawn || forceRedraw) {
			shouldRedraw = true;
		}
		if (shouldRedraw) {
			textField.setTextFormat(textFormat);
			textBitmapData = new BitmapData(Std.int(textField.width + padding), Std.int(textField.height + padding), true, 0x00000000);
			translationMatrix.tx = Std.int(padding / 2);
			translationMatrix.ty = Std.int(padding / 2);
			textBitmapData.draw(textField, translationMatrix, null, null, null, true);
			bitmapData = textBitmapData;
			rectangle.width = textField.width + padding;
			rectangle.height = textField.height + padding;
			
			realignOffset();
			
			if (parent != null) {
				name = textKey + Std.string(bold) + Std.string(color) + Std.string(sharpness) + Std.string(textFormat.size);
				isCacheUpdated = true;
			}
		}
	}
	
	/**
	 * Convers the text to bitmap on first attachment.
	 * @param	node	The node the entity is attached to.
	 */
	override public function onAttached(node:Node):Void {
		super.onAttached(node);
		
		convertToBitmap(true);
	}
}