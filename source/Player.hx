package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;

/**
 * ...
 * @author Sam Bumgardner
 */
class Player extends FlxSprite 
{
	public var xAccel:Float = 400;
	public var xMaxSpeed(default, set):Float;
	
	/*	when pressing jump, the player will have thrust at the jumpSpeed
		for a maximum of jumpThrustTime*/ 
	public var jumpSpeed:Float = -300; //velocity at which player jumps.
	public var jumpThrustTime:Float = 0.35; //time thrust is applied to player
	public var jumpReleased:Bool = true; //button was released while on the ground
	public var stoppedJumping = true; // if the a button was released while jumping.
	public var jumpStartedTime:FlxTimer; //timer to limit jump time
	
	public var walkSpeed:Float = 100;
	public var runSpeed:Float = 250;
	
	public var xSlowdown:Float = 600;
	
	public var onGround:Bool = false;


	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		jumpStartedTime = new FlxTimer();
		jumpStartedTime.start(jumpThrustTime);
		// Initializes a basic graphic for the player
		makeGraphic(32, 32, FlxColor.ORANGE);
		
		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
		
		// Sets the starting x max velocity.
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
		
		// If horizontalMove is -1, the Player should move left.
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
		
		// If horizontalMove is 1, the Player should move right.
		else if (horizontalMove == 1)
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
		else if (horizontalMove == 0)
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
		#if debug // Only compile this code into a debug version of the game.
		
		// Display an error message in the console if an invalid horizontalMove
		// 	value is detected.
		else
		{
			trace("ERROR: An invalid value for horizontalMove (" + 
				horizontalMove + ") was passed into groundMovement()");
		}
		
		#end // End of the conditional compilation section.
	}
	
	private function airMovement(isRunning:Bool, horizontalMove:Int, elapsed:Float):Void
	{
		var holdingJump:Bool =  FlxG.keys.anyPressed([FlxKey.X, FlxKey.SLASH]);
		jumpReleased = false;
	// Change max speed if the player is running
		if (!jumpStartedTime.finished && holdingJump && !stoppedJumping){
			velocity.y = jumpSpeed;
		}
		else{
			stoppedJumping = true;
		}
		
		if (isRunning)
		{
			xMaxSpeed = runSpeed;
		}
		else
		{
			xMaxSpeed = walkSpeed;
		}
		
		// If horizontalMove is -1, the Player should move left.
		if (horizontalMove == -1)
		{
				acceleration.x = -xAccel;
		}
		
		// If horizontalMove is 1, the Player should move right.
		else if (horizontalMove == 1)
		{
			acceleration.x = xAccel;
		}
		
		// Stop horizontal acceleration if no direction held
		else if (horizontalMove == 0)
		{
			acceleration.x = 0;
		}
		
		#if debug // Only compile this code into a debug version of the game.
		
		// Display an error message in the console if an invalid horizontalMove
		// 	value is detected.
		else
		{
			trace("ERROR: An invalid value for horizontalMove (" + 
				horizontalMove + ") was passed into airMovement()");
		}
		
		#end // End of the conditional compilation section.
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
		
		
		var attemptedJump:Bool = false; //declare attempted jump
		
		if (isTouching(FlxObject.DOWN))
		{
			onGround = true;
			// Determine if attempted to jump
			if (!FlxG.keys.anyPressed([FlxKey.X, FlxKey.SLASH])){
			jumpReleased = true;
		}
		attemptedJump= FlxG.keys.anyPressed([FlxKey.X, FlxKey.SLASH]);
		}
		
		
		if (onGround)
		{
			if (attemptedJump && jumpReleased)
			{
				onGround = false;
				stoppedJumping = false;
				velocity.y = jumpSpeed;
				jumpStartedTime.reset();
			}
			else
			{
				stoppedJumping = true;
				groundMovement(isRunning, horizontalMove, elapsed);
			}
		}
		else
		{
			airMovement(isRunning, horizontalMove, elapsed);
		}
		
		super.update(elapsed);
		
		onGround = false;
	}
	
}