package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Keith Cissell
 */
class DontTouchMe extends Enemy 
{
	private var position:FlxPoint;

	// Movement variables
	private var xAccel:Float = 30;
	private var xSlowdown:Float = 60;	
	private var xMaxSpeed:Float = 30;
		
	// Hitboxes
	public var takeDamageBox:FlxObject;
	public var giveDamageBox:FlxObject;
			
	public function new(?X:Float = 0, ?Y:Float = 0) 
	{
		super(X, Y, AssetPaths.DontTouchMe__png);
				
		name = "DontTouchMe";
		position = getPosition();
		
		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
		
		// Setup movement
		maxVelocity.x = xMaxSpeed;
		groundMovement( -1);
		
		// Set hitboxes
		takeDamageBox = new FlxObject((X + 5), Y, 22, 5);
		giveDamageBox = new FlxObject((X + 1), (Y + 5), 30, 27);
	}
	
	/**
	 * Set the movement direction.
	 * 
	 * @param	movementDirection	-1 for moving left, 1 for moving right.
	 */
	public function groundMovement(movementDirection:Int):Void 
	{
		// If horizontalMove is -1, the Enemy should move left.
		if (movementDirection == -1) {
			flipX = false;
			if (velocity.x > 0) {
				acceleration.x = -xSlowdown + -xAccel;
			}
			else {
				acceleration.x = -xAccel;
			}
		}
		
		// If horizontalMove is 1, the Enemy should move right.
		else if (movementDirection == 1) {
			flipX = true;
			if (velocity.x < 0) {
				acceleration.x = xSlowdown + xAccel;
			}
			else {
				acceleration.x = xAccel;
			}
		}
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
		// Change the movement direction if it runs into a wall
		if (isTouching(FlxObject.LEFT)) {
			groundMovement(1);
		}
		if (isTouching(FlxObject.RIGHT)) {
			groundMovement(-1);
		}
		
		// Move hitBox
		position = getPosition();
		takeDamageBox.x = position.x + 5;
		takeDamageBox.y = position.y;
		giveDamageBox.x = position.x + 1;
		giveDamageBox.y = position.y + 5;
		
		// Check if DTM is squashed
		if (isTouching(FlxObject.UP)) {
			kill();
		}
		
		super.update(elapsed);
	}
	
}