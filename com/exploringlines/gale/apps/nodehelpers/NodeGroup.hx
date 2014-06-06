/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.nodehelpers;
import com.exploringlines.gale.core.INode;
import com.exploringlines.gale.core.Node;
import haxe.FastList;

/**
 * Manages a group of nodes.
 */
class NodeGroup {
	/**
	 * The nodes in the group.
	 */
	public var nodes:FastList<INode>;
	
	public var count(getCount, never):Int;

	public function new() {
		nodes = new FastList<INode>();
	}
	
	/**
	 * Updates all the nodes, runs a user function, and removes nodes.
	 * @param	deltaTime				The time top update by.
	 * @param	?preUpdateFunction		Runs a function before updating the node.
	 * @param	?postUpdateFunction		Runs a function after updating the node.
	 */
	inline public function update(deltaTime:Int = 0, ?preUpdateFunction:INode->Int->Void, ?postUpdateFunction:INode->Int->Void):Void {
		var iter = nodes.head;
		while (iter != null) {
			if (preUpdateFunction != null) {
				preUpdateFunction(iter.elt, deltaTime);
			}
			iter.elt.update(deltaTime);
			if (iter.elt.isRemoved) {
				nodes.remove(iter.elt);
			}
			if (postUpdateFunction != null) {
				postUpdateFunction(iter.elt, deltaTime);
			}
			iter = iter.next;
		}
	}
	
	/**
	 * Runs a function on all the nodes.
	 * @param	func	The function to run.
	 */
	inline public function runFunction(func:INode-> Void):Void {
		var iter = nodes.head;
		while (iter != null) {
			func(iter.elt);
			iter = iter.next;
		}
	}
	
	/**
	 * Adds a node.
	 * @param	node	The node to add.
	 */
	inline public function add(node:INode):Void {
		nodes.add(node);
	}
	
	/**
	 * Removes a single node.
	 * @param	node	The node to remove.
	 */
	inline public function remove(node:INode):Void {
		nodes.remove(node);
	}
	
	/**
	 * Clears the nodes.
	 */
	inline public function clear():Void {
		nodes = new FastList<INode>();
	}
	
	inline public function getCount():Int {
		var iter = nodes.head;
		var count:Int = 0;
		while (iter != null) {
			count++;
			iter = iter.next;
		}
		
		return count;
	}
}