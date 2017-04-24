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
	private var currentMix:ReactiveBGMusicTrackSetting
	public function new() 
	{
		
	}
	/**
	 * Add settings for a mix
	 * @param	name
	 * @param	volume
	 * @param	pan
	 */
	public function addMix(name:String, volume:Float,  pan:Float)
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
	

}