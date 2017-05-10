package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;


class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;

	private var map:FlxTilemap;
	public var player:Player;
	private var flagpole:FlagPole;
	private var platform:Platforms;
	private var trap:Trap;
 	private var coins:FlxGroup;
  private var flag_x_loc:Int = 17;
	private var flag_y_loc:Int = 11;

	public static var hud:HeadsUpDisplay;

	public var sprites:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

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
		//if (hud == null){
			hud = new HeadsUpDisplay(0, 0, "MARIO");
		//}
		super.create();
    
    		/*Create the flagpole at the end of the level 
		 * This will also instantiate the flag
		 * flag_x_loc is the number of blocks to the right where we want the flag
		 * flag_y_loc is the number of blocks down we want the flag
		*/
		flagpole = new FlagPole(32*flag_x_loc, 32*flag_y_loc);
		add(flagpole);
		add(flagpole.flag);

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
		
		//Coins are added to a group, coin group added to playstate
		coins = new FlxGroup();
		coins.add(new Coin(8, 8, "red"));
		coins.add(new Coin(9, 8, "yellow"));
		coins.add(new Coin(9, 9, "yellow"));
		add(coins);
		
		// Create and add enemies
		dtmEnemy1 = new DontTouchMe(400, 200);
		add(dtmEnemy1);
		
		bullets = new FlxTypedGroup<Bullet>(20);
		add(bullets);
		
		sentry1 = new Sentry(320, 32, bullets, player);
		add(sentry1);


		//Create a new Trap
		trap = new Trap(320,256);
		
		//Building the Trap and its subsections by adding them to their own FlxGroup
		trap.buildTrap(trap);

		//Adding the whole Trap, subsections and all to the playstate
		add(trap._grpBarTrap);	

		//Placing the trap into the playstate centered at specified location (x, y)
		trap.placeTrap(trap._grpBarTrap, 320, 256);



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
		
		FlxG.collide(map, player);
		
		//When player overlaps a coin, the coin is destroyed
		FlxG.overlap(player, coins, collectCoin);
		FlxG.collide(map, sprites);
		
		platform.platformUpdate(elapsed, sprites, platform);

		hud.update(elapsed);

		FlxG.collide(map, player);

		// Add overlap logic
		FlxG.overlap(blockGroup, player.hitBoxComponents, function(b:Block, obj:FlxObject) {b.onTouch(obj, player);} );
		FlxG.overlap(player, dtmEnemy1, dtmEnemy1.dtmHitResolve);
		FlxG.overlap(player, bullets, bulletHitPlayer);
		FlxG.overlap(player, trap._grpBarTrap, trap.playerTrapResolve);
		
		// Add collision logic
		FlxG.collide(blockGroup, player);
		FlxG.collide(player, sentry1);
		FlxG.collide(map, dtmEnemy1);
		FlxG.collide(map, bullets);
		FlxG.collide(blockGroup, bullets);
    
   		if (!flagpole.level_over()){
			FlxG.overlap(player, flagpole, flagpole.win_animation);
		} else {
			//kill all enemies and bullets on screen. Dactivate cannons
			bullets.forEachAlive(function(bullet:Bullet){bullet.kill(); });
			dtmEnemy1.kill();
			sentry1.active = false;
			// time (seconds), callback, loops
			new FlxTimer().start(10, resetLevel, 1);
		}
	}
  
  	/**
	 * 
	 * @param	p Player object collecting coin
	 * @param	c Coin object getting collected
	 */
	private function collectCoin(p:Player, c:Coin):Void
	{
		p.scoreCoin(c.coinColor);
		hud.handleScoreUpdate(p.scoreTotal);
		hud.handleCoinsUpdate(p.coinCount);
		c.kill();
  }

	private function resetLevel(Timer:FlxTimer):Void
	{
		FlxG.resetState();
	}
}