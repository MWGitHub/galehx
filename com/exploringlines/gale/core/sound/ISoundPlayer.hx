/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.core.sound;
import flash.media.SoundChannel;

interface ISoundPlayer 
{
	/**
	 * The maximum allowed channels to be used at one time.
	 */
	public var maximumChannels:Int;
	
	/**
	 * If true, no new sound and all current sounds are stopped.
	 */
	public var isMute(default, setMute):Bool;
	
	/**
	 * If true, no music will be playing.
	 */
	public var isMusicMute(default, setMusicMute):Bool;
	
	/**
	 * Plays a sound in a designated channel.
	 * @param	sound		The sound to be played.
	 */
	public function playSound(sound:ISoundData):SoundChannel;
	
	/**
	 * Updates the channel of a sound.
	 * @param	sound		The sound to be updated.
	 */
	public function updateSound(sound:ISoundData):Void;
	
	/**
	 * Stops a specific channel.
	 * @param	channelID	The channel to stop.
	 */
	public function stopChannel(channelID:Int, isMusic:Bool = false):Void;
	
	/**
	 * Retrieves a sound channel.
	 * @param	channelID	The channel to retrieve.
	 */
	public function getChannel(channelID:Int, isMusic:Bool = false):SoundChannel;
	
	/**
	 * Retrieves the sound data.
	 * @param	channelID	The sound data in the channel.
	 * @param	isMusic		If true, then will take from the music channels.
	 * @return	The sound data.
	 */
	public function getChannelData(channelID:Int, isMusic:Bool = false):ISoundData;
}