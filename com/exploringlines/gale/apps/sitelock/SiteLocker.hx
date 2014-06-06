/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.sitelock;
import com.exploringlines.gale.core.Globals;
import flash.Lib;

class SiteLocker 
{
	private var sites:Array<String>;

	public function new() 
	{
		sites = [];
	}
	
	public function addAllowedSite(site:String):Void {
		sites.push(site);
	}
	
	public function isSiteAllowed():Bool {
		var domain:String = Globals.stage.root.loaderInfo.url.split("/")[2];
		
		for (i in 0...sites.length) {
			var domainID:Int = domain.indexOf(sites[i]);
			if (domainID != -1 && domainID == (domain.length - sites[i].length)) {
				return true;
			}
		}
		
		return false;
	}
}