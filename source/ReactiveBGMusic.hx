package;

import flixel.system.FlxSound;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Dillon Woollums
 */
class ReactiveBGMusic
{
	private var tracks:List<ReactiveBGMusicTrack>;
	
	private var globalLoopPoint:Float;
	private var needsGlobalLooping:Bool;
	private var currentLoopTimer:FlxTimer;
	private var paused:Bool;
	public var currentMix:String;
	/**
	 * 
	 * @param	globalLooping if a track starts after the loop point in the song, you need to set this to true.
	 */
	public function new(globalLooping:Bool) 
	{
		create(globalLooping);
		
	}
	
	public function create(globalLooping:Bool){
		#if debug
			trace("Instantiating ReactiveBGMusic Object.");
		#end
		paused = false;
		needsGlobalLooping = globalLooping;
		tracks = new List<ReactiveBGMusicTrack>();
		currentMix = "";
	}
	
	public function play()
	{
		#if debug
			trace("Attempting to play song.");
		#end
		if (!paused){
			for (track in tracks)
			{
				track.play();
			}
			if (needsGlobalLooping)
			{
				currentLoopTimer = new FlxTimer();
				currentLoopTimer.onComplete = onLoopTimerComplete;
				currentLoopTimer.start(globalLoopPoint);
			}
		}
		else
		{
				resume();
		}

	}
	
	private function onLoopTimerComplete(Timer:FlxTimer){
		#if debug
			trace("Playing song from loop.");
		#end
		playFromLoop();
	}
	
	public function playFromLoop()
	{
		#if debug
			trace("Telling all tracks to play from loop.");
		#end
		for (track in tracks){
			track.playFromLoop(globalLoopPoint);
		}
	}
	
	public function stop()
	{
		#if debug
			trace("Stopping all music tracks.");
		#end
		if (needsGlobalLooping){
			currentLoopTimer.destroy();
		}
		for (track in tracks){
			track.stop();
		}
		paused = false;
	}
	
	public function pause()
	{
		#if debug
			trace("Pausing all music tracks.");
		#end
		for (track in tracks){
			track.pause();
		}
		paused = true;
	}
	
	public function resume()
	{
		#if debug
			trace("Resuming all music tracks.");
		#end
		for (track in tracks){
			track.resume();
		}
	}
	
	public function addTrack(track:ReactiveBGMusicTrack)
	{		
		#if debug
			trace("Adding music track to song.");
		#end
		tracks.add(track);
	}
	/**
	 * 
	 * @param	mix the name of the mix you want to set on all tracks.
	 */
	public function setMix(mix:String)
	{
		#if debug
			trace("Setting mix on all tracks to:" + mix);
		#end
		for (track in tracks){
			track.setMix(mix);
		}
		currentMix = mix;
	}
	
	public function destroy(){
		stop();
		for (track in tracks){
			track.destroy();
		}
	}
	
}
