package com.exploringlines.gale.core.sound ;

import flash.events.SampleDataEvent;
import flash.geom.Transform;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.ByteArray;

/**
 * Plays and manages sound channels from SoundData passed through the update phase.
 * @author MW
 */
class SoundPlayer implements ISoundPlayer
{
	/**
	 * @inheritDoc
	 */
	public var maximumChannels:Int;
	public var maximumMusicChannels:Int;
	private var sound:SoundData;
	private var channels:Array<SoundChannel>;
	private var channelData:Array<ISoundData>;
	
	private var musicChannels:Array<SoundChannel>;
	private var musicChannelData:Array<ISoundData>;
	
	/**
	 * If true, no new sound and all current sounds are stopped.
	 */
	public var isMute(default, setMute):Bool;
	
	/**
	 * @inheritDoc
	 */
	public var isMusicMute(default, setMusicMute):Bool;
	
	/**
	 * Creates empty channels for the sound to play in.
	 */
	public function new() 
	{
		maximumChannels = 24;
		maximumMusicChannels = 7;
		channels = [];
		channelData = [];
		isMute = false;
		
		musicChannels = [];
		musicChannelData = [];
		isMusicMute = false;
		
		var sound:Sound = new Sound();
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
		sound.play();
	}
	
	/**
	 * Plays a sound in a designated channel.
	 * @param	sound		The sound to be played.
	 */
	public inline function playSound(sound:ISoundData):SoundChannel {
		if (sound.isMusic) {
			if (!isMusicMute) {
				try {
					if (sound.channel >= maximumMusicChannels) {
						throw("Error: Upper sound channel limit exceeded for music");
					}
					musicChannels[sound.channel] = sound.sound.play(sound.offset, sound.loop, sound.transform);
					musicChannelData[sound.channel] = sound;
					sound.soundChannel = musicChannels[sound.channel];
					sound.isPlaying = true;
					
					return musicChannels[sound.channel];
				} catch(error:String) {
					trace(error);
				}
			}
		} else {
			if (!isMute) {
				try {
					if (sound.channel >= maximumChannels) {
						throw("Error: Upper sound channel limit exceeded");
					}
					if (channels[sound.channel] != null) {
						//channels[sound.channel].stop();
						//channels[sound.channel] = null;
					}
					channels[sound.channel] = sound.sound.play(sound.offset, sound.loop, sound.transform);
					channelData[sound.channel] = sound;
					sound.soundChannel = channels[sound.channel];
					sound.isPlaying = true;
					
					return channels[sound.channel];
				} catch(error:String) {
					trace(error);
				}
			}
		}
		
		return null;
	}
	
	/**
	 * Updates the channel of a sound.
	 * @param	sound		The sound to be updated.
	 */
	public inline function updateSound(sound:ISoundData):Void {
		if (sound.isMusic) {
			if (!isMusicMute) {
				try {
					if (sound.isStopped) {
						if (musicChannels[sound.channel] != null) {
							musicChannels[sound.channel].stop();
						}
						sound.isPlaying = false;
					} else {
						if (musicChannels[sound.channel] != null) {
							musicChannels[sound.channel].soundTransform = sound.transform;
						}
					}
				} catch (error:Dynamic) {
					trace("Error: Sound does not exist or hasn't been played yet.");
				}
			}
		} else {
			if (!isMute) {
				try {
					if (sound.isStopped) {
						if (channels[sound.channel] != null) {
							channels[sound.channel].stop();
						}
						sound.isPlaying = false;
					} else {
						if (channels[sound.channel] != null) {
							channels[sound.channel].soundTransform = sound.transform;
						}
					}
				} catch (error:Dynamic) {
					trace("Error: Sound does not exist or hasn't been played yet.");
				}
			}
		}
	}
	
	/**
	 * Stops a specific channel.
	 * @param	channelID	The channel to stop.
	 */
	public inline function stopChannel(channelID:Int, isMusic:Bool = false):Void {
		if (isMusic) {
			if (musicChannels[channelID] != null) {
				musicChannels[channelID].stop();
				musicChannelData[channelID].isPlaying = false;
			}
		} else {
			if (channels[channelID] != null) {
				channels[channelID].stop();
				channelData[channelID].isPlaying = false;
			}
		}
	}
	
	/**
	 * Retrieves a channel.
	 * @param	channelID	The channel to retrieve.
	 */
	public inline function getChannel(channelID:Int, isMusic:Bool = false):SoundChannel {
		if (isMusic) {
			return musicChannels[channelID];
		}
		return channels[channelID];
	}
	
	public inline function getChannelData(channelID:Int, isMusic:Bool = false):ISoundData {
		if (isMusic) {
			return musicChannelData[channelID];
		}
		return channelData[channelID];
	}
	
	private function setMute(v:Bool):Bool {
		if (v) {
			for (i in 0...channelData.length) {
				if (channelData[i] != null) {
					if (channelData[i].soundChannel != null) {
						channelData[i].soundChannel.stop();
					}
					channelData[i].isPlaying = false;
					channelData[i].isStopped = true;
				}
			}
		}
		
		isMute = v;
		return v;
	}
	
	private function setMusicMute(v:Bool):Bool {
		if (v) {
			for (i in 0...musicChannelData.length) {
				if (musicChannelData[i] != null) {
					if (musicChannelData[i].soundChannel != null) {
						musicChannelData[i].soundChannel.stop();
					}
					musicChannelData[i].isStopped = true;
					musicChannelData[i].isPlaying = false;
				}
			}
		}
		
		isMusicMute = v;
		return v;
	}
	
	private function writeData(e:SampleDataEvent):Void {
		for (i in 0...4096) {
			e.data.writeFloat(0);
		}
	}
}