package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Keith Cissell
 */
class DontTouchMe extends Enemy 
{
	public var xAccel:Float = 30;
	public var xSlowdown:Float = 60;
	
	public var xMaxSpeed:Float = 30;
			
	public var onGround:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		// Initializes a basic graphic for the player
		makeGraphic(32, 32, FlxColor.RED);
				
		// Set class specific variables
		name = "DontTouchMe";		
		
		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
		
		// Setup movement
		maxVelocity.x = xMaxSpeed;
		groundMovement( -1);
	}
	
	/**
	 * Set the movement direction.
	 * 
	 * @param	movementDirection	-1 for moving left, 1 for moving right.
	 */
	public function groundMovement(movementDirection:Int)
	{
		// If horizontalMove is -1, the Enemy should move left.
		if (movementDirection == -1)
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
		
		// If horizontalMove is 1, the Enemy should move right.
		else if (movementDirection == 1)
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
		#if debug // Only compile this code into a debug version of the game.
		
		// Display an error message in the console if an invalid horizontalMove
		// 	value is detected.
		else
		{
			trace("ERROR: An invalid value for horizontalMove (" + 
				movementDirection + ") was passed into groundMovement()");
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
		// Check if on ground
		if (isTouching(FlxObject.DOWN))
		{
			onGround = true;
		}
		
		// Change the movement direction if it runs into a wall
		if (isTouching(FlxObject.LEFT))
		{
			groundMovement(1);
		}
		if (isTouching(FlxObject.RIGHT))
		{
			groundMovement(-1);
		}
		
		// Check if DTM is squashed
		if (isTouching(FlxObject.UP))
		{
			kill();
		}
		
		super.update(elapsed);

	}
	
}