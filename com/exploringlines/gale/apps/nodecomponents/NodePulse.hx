/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.nodecomponents;
import com.exploringlines.gale.apps.timers.CountdownTimer;
import com.exploringlines.gale.apps.timers.PeriodicTimer;
import com.exploringlines.gale.core.INode;
import com.exploringlines.gale.core.NodeComponent;

class NodePulse extends NodeComponent {
	private var node:INode;
	private var duration:CountdownTimer;
	private var period:PeriodicTimer;
	private var beginAlpha:Float;
	private var endAlpha:Float;
	private var originalAlpha:Float;
	private var isReversed:Bool;

	public function new(node:INode, duration:Int, period:Int, beginAlpha:Float = 0, endAlpha:Float = 0) {
		super();
		
		this.node = node;
		this.duration = new CountdownTimer(duration);
		this.period = new PeriodicTimer(period);
		this.beginAlpha = beginAlpha;
		this.endAlpha = endAlpha;
		this.originalAlpha = node.alpha;
		isReversed = false;
	}
	
	override public function update(deltaTime:Int = 0):Void {
		duration.update(deltaTime);
		if (duration.isReady) {
			isComplete = true;
			node.alpha = originalAlpha;
		} else {
			period.update(deltaTime);
			if (period.isReady) {
				isReversed = isReversed ? false : true;
			} else {
				if (!isReversed) {
					node.alpha = beginAlpha + (endAlpha - beginAlpha) * (period.counter / period.period);
				} else {
					node.alpha = endAlpha - (endAlpha - beginAlpha) * (period.counter / period.period);
				}
			}
		}
	}
}