package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
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
	private var _map:FlxOgmoLoader;
	private var _mGround:FlxTilemap;
	public var player:Player;
	private var flagpole:FlagPole;
	private var platform:Platforms;
	private var trap:Trap;
 	private var coins:FlxGroup;
	private var flag_x_loc:Int = 37;
	private var flag_y_loc:Int = 11;

	public static var hud:HeadsUpDisplay;

	public var sprites:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

	private var blockGroup:FlxTypedGroup<Block> = new FlxTypedGroup<Block>();
	
	// Enemies
	private var dtmEnemy:DontTouchMe;
	private var dtmGroup:FlxTypedGroup<DontTouchMe> = new FlxTypedGroup<DontTouchMe>();
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
		super.create();

		//create new moving platform
		//platform =  new Platforms(250, 150, 3, 100, 100, 50, 50, player);
		//platform.immovable = platform.solid = true;
		//platform.allowCollisions = FlxObject.UP;
		//platform.inContact = false;
		//add(platform);

		//add(player.hitBoxComponents);
		
		//Coins are added to a group, coin group added to playstate
		//coins = new FlxGroup();
		//coins.add(new Coin(8, 8, "red"));
		//coins.add(new Coin(9, 8, "yellow"));
		//coins.add(new Coin(9, 9, "yellow"));
		//add(coins);
		
		// Create and add enemies
		//dtmEnemy1 = new DontTouchMe(32*13, 32*11);
		//add(dtmEnemy1);
		
		bullets = new FlxTypedGroup<Bullet>(20);
		add(bullets);
		
		//sentry1 = new Sentry(320, 32, bullets, player);
		//add(sentry1);


		//Create a new Trap
		//trap = new Trap(320,256);
		
		//Building the Trap and its subsections by adding them to their own FlxGroup
		//trap.buildTrap(trap);

		//Adding the whole Trap, subsections and all to the playstate
		//add(trap._grpBarTrap);	

		//Placing the trap into the playstate centered at specified location (x, y)
		//trap.placeTrap(trap._grpBarTrap, 320, 256);
		
		_map = new FlxOgmoLoader(AssetPaths.CSC303_Level__oel);
		_mGround = _map.loadTilemap(AssetPaths.overworld__png, 16, 16, "Overworld");
		_mGround.follow();
		_mGround.setTileProperties(2, FlxObject.ANY);
		add(_mGround);
		_map.loadEntities(placeEntities, "Entities");
		
		FlxG.camera.setScrollBoundsRect(0, 0, _mGround.width, _mGround.height);
		FlxG.worldBounds.set(0, 0, _mGround.width, _mGround.height);
		FlxG.camera.follow(player, LOCKON, 2);
		
		add(blockGroup);
		add(dtmGroup);
		
		hud = new HeadsUpDisplay(0, 0, "MARIO");
		add(hud);
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "Player")
		{
			player = new Player(x, y);
			add(player);
			sprites.add(player);
		}
		
		else if (entityName == "DontTouchMe")
		{
			sprites.add(dtmGroup.add(new DontTouchMe(x, y)));
		}
		
		else if (entityName == "Sentry")
		{
			sentry1 = new Sentry(x, y, bullets, player);
			add(sentry1);
			sprites.add(sentry1);
		}
		
		else if (entityName == "Block")
		{
			var type:Int = Std.parseInt(entityData.get("BlockType"));
			if (type == 2)
			{
				blockGroup.add(new ItemBlock(x, y, "Fake Item"));
			}
			else
			{
				blockGroup.add(new Block(x, y, true));
			}
		}
		
		else if (entityName == "Flagpole")
		{
			flagpole = new FlagPole(x, y);
			add(flagpole);
			add(flagpole.flag);
		}
		
		else if (entityName == "Lava")
		{
			
		}
		
		else if (entityName == "Fire Bar")
		{
			
		}
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		//When player overlaps a coin, the coin is destroyed
		FlxG.overlap(player, coins, collectCoin);
		FlxG.collide(_mGround, sprites);
		
		//platform.platformUpdate(elapsed, sprites, platform);

		hud.update(elapsed);


		// Add overlap logic
		FlxG.overlap(blockGroup, player.hitBoxComponents, function(b:Block, obj:FlxObject) {b.onTouch(obj, player);} );
		FlxG.overlap(player, dtmGroup, DontTouchMe.dtmHitResolve);
		FlxG.overlap(player, bullets, bulletHitPlayer);
		//FlxG.overlap(player, trap._grpBarTrap, trap.playerTrapResolve);
		
		// Add collision logic
		FlxG.collide(blockGroup, player);
		FlxG.collide(player, sentry1);
		FlxG.collide(_mGround, bullets);
		FlxG.collide(blockGroup, bullets);
    
   		if (!flagpole.level_over()){
			FlxG.overlap(player, flagpole, flagpole.win_animation);
		} else {
			//kill all enemies and bullets on screen. Deactivate cannons
			bullets.forEachAlive(function(bullet:Bullet){bullet.kill(); });
			dtmGroup.forEachAlive(function(dtm:DontTouchMe){ dtm.kill(); });
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
