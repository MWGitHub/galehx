/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.sound;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

interface ISoundData {
	public var isMusic:Bool;
	public var isPlaying:Bool;
	public var isStopped:Bool;
	public var channel:Int;
	public var soundChannel:SoundChannel;
	public var sound:Sound;
	public var offset:Float;
	public var loop:Int;
	public var transform:SoundTransform;
}