package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;


class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;

	private var map:FlxTilemap;
	private var player:Player;
	public static var hud:HeadsUpDisplay;
	private var blockGroup:FlxTypedGroup<Block> = new FlxTypedGroup<Block>(10);
	
	// Enemies
	private var dtmEnemy1:DontTouchMe;
	private var sentry1:Sentry;
	private var bullets:FlxTypedGroup<Bullet>;
	
	/**
	 * bulletHitPlayer
	 * Logic for when a bullet overlaps with a player
	 * 
	 * @param	player	A player's character
	 * @param	bullet	A bullet sprite
	 */
	public function bulletHitPlayer(player:Player, bullet:FlxObject):Void
	{
		if (!player.star) {
			player.kill();
		}
		
		bullet.kill();
	}
	
	
	override public function create():Void
	{
		if (hud == null){
			hud = new HeadsUpDisplay(0, 0, "MARIO");
		}
		super.create();

		player = new Player(50, 50);
		add(player);
		add(player.hitBoxComponents);
		
		// Create and add enemies
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

		add(hud);
		
		blockGroup.add(new Block(3, 8, true));
		blockGroup.add(new Block(4, 8, true));
		blockGroup.add(new Block(7, 6));
		blockGroup.add(new ItemBlock(8, 6, "Fake Item"));
		blockGroup.add(new FallingBlock(9, 6));
		add(blockGroup);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		hud.update(elapsed);
		FlxG.collide(map, player);
		
		// Add overlap logic
		FlxG.overlap(blockGroup, player.hitBoxComponents, function(b:Block, obj:FlxObject) {b.onTouch(obj, player);} );
		FlxG.overlap(player, dtmEnemy1, dtmEnemy1.dtmHitResolve);
		FlxG.overlap(player, bullets, bulletHitPlayer);
		
		// Add collision logic
		FlxG.collide(blockGroup, player);
		FlxG.collide(player, sentry1);
		FlxG.collide(map, dtmEnemy1);
		FlxG.collide(map, bullets);
		FlxG.collide(blockGroup, bullets);
	}
}