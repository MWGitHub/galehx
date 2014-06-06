/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.tile;
import com.exploringlines.gale.core.RootScene;
import json.JSON;
import com.exploringlines.gale.apps.datastructures.Map;

private typedef TileParserTileLayer = {
	var tiles:Array<Array<Int>>;
	var properties:Dynamic;
}

private typedef TileParserObjectLayer = {
	var objects:Array<Dynamic>;
	var properties:Dynamic;
}

/**
 * Parses a map data file.
 * The layers are not parsed until the user parses the specified layer.
 */
class TileParser {
	private var data:Dynamic;
	private var tileLayers:Map<String, TileParserTileLayer>;
	private var objectLayers:Map<String, TileParserObjectLayer>;

	public function new() {
	}
	
	/**
	 * Parses JSON data.
	 * Does not parse individual layer data.
	 * @param	rawData		The data to parse.
	 */
	public function parseData(rawData:Dynamic):Void {
		data = JSON.decode(rawData.toString());
		
		tileLayers = new Map<String, TileParserTileLayer>();
		objectLayers = new Map<String, TileParserObjectLayer>();
	}
	
	/**
	 * Parses a tile layer.
	 * @param	layerName	The name of the layer to parse.
	 */
	public function parseTileLayer(layerName:String):Void {
		if (!tileLayers.exists(layerName)) {
			try {
				var tileLayerData:TileParserTileLayer = {tiles : [], properties : null};
				var layer:Dynamic = untyped data.layers[layerName];
				var tiles:Array<String> = layer.tiles.split(",");
				var width:Int = getWidth();
				var layerTiles:Array<Array<Int>> = [];
				for (i in 0...tiles.length) {
					if (i % width == 0) {
						layerTiles.push([]);
					}
					layerTiles[Std.int(i / width)].push(Std.parseInt(tiles[i]));
				}
				
				tileLayerData.tiles = layerTiles;
				tileLayerData.properties = layer.properties;
				tileLayers.set(layerName, tileLayerData);
			} catch (e:Dynamic) {
				//trace("Warning - No tiles in the layer, creating empty layer.");
				tileLayers.set(layerName, { tiles : [], properties : null } );
			}
		}
	}
	
	/**
	 * Parses an object layer.
	 * @param	layerName	The name of the layer to parse.
	 */
	public function parseObjectLayer(layerName:String):Void {
		if (!objectLayers.exists(layerName)) {
			try {
				var objectLayerData:TileParserObjectLayer = { objects : [], properties : null };
				var layer:Dynamic = untyped data.layers[layerName];
				objectLayerData.objects = layer.objects;
				objectLayerData.properties = layer.properties;
				objectLayers.set(layerName, objectLayerData);
			} catch (e:Dynamic) {
				//trace("Warning - No objects in the layer, creating empty layer.");
				objectLayers.set(layerName, { objects : [], properties : null } );
			}
		}
	}
	
	/**
	 * Gets the map name property.
	 * @return	The name of the map.
	 */
	public function getFileName():String {
		return data.properties.fileName;
	}
	
	/**
	 * Gets the map height in tiles.
	 * @return	The height in tiles of the map.
	 */
	public function getHeight():Int {
		return data.properties.height;
	}
	
	/**
	 * Gets the map width in tiles.
	 * @return	The width in tiles of the map.
	 */
	public function getWidth():Int {
		return data.properties.width;
	}
	
	/**
	 * Gets the tile height.
	 * @return	The height of a tile.
	 */
	public function getTileHeight():Float {
		return data.properties.tileHeight;
	}
	
	/**
	 * Gets the tile width.
	 * @return	The width of a tile.
	 */
	public function getTileWidth():Float {
		return data.properties.tileWidth;
	}
	
	
	
	/**
	 * Gets the tiles in a layer.
	 * @param	layerName	The name of the layer.
	 * @return	The tiles of the layer.
	 */
	public function getTileLayerTiles(layerName:String):Array<Array<Int>> {
		return tileLayers.get(layerName).tiles;
	}
	
	/**
	 * Gets the properties of a layer.
	 * @param	layerName	The name of the layer.
	 * @return	The properties of the layer.
	 */
	public function getTileLayerProperties(layerName:String):Dynamic {
		return tileLayers.get(layerName).properties;
	}
	
	/**
	 * Gets a specified property of a layer.
	 * @param	layerName	The name of the layer.
	 * @param	property	The property of the layer.
	 * @return	The property of the layer.
	 */
	public function getTileLayerProperty(layerName:String, property:String):Dynamic {
		return untyped tileLayers.get(layerName).properties[property];
	}
	
	
	
	/**
	 * Gets the objects in a layer.
	 * @param	layerName	The name of the layer.
	 * @return	The objects in the layer.
	 */
	public function getObjectLayerObjects(layerName:String):Array<Dynamic> {
		return objectLayers.get(layerName).objects;
	}
	
	/**
	 * Gets the properties of a layer.
	 * @param	layerName	The name of the layer.
	 * @return	The properties of the layer.
	 */
	public function getObjectLayerProperties(layerName:String):Dynamic {
		return objectLayers.get(layerName).properties;
	}
	
	/**
	 * Gets a specified property of a layer.
	 * @param	layerName	The name of the layer.
	 * @param	property	The property of the layer.
	 * @return	The property of the layer.
	 */
	public function getObjectLayerProperty(layerName:String, property:String):Dynamic {
		return untyped objectLayers.get(layerName).properties[property];
	}
	
	/**
	 * Retrieves an object in a layer matching the name given.
	 * The first object found with the name is retrieved and the rest are ignored.
	 * @param	layerName	The name of the layer.
	 * @param	objectName	The name of the object.
	 * @return	The first object found with the matching name.
	 */
	public function getObjectLayerObjectByName(layerName:String, objectName:String):Dynamic {
		var layerObjects:Array<Dynamic> = objectLayers.get(layerName).objects;
		for (i in 0...layerObjects.length) {
			if (layerObjects[i].name == objectName) {
				return layerObjects[i];
			}
		}
		
		return null;
	}

	/**
	 * Retrieves all object in a layer matching the name given.
	 * @param	layerName	The name of the layer.
	 * @param	objectName	The name of the object.
	 * @return	All objects matching the object name.
	 */
	public function getObjectLayerObjectListByName(layerName:String, objectName:String):Array<Dynamic> {
		var layerObjects:Array<Dynamic> = objectLayers.get(layerName).objects;
		var objects:Array<Dynamic> = [];
		for (i in 0...layerObjects.length) {
			if (layerObjects[i].name == objectName) {
				objects.push(layerObjects[i]);
			}
		}
		
		return objects;
	}
}