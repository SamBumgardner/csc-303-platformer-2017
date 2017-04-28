package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;

	private var map:FlxTilemap;
	public var player:Player;
	private var platform:Platforms;
	public static var hud:HeadsUpDisplay;
<<<<<<< HEAD
	public var _pUp:FlxGroup;	
=======
	public var _pUp:FlxGroup;
	public var sprites:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

>>>>>>> 50fecc21a6da50785d4c5cebfbc65f97da209f56
	private var blockGroup:FlxTypedGroup<Block> = new FlxTypedGroup<Block>(10);
	private var mushroom:PowerUp;
	
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
		if (!player.star) 
		{
			player.kill();
		}
		
		bullet.kill();
	}
<<<<<<< HEAD
	

	
	override public function create():Void
	{
		if (hud == null)
		{
=======

	override public function create():Void
	{

		if (hud == null){
>>>>>>> 50fecc21a6da50785d4c5cebfbc65f97da209f56
			hud = new HeadsUpDisplay(0, 0, "MARIO");
		}
		super.create();

		player = new Player(50, 50);
		add(player);

		//Add player (and any other sprites) to group
		sprites.add(player);
		
		//create new moving platform
		platform =  new Platforms(250, 150, 3, 100, 100, 50, 50, player);
		platform.immovable = platform.solid = true;
		platform.allowCollisions = FlxObject.UP;
		platform.inContact = false;
		add(platform);

		add(player.hitBoxComponents);
		
		// Create and add enemies
		dtmEnemy1 = new DontTouchMe(400, 200);
		add(dtmEnemy1);
		
		bullets = new FlxTypedGroup<Bullet>(20);
		add(bullets);
		
		sentry1 = new Sentry(320, 32, bullets, player);
		add(sentry1);
<<<<<<< HEAD
		
		mushroom = new PowerUp(25, 25);
		add(mushroom);
=======
>>>>>>> 50fecc21a6da50785d4c5cebfbc65f97da209f56

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
<<<<<<< HEAD
		
		_pUp = new FlxGroup();
		createPowerUp(25, 25);
=======
    
		_pUp = new FlxGroup();
		createPowerUp(25, 25);
		createPowerUp(40,60);
>>>>>>> 50fecc21a6da50785d4c5cebfbc65f97da209f56
		add(_pUp);	
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

		FlxG.collide(map, sprites);
		
		platform.platformUpdate(elapsed, sprites, platform);

		hud.update(elapsed);

		FlxG.collide(map, player);
		FlxG.overlap(player, _pUp, getPowerup);
<<<<<<< HEAD
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
=======
>>>>>>> 50fecc21a6da50785d4c5cebfbc65f97da209f56
	}
	
	public function createPowerUp (x:Int, y:Int): Void
	{	
		var powerup:FlxSprite = new FlxSprite(x*8 + 3, y*8 + 2);
		powerup.makeGraphic(32,32, FlxColor.YELLOW);
		_pUp.add(powerup);
	}
	
	private function getPowerup(Player:FlxObject, PowerUp:FlxObject):Void
	{
		trace("PowerUp Collected");
<<<<<<< HEAD
		PowerUp.kill();	
=======
		PowerUp.kill();
		
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

>>>>>>> 50fecc21a6da50785d4c5cebfbc65f97da209f56
	}

}
