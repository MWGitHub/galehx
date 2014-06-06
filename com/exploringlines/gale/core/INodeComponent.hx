/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core;

interface INodeComponent {
	public var priority:Int;
	public var updatesBefore:Bool;
	public var isComplete:Bool;
	public var completeCallback:INodeComponent->Void;
	public function update(deltaTime:Int = 0):Void;
}