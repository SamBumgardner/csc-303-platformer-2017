package;

/**
 * ...
 * @author Dillon Woollums
 */
class ReactiveBGMusicMixes 
{
	//stores the different mixes for a ReactiveBGMusic object
	private var mixes:Map<String,Map<Int,Float>>;
	
	public function new() 
	{
	}
	/**
	 * Adds a mix to the container.
	 * @param	name The name of the mix to add.
	 * @param	mix A map of tracks to an array containing the volume at 0 and the pan at 1.
	 * 
	 */
	public function addMix(name:String, mix:Map<Int,Array<Float>>)
	{
		mixes.set(name, mix);
	}
	
	public function getMix(mixName:String)
	{
		return mixes[mixName];
	}
}