package;

/**
 * ...
 * @author Dillon Woollums
 */
class ReactiveBGMusicTrackSetting
{
	private var trackVolume:Float;
	private var trackPan:Float;
	/**
	 * Defines the settings for a track
	 * @param	volume The volume of the track [0,1]
	 * @param	pan The panning of the track [0,1]
	 */
	public function new( volume:Float, pan:Float) 
	{
		trackVolume = volume;
		trackPan = pan;
	}
	
	
	public function getTrackVolume(){
		return trackVolume;
	}
	
	public function getTrackPanning(){
		return trackPan;
	}
	
}