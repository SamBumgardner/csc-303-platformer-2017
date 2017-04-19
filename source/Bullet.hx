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
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y, AssetPaths.cannon_ball__png);
		// Note: can also use bullet__png as image
	}
	
	/**
	 * Shoot Bullet
	 * 
	 * Angles the bullet and launches in that direction
	 * 
	 * @param	location	where the bullet is launching from
	 * @param	launchAngle angle to launch the bullet at
	 */
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
		// Check if bullet hit any object
		if (isTouching(FlxObject.ANY)) {
			kill();
		}
		
		super.update(elapsed);

	}
	
}