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
	public var trapGroup:FlxTypedGroup<Trap> = new FlxTypedGroup<Trap>();
	private var blockGroup:FlxTypedGroup<Block> = new FlxTypedGroup<Block>();
	private var platformGroup:FlxTypedGroup<Platforms> = new FlxTypedGroup<Platforms>();
	
	
	// Enemies
	private var dtmEnemy:DontTouchMe;
	private var dtmGroup:FlxTypedGroup<DontTouchMe> = new FlxTypedGroup<DontTouchMe>();
	private var turEnemy:Turtle;
	private var turGroup:FlxTypedGroup<Turtle> = new FlxTypedGroup<Turtle>();
	private var flyingEnemy:FlyingTurtle;
	private var flyingGroup:FlxTypedGroup<FlyingTurtle> = new FlxTypedGroup<FlyingTurtle>();
	private var sentry1:Sentry;
	private var bullets:FlxTypedGroup<Bullet>;
	
	override public function create():Void
	{
		super.create();
		
		coins = new FlxGroup();
		
		bullets = new FlxTypedGroup<Bullet>(20);
		add(bullets);
		
		//Loading the map created in Ogmo Editor
		_map = new FlxOgmoLoader(AssetPaths.CSC303_Level__oel);
		_mGround = _map.loadTilemap(AssetPaths.overworld__png, 16, 16, "Overworld");
		_mGround.follow();
		_mGround.setTileProperties(2, FlxObject.ANY);
		add(_mGround);
		_map.loadEntities(placeEntities, "Entities");
		
		//Camera will follow player as they get closer to edges of screen
		FlxG.camera.setScrollBoundsRect(0, 0, _mGround.width, _mGround.height);
		FlxG.worldBounds.set(0, 0, _mGround.width, _mGround.height);
		FlxG.camera.follow(player, LOCKON, 2);
		
		//Add Groups to map
		add(blockGroup);
		add(dtmGroup);
		add(turGroup);
		add(flyingGroup);
		add(platformGroup);
		
		hud = new HeadsUpDisplay(0, 0, "MARIO");
		add(hud);
	}
	
	/**
	 * This function reads the Ogmo Level file and places the different entities based on position and
	 * type in Ogmo Editor
	 * @param	entityName Object name placed in Ogmo Editor
	 * @param	entityData Any data associated with object. Mostly just X and Y coords
	 */
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		//Logic for adding adding the player
		if (entityName == "Player")
		{
			player = new Player(x, y);
			add(player);
			sprites.add(player);
		}
		
		//Logic for adding the DontTouchMes
		else if (entityName == "DontTouchMe")
		{
			dtmEnemy = new DontTouchMe(x, y);
			dtmEnemy.turnAround();
			sprites.add(dtmGroup.add(dtmEnemy));
		}
		
		//Logic for adding the sentries
		else if (entityName == "Sentry")
		{
			sentry1 = new Sentry(x, y, bullets, player);
			add(sentry1);
			sprites.add(sentry1);
		}
		
		//Logic for adding the Blocks
		else if (entityName == "Block")
		{
			var type:Int = Std.parseInt(entityData.get("BlockType"));
			if (type == 2)
			{
				blockGroup.add(new ItemBlock(x, y, "Fake Item"));
			}
			else if (type == 3)
			{
				blockGroup.add(new FallingBlock(x, y, 200));
			}
			else
			{
				blockGroup.add(new Block(x, y, true));
			}
		}
		
		//Logic for adding the ending Flagpole
		else if (entityName == "Flagpole")
		{
			flagpole = new FlagPole(x, y);
			add(flagpole);
			add(flagpole.flag);
		}
		
		//Logic for adding Lava tiles
		else if (entityName == "Lava")
		{
			trap = new Trap(x, y);
			add(trap);
			trapGroup.add(trap);
		}
		
		//Logic for adding Fire Bars
		else if (entityName == "FireBar")
		{
			trap = new Trap(x, y);
			trap.buildTrap(trap);
			add(trap._grpBarTrap);
			trap.placeTrap(trap._grpBarTrap, x, y);
			trapGroup.add(trap);
		}
		
		//Logic for adding platforms
		else if (entityName == "Platform")
		{
			var type:String = entityData.get("Type");
			if (type == "Platform")
			{
				platform =  new Platforms(x, y, 4, 0, 0, 0, 0, player);
				platform.immovable = platform.solid = true;
				platform.allowCollisions = FlxObject.UP;
				platform.inContact = false;
				platformGroup.add(platform);
			}
			
			else if (type == "Elevator")
			{
				platform =  new Platforms(x, y, 4, 0, 0, 50, 50, player);
				platform.immovable = platform.solid = true;
				platform.allowCollisions = FlxObject.UP;
				platform.inContact = false;
				platformGroup.add(platform);
			}
			
			else if (type == "Walkway")
			{
				platform =  new Platforms(x, y, 4, 50, 50, 0, 0, player);
				platform.immovable = platform.solid = true;
				platform.allowCollisions = FlxObject.UP;
				platform.inContact = false;	
				platformGroup.add(platform);
			}
		}
		
		//Logic for adding Coins
		else if (entityName == "Coin")
		{
			var color:Int = Std.parseInt(entityData.get("Color"));
			if (color == 2)
			{
				coins.add(new Coin(x, y, "red"));
			}
			else
			{
				coins.add(new Coin(x, y, "yellow"));
			}
			add(coins);
		}
		
		//Logic for adding Turtle/FlyingTurtles
		else if (entityName == "Turtle")
		{
			var wings:String = entityData.get("Wings");
			if (wings == "True")
			{
				flyingEnemy = new FlyingTurtle(x, y);
				sprites.add(flyingGroup.add(flyingEnemy));
			}
			else
			{
				turEnemy = new Turtle(x, y);
				sprites.add(turGroup.add(turEnemy));
			}
			
		}
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		//platform.platformUpdate(elapsed, sprites, platform);

		hud.update(elapsed);

		// Add overlap logic
		FlxG.overlap(player, coins, collectCoin);
		FlxG.overlap(blockGroup, player.hitBoxComponents, function(b:Block, obj:FlxObject) {b.onTouch(obj, player);} );
		FlxG.overlap(player, dtmGroup, DontTouchMe.playerHitResolve);
		FlxG.overlap(dtmGroup, turGroup, Turtle.enemyHitResolve);
		FlxG.overlap(player, turGroup, Turtle.playerHitResolve);
		FlxG.overlap(player, flyingGroup, Turtle.playerHitResolve);
		FlxG.overlap(player, bullets, bulletHitPlayer);
		FlxG.overlap(player, trapGroup, trap.playerTrapResolve);
		//FlxG.overlap(player, trap._grpBarTrap, trap.playerTrapResolve);
		
		// Add collision logic
		FlxG.collide(platformGroup, sprites);
		FlxG.collide(blockGroup, sprites);
		FlxG.collide(blockGroup, bullets);
		FlxG.collide(player, sentry1);
		FlxG.collide(_mGround, bullets);
		FlxG.collide(_mGround, sprites);

    
   		if (!flagpole.level_over()){
			FlxG.overlap(player, flagpole, flagpole.win_animation);
		} else {
			//kill all enemies and bullets on screen. Deactivate cannons
			bullets.forEachAlive(function(bullet:Bullet){bullet.kill(); });
			dtmGroup.forEachAlive(function(dtm:DontTouchMe){ dtm.kill(); });
			turGroup.forEachAlive(function(tur:Turtle){ tur.kill(); });
			flyingGroup.forEachAlive(function(fly:Turtle){ fly.kill(); });
			sentry1.active = false;
			// time (seconds), callback, loops
			new FlxTimer().start(10, resetLevel, 1);
		}
	}
	
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
  
  	/**
	 * Updates HUD when player collects a coin
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