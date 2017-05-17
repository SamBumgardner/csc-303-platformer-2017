package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

/**
 * ...
 * @author Caleb Breslin
 */
class PowerupMushroom extends PowerUp 
{
	private var position:FlxPoint;
	private var xSpeed:Float = -30;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, AssetPaths.Mushroom_sprite__png);
		position = getPosition();
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
	}
	
	public override function update(elapsed:Float):Void
	{	
		if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)) 
		{
			turnAround();
		}	
		super.update(elapsed);	
		
	}
	
	public function turnAround():Void
	{
		// Reverse the direction of the DontTouchMe's velocity
		xSpeed *= -1;
		velocity.x = xSpeed;
		
		// Flip the animation
		flipX = !flipX;
	}	
}