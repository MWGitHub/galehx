package com.exploringlines.gale.core.sound;

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.ByteArray;

/**
 * The data used when referencing sounds.
 * @author MW
 */
class SoundData implements ISoundData
{
	static private var counter:Int = 0;
	
	/**
	 * The ID of this object.
	 */
	public var index(default, null):Int;
	
	/**
	 * The sound to be played.
	 */
	public var sound:Sound;
	
	/**
	 * The channel the sound resides in.
	 */
	public var channel:Int;
	
	public var soundChannel:SoundChannel;
	
	/**
	 * The amount of times the sound should loop before stopping.
	 */
	public var loop:Int;
	
	/**
	 * The initial time offset within a clip the sound begins at.
	 */
	public var offset:Float;
	
	/**
	 * Allows transformation of the sound.
	 * Do not set properties on transform; it will not affect the current sound playing unless updated.
	 */
	public var transform:SoundTransform;
	
	/**
	 * True if the sound is to be stopped.
	 */
	public var isStopped:Bool;
	
	/**
	 * True if the sound is being played.
	 */
	public var isPlaying:Bool;
	
	/**
	 * True if the sound should be in the music channels.
	 */
	public var isMusic:Bool;
	
	/**
	 * Creates a default transform for the sound and assigns the sound an ID for use with the sound channel.
	 */
	public function new(sound:Sound) 
	{
		this.sound = sound;
		
		channel = 0;
		loop = 0;
		offset = 0;
		isStopped = false;
		isPlaying = false;
		
		transform = new SoundTransform();
		transform.volume = 1;
		
		index = counter;
		counter++;
	}
	
	/**
	 * Sets a new sound to the current sound.
	 * @param	sound		The sound to be set.
	 */
	public function setSound(sound:Sound):Void {
		this.sound = sound;
		isStopped = false;
	}
	
	/**
	 * A value, from 0 (none) to 1 (all), specifying how much of the left input is played in the left speaker.
	 */
	public function setLeftToLeft(n:Float):Void {
		transform.leftToLeft = n;
	}
	
	/**
	 * A value, from 0 (none) to 1 (all), specifying how much of the left input is played in the right speaker.
	 */
	public function setLeftToRight(n:Float):Void {
		transform.leftToRight = n;
	}
	
	/**
	 * The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right).
	 */
	public function setPan(n:Float):Void {
		transform.pan = n;
	}
	
	/**
	 * A value, from 0 (none) to 1 (all), specifying how much of the right input is played in the left speaker.
	 */
	public function setRightToLeft(n:Float):Void {
		transform.rightToLeft = n;
	}
	
	/**
	 * A value, from 0 (none) to 1 (all), specifying how much of the right input is played in the right speaker
	 */
	public function setRightToRight(n:Float):Void {
		transform.rightToRight = n;
	}
	
	/**
	 * The volume, ranging from 0 (silent) to 1 (full volume).
	 */
	public function setVolume(n:Float):Void {
		transform.volume = n;
	}
}