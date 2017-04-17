package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
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
	
	public var onGround:Bool = false;
	
	private var step_sound:FlxSound;

	/**
	 * Intializer
	 * 
	 * @param	X	Starting x coordinate
	 * @param	Y	Starting y coordinate
	 * @param	SimpleGraphic	Non-animating graphic. Nothing fancy (optional)
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		// Initializes a basic graphic for the player
		makeGraphic(32, 32, FlxColor.ORANGE);
		
		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
		
		// Sets the starting x max velocity.
		xMaxSpeed = walkSpeed;
		
		//set the sound animation for player movement
		step_sound = FlxG.sound.load(AssetPaths.step__wav);
	}
	
	/**
	 * Setter for the xMaxSpeed variable.
	 * Updates maxVelocity's x component to match the new value.
	 * 
	 * @param	newXSpeed	The new max speed in the x direction.
	 * @return	The new value contained in xMaxSpeed.
	 */
	public function set_xMaxSpeed(newXSpeed:Float):Float
	{
		maxVelocity.x = newXSpeed;
		return xMaxSpeed = newXSpeed;
	}
	
	/**
	 * Handles all ground movement logic.
	 * Mostly just has to set the player's acceleration to match whatever
	 * 	direction they're supposed to start moving in.
	 * 
	 * @param	isRunning		Whether the player should use its running or walking max spped.
	 * @param	horizontalMove	The direction of the player's horizontal input. -1 for left, 1 for right.
	 * @param	elapsed			Time elapsed since the last call to groundMovement in seconds.
	 */
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
		
		if (velocity.x != 0){
			//play the step sound atfer movement
			step_sound.play();
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
	
	
	/**
	 * Handles all air movement logic.
	 * Mostly just has to set the player's acceleration to match whatever
	 * 	direction they're supposed to start moving in.
	 * 
	 * Main difference from groundMovement() :
	 * It doesn't automatically slow down the player if no directional input is held.
	 * 
	 * @param	isRunning		Whether the player should use its running or walking max spped.
	 * @param	horizontalMove	The direction of the player's horizontal input. -1 for left, 1 for right.
	 * @param	elapsed			Time elapsed since the last call to groundMovement in seconds.
	 */
	private function airMovement(isRunning:Bool, horizontalMove:Int, elapsed:Float):Void
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
		
		// Determine if attempted to jump
		var attemptedJump:Bool = FlxG.keys.anyJustPressed([FlxKey.X, FlxKey.SLASH]);
		
		if (isTouching(FlxObject.DOWN))
		{
			onGround = true;
		}
		
		
		if (onGround)
		{
			if (attemptedJump)
			{
				onGround = false;
				velocity.y = -400;
			}
			else
			{
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