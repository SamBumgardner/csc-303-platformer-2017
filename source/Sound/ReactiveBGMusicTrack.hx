package;

/**
 * ...
 * @author Dillon Woollums
 */

 enum ReactiveBGMusicTrackType
 {
	Rhythm;
	Lead;
	Bass;
	PercussionBass;
	PercussionMid;
	PercussionTreb;
	GeneralPercussion;
	Effects;
	
 }
 
class ReactiveBGMusicTrack 
{
	private var mixes: Map<String, ReactiveBGMusicTrackSetting>;
	private var track:FlxSound;
	private var trackType:Enum<ReactiveBGMusicTrackType>;
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
	public function new(EmbeddedTrack:EmbeddedSound, OffsetInSong:Float = 0, OffsetInTrack:Float = 0, inTrackLoopPoint:Float = 0, inTrackEndPoint:Float = 0, needsGlobalLooping:Float, typeOfTrack:ReactiveBGMusicTrackType) 
	{
		started = false;
		timeLeftAtPause = 0;
		needsGlobalLooping = requiresGlobalLooping;
		TimeInSongOffset = OffsetInSong;
		TimeInTrackOffset = OffsetInTrack;
		loopPoint = inTrackLoopPoint;
		endPoint = inTrackEndPoint;
		track = loadEmbedded(EmbeddedTrack, !requiresGlobalLooping, false);
		trackType = typeOfTrack;
		
	}
	/**
	 * Add settings for a mix
	 * @param	name	name of the mix	
	 * @param	volume	how loud this track is in the mix [0,1]
	 * @param	pan		panning of the track [0,1]
	 * @param	timeOffset	the amount of time into the other tracks this track starts playing
	 */
	public function addMix(name:String, volume:Float,  pan:Float, timeOffset)
	{
		mixes.set(name, new ReactiveBGMusicTrackSetting(volume, pan); 
	}
	
	public function setMix(name:String)
	{
		var volume:Float = mixes[name].getTrackVolume();
		if (volume => track.volume){
			track.fadeIn(0.5, track.volume, volume);
		}
		else{
			track.fadeOut(0.5, track.Volume, volume);
		}
		track.pan = mixes[name].getTrackPanning();
	}
	
	public function play()
	{
		//stop sound if already playing
		track.stop()
		//start a timer and tell it to start playing at the end of the timer
		startTimer = new FlxTimer();
		startTimer.onComplete = onCompletePlayTimer;
		startTimer.start(offset);
		
	}
	
	public function onCompletePlayTimer(Timer:FlxTimer)
	{
		track.play(false, 0.0, endPoint);
		started = true;
	}
	
	
	public function playFromLoop(globalSongLoopPoint:Float)
	{
		//stop sound if already playing
		track.stop()
		//start a timer and tell it to start playing at the end of the timer
		startTimer = new FlxTimer();
		startTimer.onComplete = onCompletePlayTimer;
		var effectiveOffset = offset - globalSongLoopPoint;
		if (effectiveOffset > 0)
		{
			startTimer.start(offset - globalSongLoopPoint);
			started = false;
		}
		else
		{
			track.play(false, -effectiveOffset, endPoint);
		}
	}
	
	public function pause(){
		if (!started){
			timeLeftAtPause = startTimer.timeLeft;
			startTimer.destroy();
		}
		else{
			timeLeftAtPause = 0;
		}
		track.pause();
	}
	
	public function resmume(){
		startTimer = new FlxTimer();
		startTimer.onComplete = onCompletePlayTimer;
		startTimer.start(timeLeftAtPause);
	}
	
	private onCompleteResumeTimer(Timer:FlxTimer){
		track.resume();
		started = true;
	}
	

}