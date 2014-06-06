/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.tile;
import com.exploringlines.gale.core.RootScene;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * Splits tilesheets into separate displays.
 */
class TileSheetSplitter {
	private static var tileDisplays:Hash<BitmapData>;

	public function new() {
		tileDisplays = new Hash<BitmapData>();
	}
	
	/**
	 * Generate the tile displays for each tile, even empty spaces on the tilesheet.
	 * @param	tileSheet	The tilesheet to split.
	 * @param	name		The name of the tilesheet, used when retrieving the display.
	 * @param	tileWidth	The width of each tile.
	 * @param	tileHeight	The height of each tile.
	 */
	public function generateTiles(tileSheet:BitmapData, name:String, tileWidth:Int, tileHeight:Int):Void {
		var display:BitmapData = new BitmapData(tileWidth, tileHeight, true);
		
		var cols:Int = Std.int(tileSheet.rect.width / tileWidth);
		var rows:Int = Std.int(tileSheet.rect.height / tileHeight);
		var x:Float;
		var y:Float;
		for (row in 0...rows) {
			for (col in 0...cols) {
				x = col * tileWidth;
				y = row * tileHeight;
				display = new BitmapData(tileWidth, tileHeight, true);
				display.copyPixels(tileSheet, new Rectangle(x, y, tileWidth, tileHeight), new Point(0, 0));
				tileDisplays.set(name + Std.string(row * cols + col), display);
			}
		}
	}
	
	/**
	 * Retrieves the bitmapData from a split sheet.
	 * @param	name	The name of the splitted sheet.
	 * @param	index	The index of the tile in the sheet.
	 * @return	The bitmapData of the tile.
	 */
	public static function getTileBitmapData(name:String, index:Int):BitmapData {
		return tileDisplays.get(name + Std.string(index));
	}
	
	/**
	 * Flushes all cached displays.
	 */
	public function flushData():Void {
		tileDisplays = new Hash<BitmapData>();
	}
}