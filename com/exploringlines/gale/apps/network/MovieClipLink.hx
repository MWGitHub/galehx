/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.network;
import com.exploringlines.gale.core.Globals;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.Lib;
import flash.net.URLRequest;
import flash.system.Security;

class MovieClipLink 
{
	private var rectangle:Rectangle;
	private var linkHook:MovieClip;
	private var link:URLRequest;

	public function new(rectangle:Rectangle, link:String) 
	{
		this.rectangle = rectangle;
		this.link = new URLRequest(link);
		
		linkHook = new MovieClip();
		linkHook.graphics.beginFill(0x784b1f);
		linkHook.alpha = 0.01;
		linkHook.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
		linkHook.graphics.endFill();
		linkHook.gotoAndStop(0);
	}
	
	public function enable():Void {
		if (!Globals.stage.contains(linkHook)) {
			Globals.stage.addChild(linkHook);
			linkHook.addEventListener(MouseEvent.CLICK, linkHookClick);
		}
	}
	
	public function disable():Void {
		if (Globals.stage.contains(linkHook)) {
			Globals.stage.removeChild(linkHook);
			linkHook.removeEventListener(MouseEvent.CLICK, linkHookClick);
		}
	}
	
	public function updateLocation(rectangle:Rectangle):Void {
		linkHook.graphics.clear();
		linkHook.graphics.beginFill(0x784b1f);
		linkHook.alpha = 0.01;
		linkHook.graphics.drawRect(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
		linkHook.graphics.endFill();
	}
	
	private function linkHookClick(event:MouseEvent):Void {
		Security.allowDomain(link.url);
		Security.allowInsecureDomain(link.url);
		Lib.getURL(link, "_blank");
	}
}