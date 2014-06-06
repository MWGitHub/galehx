/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.nodecomponents;
import com.exploringlines.gale.apps.datastructures.LinkedList;
import com.exploringlines.gale.apps.timers.CountdownTimer;
import com.exploringlines.gale.apps.timers.PeriodicTimer;
import com.exploringlines.gale.core.INode;
import com.exploringlines.gale.core.NodeComponent;
/**
 * Flickers nodes by toggling visibility.
 */
class NodeFlicker extends NodeComponent {
	private var node:INode;
	private var duration:CountdownTimer;
	private var frequency:PeriodicTimer;
	private var originalVisibility:Bool;

	public function new(node:INode, duration:Int, frequency:Int) {
		super();
		
		this.node = node;
		this.duration = new CountdownTimer(duration);
		this.frequency = new PeriodicTimer(frequency);
		originalVisibility = node.isVisible;
	}
	
	/**
	 * Flickers the nodes.
	 * @param	deltaTime
	 */
	override public function update(deltaTime:Int = 0):Void {
		duration.update(deltaTime);
		if (duration.isReady) {
			node.isVisible = originalVisibility;
			isComplete = true;
		} else {
			frequency.update(deltaTime);
			if (frequency.isReady) {
				node.isVisible = node.isVisible ? false : true;
			}
		}
	}
}