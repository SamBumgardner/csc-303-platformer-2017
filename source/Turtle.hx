package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Keith Cissell
 */
class Turtle extends Enemy 
{
	private var turtPosition:FlxPoint;
	private var xSpeed:Float = -30;
	
	// Hitboxes
	public var takeDamageBox:FlxObject;
	private var tdbHeight:Float = 22;
	private var tdbWidth:Float = 5;
	private var tdbXoffset:Float = 5;
	private var tdbYoffset:Float = 0;
	
	public var giveDamageBox:FlxObject;
	private var gdbHeight:Float = 30;
	private var gdbWidth:Float = 27;
	private var gdbXoffset:Float = 2;
	private var gdbYoffset:Float = 5;

	/**
	 * Intializer
	 *
	 * @param	X	Starting x coordinate
	 * @param	Y	Starting y coordinate
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
		
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
	 * turtHitResolve
	 * Logic for who takes damage if a player and a DTM overlap
	 * 
	 * @param	player	A player's character
	 * @param	dtm		A Turtle enemy
	 */
	public function turtHitResolve(player:Player, turt:Turtle):Void
	{
		if (player.overlaps(turt.giveDamageBox)) {
			if (player.star) {
				turt.kill();
			} else {
				player.kill();
			}
		} else if (player.overlaps(turt.takeDamageBox)) {
			turt.kill();
		}
	}
	
	/**
	 * kill
	 * extends the kill function to drop a shell when the turtle is killed
	 */
	public override function kill():Void
	{
		super.kill();
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
		
		// Move hitBox
		turtPosition = getPosition();
		takeDamageBox.x = turtPosition.x + tdbXoffset;
		takeDamageBox.y = turtPosition.y + tdbYoffset;
		giveDamageBox.x = turtPosition.x + gdbXoffset;
		giveDamageBox.y = turtPosition.y + gdbYoffset;
	}
	
}