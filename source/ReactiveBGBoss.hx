package;

/**
 * ...
 * @author Dillon Woollums
 */
class ReactiveBGBoss extends ReactiveBGMusic
{
	private damageTrack:reactiveBGMusicTrack;
	
	/**
	 * @param	globalLooping			Does the ReactiveBGMusic class need to handle the looping for this track?
	 * @param	EmbeddedTrack 			The embedded sound object corresponding to the track you want to create	
	 * @param	OffsetInSong			How late into the overall song this track starts playing
	 * @param	OffsetInTrack			How late into the track to start playing from
	 * @param	inTrackLoopPoint		When looping what point to return to.
	 * @param	inTrackEndPoint			The point in the file where it should stop playing
	 * @param	typeOfTrack				What kind of track is this?
	 */
	public function new(globalLooping:Bool, EmbeddedTrack:FlxSoundAsset, OffsetInSong:Float = 0, OffsetInTrack:Float = 0, inTrackLoopPoint:Float = 0, inTrackEndPoint:Float = 0, typeOfTrack:ReactiveBGMusicTrackType) 
	{
		super.new(globalLooping)
		damageTrack = new ReactiveBGMusicTrack(EmbeddedTrack, OffsetInSong, OffsetInTrack, inTrackLoopPoint, inTrackEndPoint, globalLooping, typeOfTrack);
		damageTrack.addMix("Normal", 0, 0.5);
		damageTrack.addMix("BossWeak", 0.2, 0.5);
		damageTrack.addMix("BossDamage", 1, 0.5);
		
	}
	
	public function bossBeingDamaged(){
		damageTrack.setMix("BossDamage");
		setMix("BossDamage");
	}
	
	public function returnToNormal(){
		damageTrack.setMix("Normal");
		setMix("Normal");
	}
	
	public function bossWeak(){
		damageTrack.setMix("BossWeak");
		setMix("BossDamage");
	}
	
}
