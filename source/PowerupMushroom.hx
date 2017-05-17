package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;

/**
 * ...
 * @author Caleb Breslin
 */
class PowerupMushroom extends PowerUp 
{
	private var xSpeed:Float = 50;

	/**
	 * Initializes the graphic for the powerup, and adds acceleration and gravity
	 * @param	X - x coordinate of the powerup
	 * @param	Y - y coordinate of the powerup
	 * @param	SimpleGraphic - graphic to hold the visual elements of the powerup
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		// Instantiate the powerup
		super(X, Y, AssetPaths.Mushroom_sprite__png);
		// Apply gravity and horizontal motion
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;
		velocity.x = xSpeed;
	}
	
	/**
	 * Executes when the player comes in contact with this powerup, collecting it.
	 * @param	Player - player game object
	 * @param	PowerUp - powerup game object
	 */
	public function getPowerup(Player:FlxObject, PowerUp:FlxObject):Void
	{
		// Gives the player 2 units of health, and kills the powerup when it is collected
		Player.health = 2;
		PowerUp.kill();
	}
	
	public override function update(elapsed:Float):Void
	{	
		// Changes the direction of the powerup if it hits a wall
		if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT)) 
		{
			turnAround();
		}	
		super.update(elapsed);	
		
	}
	
	/**
	 * Changes the powerup's direction when it hits a wall
	 */
	public function turnAround():Void
	{
		// Reverse the direction of the DontTouchMe's velocity
		xSpeed *= -1;
		velocity.x = xSpeed;
		
		// Flip the animation
		flipX = !flipX;
	}	
}
