package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Keith Cissell
 */
class Bullet extends FlxSprite 
{
	private var speed:Int = 225;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		// Initializes a basic graphic for the player
		makeGraphic(2, 6, FlxColor.RED);
		
	}
	
	public function shoot(?location:FlxPoint, ?launchAngle:Float):Void
	{
		super.reset(location.x - width / 2, location.y - height / 2);
		angle = launchAngle;
		_point.set(0, -speed);
		_point.rotate(FlxPoint.weak(0, 0), launchAngle);
		velocity.x = _point.x;
		velocity.y = _point.y;
	}
	
	/**
	 * Update function.
	 * 
	 * Responsible for parsing input and handing those inputs off to whatever functions
	 * need them to operate correctly.
	 * 
	 * @param	elapsed	Time passed since last call to update in seconds.
	 */
	public override function update(elapsed:Float):Void
	{		
		// Check if bullet hit wall/ground
		if (isTouching(FlxObject.ANY)) 
		{
			kill();
		}
		
		super.update(elapsed);

	}
	
}