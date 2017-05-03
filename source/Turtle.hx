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
	
	
	// Is turtle in its shell?
	public var hiding:Bool = false;

	/**
	 * Intializer
	 *
	 * @param	X	Starting x coordinate
	 * @param	Y	Starting y coordinate
	 */
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y, AssetPaths.Turtle__png);
		
		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
		
		// Initialize X movement
		velocity.x = xSpeed;
		
		// Add walking animation
		loadGraphic(AssetPaths.Turtle__png, true, 18, 30);
		animation.add("walk", [0], 1);
		
		animation.play("walk");
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
	 * Logic for who takes damage if a player and a Turtle overlap
	 * 
	 * @param	player	A player's character
	 * @param	dtm		A Turtle enemy
	 */
	public function playerHitResolve(player:Player, turt:Turtle):Void
	{
		if (hiding) {
			FlxG.collide(player, turt);
			if (player.star) { turt.kill(); }
			//else { player.kill(); }
		} else {
			if (turt.overlaps(player.topBox)) {
				if (player.star) {
					turt.kill();
				} else {
					player.kill();
				}
			} else if (turt.overlaps(player.btmBox)) {
				turt.hide();
				player.bounce();
			}
		}
	}
	
	/**
	 * enemyHitResolve
	 * Logic for who takes damage if an enemy and a Turtle overlap
	 * 
	 * @param	enemy	A player's character
	 * @param	dtm		A Turtle enemy
	 */
	public function enemyHitResolve(enemy:Enemy, turt:Turtle):Void
	{
		if (hiding) {
			if (velocity.x != 0) { enemy.kill(); }
		} else {
			FlxG.collide(enemy, turt);
		}
	}
	
	/**
	 * hide
	 * Turtle retreats into its shell
	 */
	public function hide():Void
	{
		// Go into shell
		hiding = true;
		velocity.x = 0;
		xSpeed *= 5;
		
		// Add shell animation
		loadGraphic(AssetPaths.Shell__png, true, 19,  12);
		animation.add("hide", [0], 1);		
		animation.play("hide");
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
		// Check if DTM is hit from above
		if (isTouching(FlxObject.UP)) {
			if (hiding) {
				velocity.x = 0;
			} else {
				hide();
			}
		}
		
		// Change the movement direction if it runs into an object
		if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)) {
			turnAround();
		}
		
		super.update(elapsed);
	}
	
}