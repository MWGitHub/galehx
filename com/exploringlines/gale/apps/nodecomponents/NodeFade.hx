/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.nodecomponents;
import com.exploringlines.gale.apps.timers.CountdownTimer;
import com.exploringlines.gale.core.INode;
import com.exploringlines.gale.core.NodeComponent;

class NodeFade extends NodeComponent {
	private var node:INode;
	private var counter:CountdownTimer;
	private var beginAlpha:Float;
	private var endAlpha:Float;

	public function new(node:INode, duration:Int, beginAlpha:Float = 0, endAlpha:Float = 0) {
		super();
		
		this.node = node;
		counter = new CountdownTimer(duration);
		this.beginAlpha = beginAlpha;
		this.endAlpha = endAlpha;
	}
	
	override public function update(deltaTime:Int = 0):Void {
		counter.update(deltaTime);
		if (counter.isReady) {
			isComplete = true;
			node.alpha = endAlpha;
		} else {
			node.alpha = beginAlpha + (endAlpha - beginAlpha) * (counter.counter / counter.period);
		}
	}
}