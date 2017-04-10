package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;



/**
 * ...
 * @author Keith Cissell
 */
class Sentry extends Enemy 
{
	private var trackedPlayer:Player;
	private var playerMidpoint:FlxPoint;
	
	// For periodically shooting a bullet
	private var shotClock:Float;
	
	// Group of bullets
	private var bullets:FlxTypedGroup<Bullet>;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, player:Player) 
	{
		super(X, Y, SimpleGraphic);
		
		// Initializes a basic graphic for the player
		makeGraphic(32, 32, FlxColor.BLUE);
				
		// Set class specific variables
		name = "Sentry";
		trackedPlayer = player;
		playerMidpoint = FlxPoint.get();
		shotClock = 0;
		
	}
	
	/**
	 * Creates and fires a bullet object
	 * 
	 * @param	angle The angle at which to fire the bullet.
	 */
	public function fireBullet(angle:Float)
	{
		var midpoint = getMidpoint(_point);
		var b:Bullet = new Bullet(midpoint.x, midpoint.y); //bullets.recycle(Bullet);
		b.shoot(getMidpoint(_point), angle);
	}
	
	// Returns the angle to player
	private function angleTowardPlayer():Float
	{
		return getMidpoint(_point).angleBetween(trackedPlayer.getMidpoint(playerMidpoint));
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
		// Track player location
		angle = angleTowardPlayer();
		
		// Increment shotClock
		shotClock += elapsed;
		
		if (shotClock >= 2.0)
		{
			shotClock = 0;
			fireBullet(angle);
		}
		
		super.update(elapsed);

	}
	
}