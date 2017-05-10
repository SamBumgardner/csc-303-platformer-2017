package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Keith Cissell
 */
class FlyingTurtle extends Turtle 
{
	private var hoverHieght:Float;
	private var flying:Bool = true;
	private var vulnerable:Bool = false;

	
	/**
	 * Intializer
	 *
	 * @param	X		Starting x coordinate
	 * @param	Y		Starting y coordinate
	 * @param	graphic	an image used for the turtle
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?graphic = AssetPaths.FlyingTurtle__png) 
	{
		super(X, Y, graphic);
		
		// Set flying height
		hoverHieght = Y;
		
		// Lower Y acceleration variable while flying
		acceleration.y = acceleration.y * .3;
		
		// Add flying animation
		loadGraphic(AssetPaths.FlyingTurtle__png, true, 26, 30);
		animation.add("fly", [0], 1);		
		animation.play("fly");
	}
	
	/**
	 * playerHitResolve
	 * Logic for who takes damage if a player and a Turtle overlap
	 * 
	 * @param	player	A player's character
	 * @param	turt	A Turtle enemy
	 */
	override public function playerHitResolve(player:Player, turt:Turtle):Void
	{
		if (flying) {	// The turtle is flying in the air
			if (turt.overlaps(player.topBox)) {
				if (player.star) {
					turt.kill();
				} else {
					player.kill();
				}
			} else if (turt.overlaps(player.btmBox)) {
				turt.fall();
				player.bounce();
			}
		} else if (vulnerable) {	// The player is walking
			super.playerHitResolve(player, turt);
		}
	}
	
	/**
	 * fall
	 * The turtle looses its wings and becomes a normal turtle
	 */
	override public function fall():Void
	{
		flying = false;
		
		// Add walking animation
		loadGraphic(AssetPaths.Turtle__png, true, 18, 30);
		animation.add("walk", [0], 1);
		animation.play("walk");
		
		// Reset Y acceleration
		acceleration.y = (cast FlxG.state).GRAVITY;
		super.fall();
		
		// Set a half second delay before the walking turtle can be "hit" again
		haxe.Timer.delay(makeVulnerable, 500);
	}
	
	/**
	 * makeVulnerable
	 * Change the state of the turtles vulnerability to true
	 */
	private function makeVulnerable()
	{
		vulnerable = true;
	}
	
	/**
	 * flapWings
	 * Gives the turtle an upward boost of velocity
	 */
	private function flapWings()
	{
		velocity.y = -150;
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
		super.update(elapsed);
		
		var midpoint = getMidpoint(_point);
		if (flying && midpoint.y > hoverHieght) {
			flapWings();
		}
	}
	
}