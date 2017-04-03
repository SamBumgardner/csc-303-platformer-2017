package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

/**
 * ...
 * @author Sam Bumgardner
 */
class Player extends FlxSprite 
{
	public var xAccel:Float = 400;
	public var xMaxSpeed(default, set):Float;
	
	public var walkSpeed:Float = 100;
	public var runSpeed:Float = 200;
	
	public var xSlowdown:Float = 600;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(32, 32, FlxColor.BLUE);
		
		xMaxSpeed = walkSpeed;
	}
	
	public function set_xMaxSpeed(newXSpeed:Float):Float
	{
		maxVelocity.x = newXSpeed;
		return xMaxSpeed = newXSpeed;
	}
	
	private function groundMovement(isRunning:Bool, horizontalMove:Int, elapsed:Float):Void
	{
		// Change max speed if the player is running
		if (isRunning)
		{
			xMaxSpeed = runSpeed;
		}
		else
		{
			xMaxSpeed = walkSpeed;
		}
		
		// Moving Left
		if (horizontalMove == -1)
		{
			if (velocity.x > 0)
			{
				acceleration.x = -xSlowdown + -xAccel;
			}
			else
			{
				acceleration.x = -xAccel;
			}
		}
		
		// Moving Right
		if (horizontalMove == 1)
		{
			if (velocity.x < 0)
			{
				acceleration.x = xSlowdown + xAccel;
			}
			else
			{
				acceleration.x = xAccel;
			}
		}
		
		// Slow down if no direction held
		if (horizontalMove == 0)
		{
			if (velocity.x > 0)
			{
				if (velocity.x <= xSlowdown * elapsed)
				{
					velocity.x = 0;
					acceleration.x = 0;
				}
				else
				{
					acceleration.x = -xSlowdown;
				}
			}
			else if (velocity.x < 0)
			{
				if (velocity.x >= -xSlowdown * elapsed)
				{
					velocity.x = 0;
					acceleration.x = 0;
				}
				else
				{
					acceleration.x = xSlowdown;
				}
			}
		}
	}
	
	public override function update(elapsed:Float):Void
	{
		// Determine if running
		var isRunning:Bool = FlxG.keys.anyPressed([FlxKey.Z, FlxKey.PERIOD]);
		
		// Determine direction of movement
		var horizontalMove:Int = 0;
		
		if (FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.A]))
		{
			horizontalMove--;
		}
		if (FlxG.keys.anyPressed([FlxKey.RIGHT, FlxKey.D]))
		{
			horizontalMove++;
		}
		
		groundMovement(isRunning, horizontalMove);
		
		super.update(elapsed);
	}
	
}