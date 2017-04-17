package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;


class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;
	
	private var map:FlxTilemap;
	private var player:Player;
	
	// Enemies
	private var dtmEnemy1:DontTouchMe;
	private var sentry1:Sentry;
	private var bullets:FlxTypedGroup<Bullet>;
	
	/**
	 * enemyHitPlayer
	 * 
	 * @param	
	 */
	public function enemyHitPlayer(player:Player, enemy:Enemy):Void
	{
		if (player.star) {
			//enemy.takeHit();
			enemy.kill();
		} else{
			//player.takeHit();
			player.kill();
		}
	}
	
	/**
	 * playerHitEnemy
	 * 
	 * @param	
	 */
	public function playerHitEnemy(player:Player, enemy:Enemy):Void
	{
		//enemy.takeHit();
		enemy.kill();
	}
	
	/**
	 * bothTakeHit
	 * 
	 * @param	
	 */
	public function projectileHitPlayer(player:Player, projectile:FlxObject):Void
	{
		if (!player.star) {
			//player.takeHit();
			player.kill();
		}		
		
		//projectile.takeHit();
		projectile.kill();
	}
	
	/**
	 * trapHitPlayer
	 * 
	 * @param	
	 */
	public function trapHitPlayer(player:Player, trap:FlxObject):Void
	{
		if (!player.star) {
			//player.takeHit();
			player.kill();
		}
	}

	
	override public function create():Void
	{
		super.create();
		
		player = new Player(50, 50);
		add(player);
		
		dtmEnemy1 = new DontTouchMe(400, 200);
		add(dtmEnemy1);
		
		bullets = new FlxTypedGroup<Bullet>(20);
		add(bullets);
		sentry1 = new Sentry(320, 32, bullets, player);
		add(sentry1);
		
		
		map = new FlxTilemap();
		map.loadMapFromArray([
			1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,
			1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,
			1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,
			1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,
			1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			20, 15, AssetPaths.tiles__png, 32, 32);
		add(map);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(map, player);
		FlxG.collide(player, sentry1);
		FlxG.collide(map, dtmEnemy1);
		FlxG.collide(map, bullets);
		
		FlxG.overlap(player, dtmEnemy1, enemyHitPlayer);		
		FlxG.overlap(player, bullets, projectileHitPlayer);
	}
}