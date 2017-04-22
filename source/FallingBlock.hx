package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import haxe.Timer;

/**
 * A block that falls after being stepped on
 * @author TR Nale
 */
class FallingBlock extends Block
{
	static public var FALLACCEL(default, never):Float = 100;
	static public var MAXSPEED(default, never):Float = 500;
	static public var DESTRUCTIONLINE(default, never):Float = 500;
	public var fallDelay:Int;
	private var isFalling:Bool;
	
	/**
	 * Constructor
	 * 
	 * @param	X	X coordinate in tilemap
	 * @param	Y	Y coordinate in tilemap
	 * @param	Delay	Time from touch until the block falls, in milliseconds
	 */
	public function new(?X:Float=0, ?Y:Float=0,?Delay:Int=1000) 
	{
		super(X, Y);
		fallDelay = Delay;
		isFalling = false;
		maxVelocity.y = MAXSPEED;
	}
	
	/**
	 * Causes block to fall after a delay when touched from the top
	 */
	override public function onTouch(touchedSide:String)
	{
		if ((touchedSide == "top") && (!isFalling))
		{
			isFalling = true;
			//creates a timer that causes the block to fall after fallDelay milliseconds
			Timer.delay(function():Void {
				acceleration.y = FALLACCEL;
			}, fallDelay);
		}
	}
	
	/**
	 * Destroys block once it falls off the screen
	 * @param	elapsed
	 */
	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (y > DESTRUCTIONLINE)
		{
			this.destroy();
		}
	}
}