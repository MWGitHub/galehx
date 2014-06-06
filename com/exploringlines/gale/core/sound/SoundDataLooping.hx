package com.exploringlines.gale.core.sound;

import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.ByteArray;

/**
 * The data used when referencing sounds.
 * @author MW
 */
class SoundDataLooping implements ISoundData
{
	private static inline var bytesPerSample:Int = 4;
	private static inline var bitsPerBytes:Int = 8;
	
	/**
	 * The sound to be played.
	 */
	public var sound:Sound;
	
	/**
	 * The channel the sound resides in.
	 */
	public var channel:Int;
	
	/**
	 * The sound channel.
	 */
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
	 * The data of the sound.
	 */
	public var data:ByteArray;
	public var dataLengthSamples:Int;
	
	/**
	 * The volume of the sound.
	 */
	public var volume:Float;
	
	/**
	 * Creates a default transform for the sound and assigns the sound an ID for use with the sound channel.
	 */
	public function new(dataSound:Sound, beginOffset:Float = 0, volume:Float = 1) 
	{
		data = new ByteArray();
		dataSound.extract(data, dataSound.bytesTotal * bitsPerBytes, beginOffset);
		dataLengthSamples = Std.int(data.length / bitsPerBytes);
		data.position = 0;
		
		sound = new Sound();
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
		
		channel = 0;
		loop = 0;
		offset = 0;
		isStopped = false;
		isPlaying = false;
		isMusic = true;
		
		transform = new SoundTransform();
		transform.volume = 1;
		
		this.volume = volume;
	}
	
	/**
	 * Stops playing the sound.
	 */
	public function stop():Void {
		soundChannel.stop();
		sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
		sound = null;
		sound = new Sound();
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
	}
	
	public function replay():Void {
		stop();
		soundChannel = sound.play();
	}
	
	private function writeData(e:SampleDataEvent):Void {
		var shouldReplay:Bool = false;
		for (i in 0...8192) {
			if (data.bytesAvailable <= 0) {
				data.position = 0;
				shouldReplay = true;
			}
			e.data.writeFloat(data.readFloat() * volume);
		}
		
		if (shouldReplay) {
			replay();
		}
	}
}