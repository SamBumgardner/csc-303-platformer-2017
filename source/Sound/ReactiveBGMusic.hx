package;

/**
 * ...
 * @author Dillon Woollums
 */
class ReactiveBGMusic
{
	private var tracks:List<FlxSound>
	
	private var globalLoopPoint:Float;
	private var needsGlobalLooping:Bool;
	private var currentLoopTimer:FlxTimer;
	private var paused:Bool;

	public function new() 
	{
		paused = false;
		
	}
	
	public function play()
	{
		if (!paused){
			for (track:tracks)
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
		playFromLoop();
	}
	
	public function playFromLoop()
	{
		for (track:tracks){
			track.playFromLoop(globalLoopPoint);
		}
	}
	
	public function stop()
	{
		if (needsGlobalLooping){
			currentLoopTimer.destroy();
		}
		for (track:tracks){
			track.stop();
		}
		paused = false;
	}
	
	public function pause()
	{
		for (track:tracks){
			track.pause();
		}
		paused = true;
	}
	
	public function resmume()
	{
		for (track:tracks){
			track.resume;
		}
	}
	
	public function addTrack(track:ReactiveBGMusicTrack)
	{
		tracks.add(track);
	}
	
	
	
}