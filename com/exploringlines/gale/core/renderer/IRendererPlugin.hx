/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.renderer;

interface IRendererPlugin 
{
	/**
	 * The name of the plugin.
	 */
	public var name:String;
	
	/**
	 * The type of the plugin.
	 * Can be either pre or post rendering depending on when the plugin will run.
	 */
	public var type:String;
	
	/**
	 * Applies the plugin to the entity.
	 * @param	entity	The entity to apply to.
	 * @param	object	The cached object which may be modified from other plugins.
	 * @param	data	The components of the plugin.
	 * @return	The object with the plugin applied.
	 */
	public function apply(entity:IEntity, object:RendererCacheObject, data:String):RendererCacheObject;
}