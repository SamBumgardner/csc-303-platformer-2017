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
	 * @param	SimpleGraphic	Non-animating graphic.
	 * @param	Breakable	Whether the block breaks when hit from below; defaults to false
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, ?Delay:Int=1000) 
	{
		super(X, Y, SimpleGraphic);
		fallDelay = Delay;
		isFalling = false;
		maxVelocity.y = MAXSPEED;
	}
	
	/**
	 * Causes block to fall after a delay when touched from the top
	 */
	override public function onTouch()
	{
		color = FlxColor.YELLOW;
		if (!isFalling)
		{
			isFalling = true;
			//creates a timer that causes the block to fall after fallDelay milliseconds
			Timer.delay(function():Void {
				immovable = false;
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