/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core;

/**
 * Base class for a node component.
 */
class NodeComponent implements INodeComponent {
	public var priority:Int;
	public var updatesBefore:Bool;
	public var isComplete:Bool;
	public var completeCallback:INodeComponent->Void;
	
	public function new(priority:Int = 0, updatesBefore:Bool = true, completeCallback:INodeComponent->Void = null) {
		this.priority = priority;
		this.updatesBefore = updatesBefore;
		this.isComplete = false;
		this.completeCallback = completeCallback;
	}
	
	public function update(deltaTime:Int = 0):Void {
		
	}
}