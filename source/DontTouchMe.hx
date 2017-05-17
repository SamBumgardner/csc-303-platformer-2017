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
	private var dtmPosition:FlxPoint;
	private var xSpeed:Float = -30;
	
	
		
	/**
	 * Intializer
	 *
	 * @param	X	Starting x coordinate
	 * @param	Y	Starting y coordinate
	 */
	public function new(?X:Float = 0, ?Y:Float = 0) 
	{
		super(X, Y, AssetPaths.DontTouchMe__png);
				
		name = "DontTouchMe";
		dtmPosition = getPosition();
		
		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
		
		// Initialize X movement
		velocity.x = xSpeed;
	}
	
	/**
	 * Turns the enemy around if it runs into an object
	 */
	public function turnAround():Void
	{
		// Reverse the direction of the DontTouchMe's velocity
		xSpeed *= -1;
		velocity.x = xSpeed;
		
		// Flip the animation
		flipX = !flipX;
	}
	
	/**
	 * playerHitResolve
	 * Logic for who takes damage if a player and a DTM overlap
	 * 
	 * @param	player	A player's character
	 * @param	dtm		A DontTouchMe enemy
	 */
	static public function playerHitResolve(player:Player, dtm:DontTouchMe):Void
	{
		if (dtm.overlaps(player.topBox)) {
			if (player.star) {
				dtm.kill();
			} else {
				player.kill();
			}
		} else if (dtm.overlaps(player.btmBox)) {
			dtm.kill();
			player.bounce();
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
		// Check if DTM is squashed
		if (isTouching(FlxObject.UP)) {
			kill();
		}
		
		// Change the movement direction if it runs into an object
		if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)) {
			turnAround();
		}
		
		super.update(elapsed);
	}
	
}