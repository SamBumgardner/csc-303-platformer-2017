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
	// For player tracking
	private var trackedPlayer:Player;
	private var playerMidpoint:FlxPoint;
	
	// For shooting bullets
	private var shotClock:Float = 0.0;
	private var reloadTime:Float = 3.5;
	private var bullets:FlxTypedGroup<Bullet>;

	public function new(?X:Float=0, ?Y:Float=0, blts:FlxTypedGroup<Bullet>, player:Player) 
	{
		super(X, Y, AssetPaths.Sentry__png);
		
		name = "Sentry";
		trackedPlayer = player;
		playerMidpoint = FlxPoint.get();
		bullets = blts;
	}
	
	/**
	 * Creates and fires a bullet
	 * 
	 * @param	angle The angle at which to fire the bullet.
	 */
	public function fireBullet(angle:Float):Void
	{
		var midpoint = getMidpoint(_point);
		var b:Bullet = bullets.recycle(Bullet);
		b.shoot(midpoint, angle);
	}
	
	/**
	 * Returns the angle towards the player
	 */	
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
		
		// Shoot bullet if shotClock time excedes reloadTime
		if (shotClock >= reloadTime) {
			shotClock = 0.0;
			fireBullet(angle);
		}
		
		super.update(elapsed);

	}
	
}