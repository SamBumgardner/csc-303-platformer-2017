package;

/**
 * ...
 * @author Dillon Woollums
 */
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

 
class ReactiveBGMusicTrack 
{
	private var mixes: Map<String, ReactiveBGMusicTrackSetting>;
	private var track:FlxSound;
	private var trackType:ReactiveBGMusicTrackType;
	private var currentMix:ReactiveBGMusicTrackSetting;
	private var TimeInSongOffset:Float; //how long to delay the playing of this track
	private var TimeInTrackOffset:Float; //the startpoint to play in the file
	private var loopPoint:Float; //the time to loop back to in the song
	private var endPoint:Float ;
	private var requiresGlobalLooping:Bool;
	private var startTimer:FlxTimer;
	private var started:Bool;
	private var timeLeftAtPause:Float;
	
	/**
	 * 
	 * @param	EmbeddedTrack 			The embedded sound object corresponding to the track you want to create	
	 * @param	OffsetInSong			How late into the overall song this track starts playing
	 * @param	OffsetInTrack			How late into the track to start playing from
	 * @param	inTrackLoopPoint		When looping what point to return to.
	 * @param	inTrackEndPoint			The point in the file where it should stop playing
	 * @param	needsGlobalLooping		Does the ReactiveBGMusic class need to handle the looping for this track?
	 * @param	typeOfTrack				What kind of track is this?
	 */
	public function new(EmbeddedTrack:FlxSoundAsset, OffsetInSong:Float = 0, OffsetInTrack:Float = 0, inTrackLoopPoint:Float = 0, inTrackEndPoint:Float = 0, needsGlobalLooping:Bool, typeOfTrack:ReactiveBGMusicTrackType) 
	{
		#if debug
			trace("Instantiating ReactiveBGMusicTrack");
		#end
		started = false;
		timeLeftAtPause = 0;
		needsGlobalLooping = requiresGlobalLooping;
		TimeInSongOffset = OffsetInSong;
		TimeInTrackOffset = OffsetInTrack;
		loopPoint = inTrackLoopPoint;
		endPoint = inTrackEndPoint;
		track = new FlxSound();
		track.loadEmbedded(EmbeddedTrack, !requiresGlobalLooping, false);
		trackType = typeOfTrack;
		mixes = new Map<String, ReactiveBGMusicTrackSetting>();
		
	}
	/**
	 * Add settings for a mix
	 * @param	name	name of the mix	
	 * @param	volume	how loud this track is in the mix [0,1]
	 * @param	pan		panning of the track [0,1]
	 * @param	timeOffset	the amount of time into the other tracks this track starts playing
	 */
	public function addMix(name:String, volume:Float,  pan:Float)
	{
		#if debug
			trace("Adding mix to track:" + name);
		#end
		mixes.set(name, new ReactiveBGMusicTrackSetting(volume, pan)); 
	}
	
	public function setMix(name:String)
	{
		#if debug
			trace("Setting mix on track to:" + name);
		#end
		var newVolume:Float;
		var newPanning:Float;
		if (mixes.exists(name)){
			var volume:Float = mixes[name].getTrackVolume();
			if (volume >= track.volume){
				track.fadeIn(0.2, track.volume, volume);
			}
			else{
				track.fadeOut(0.2, volume);
			}
			track.pan = mixes[name].getTrackPanning();
		}
		
	}
	
	public function play()
	{
		#if debug
			trace("Got signal to play track.");
		#end
		//stop sound if already playing
		track.stop();
		//start a timer and tell it to start playing at the end of the timer
		if (TimeInSongOffset != 0){
			startTimer = new FlxTimer();
			startTimer.onComplete = onCompletePlayTimer;
			startTimer.start(TimeInSongOffset);
		}
		else{
			onCompletePlayTimer(new FlxTimer());
		}

		
	}
	
	public function onCompletePlayTimer(Timer:FlxTimer)
	{
		#if debug
			trace("Playing track.");
		#end
		track.play(false, 0.0, endPoint);
		started = true;
	}
	
	
	public function playFromLoop(globalSongLoopPoint:Float)
	{
		#if debug
			trace("Got signal to play track from loop.");
		#end
		//stop sound if already playing
		track.stop();
		//start a timer and tell it to start playing at the end of the timer
		startTimer = new FlxTimer();
		startTimer.onComplete = onCompletePlayTimer;
		var effectiveOffset = TimeInSongOffset - globalSongLoopPoint;
		if (effectiveOffset > 0)
		{
			startTimer.start(TimeInSongOffset - globalSongLoopPoint);
			started = false;
		}
		else
		{
			track.play(false, -effectiveOffset, endPoint);
		}
	}
	
	public function pause(){
		#if debug
			trace("Pausing track.");
		#end
		if (!started){
			timeLeftAtPause = startTimer.timeLeft;
			startTimer.destroy();
		}
		else{
			timeLeftAtPause = 0;
		}
		track.pause();
	}
	
	public function resume(){
		#if debug
			trace("Got signal to resume track.");
		#end
		startTimer = new FlxTimer();
		startTimer.onComplete = onCompletePlayTimer;
		startTimer.start(timeLeftAtPause);
	}
	
	public function stop(){
		#if debug
			trace("Stopping track.");
		#end
		track.stop();
	}
	
	private function onCompleteResumeTimer(Timer:FlxTimer){
		#if debug
			trace("Resuming track.");
		#end
		track.resume();
		started = true;
	}
	
	public function destroy(){
		track.stop();
		track.destroy();
	}
	

}