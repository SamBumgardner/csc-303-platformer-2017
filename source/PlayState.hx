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
import flixel.FlxObject;
import flixel.FlxSprite;


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
 	private var coins:FlxTypedGroup<Coin> = new FlxTypedGroup<Coin>();
	private var flag_x_loc:Int = 37;
	//private var sword:Sword;
	private var flag_y_loc:Int = 11;

	public static var hud:HeadsUpDisplay;
	public var _pUp:FlxTypedGroup<PowerUp> = new FlxTypedGroup<PowerUp>();
	public var sprites:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();
	public var trapGroup:FlxTypedGroup<Trap> = new FlxTypedGroup<Trap>();
	public var fireBarGroup:FlxTypedGroup<FlxTypedGroup<Trap>> = new FlxTypedGroup<FlxTypedGroup<Trap>>();
	private var blockGroup:FlxTypedGroup<Block> = new FlxTypedGroup<Block>();
	private var platformGroup:FlxTypedGroup<Platforms> = new FlxTypedGroup<Platforms>();
	private var mushroom:PowerupMushroom;
	private var fireflower:FireFlower;
	
	// Enemies
	private var dtmEnemy:DontTouchMe;
	private var dtmGroup:FlxTypedGroup<DontTouchMe> = new FlxTypedGroup<DontTouchMe>();
	private var turEnemy:Turtle;
	private var turGroup:FlxTypedGroup<Turtle> = new FlxTypedGroup<Turtle>();
	private var flyingEnemy:FlyingTurtle;
	private var flyingGroup:FlxTypedGroup<FlyingTurtle> = new FlxTypedGroup<FlyingTurtle>();
	private var sentry:Sentry;
	private var bullets:FlxTypedGroup<Bullet> = new FlxTypedGroup<Bullet>(20);
	
	override public function create():Void
	{

		//if (hud == null)
		//{
			hud = new HeadsUpDisplay(0, 0, "MARIO");
		//}
		//super.create();
		
		//Loading the map created in Ogmo Editor
		_map = new FlxOgmoLoader(AssetPaths.CSC303_Level__oel);
		_mGround = _map.loadTilemap(AssetPaths.overworld__png, 16, 16, "Overworld");
		_mGround.follow();
		_mGround.setTileProperties(2, FlxObject.ANY);
		add(_mGround);
		_map.loadEntities(placeEntities, "Entities");
		
		//_pUp = new FlxGroup();
		//// Instatiate the mushroom
		//mushroom = new PowerupMushroom(40, 40);
		//// Add the mushroom to the powerup group
		//_pUp.add(mushroom);
		//// Instantiate the fire flower
		//fireflower = new FireFlower(32, 19);
		//// Add the fire flower to the group
		//_pUp.add(fireflower);
		//// Add the powerups to the level
		//add(_pUp);

		//sword = new Sword(4*32, 3*32, AssetPaths.sword__png);
		//add(sword);
		//add(sword.hitbox);
		//add(sword.hitbox.hitboxFrames);
		//add(sword.hitbox.Animation);

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
		add(trapGroup);
		add(fireBarGroup);
		add(bullets);
		add(_pUp);
		
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
			sentry = new Sentry(x, y, bullets, player);
			add(sentry);
			sprites.add(sentry);
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
			trapGroup.add(trap);
		}
		
		//Logic for adding Fire Bars
		else if (entityName == "FireBar")
		{
			trap = new Trap(x, y);
			trap.buildTrap(trap);
			trap.placeTrap(trap._grpBarTrap, x, y);
			fireBarGroup.add(trap._grpBarTrap);
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
		
		//Logic for adding the ending Flagpole
		else if (entityName == "PowerUp")
		{
			var type:String = entityData.get("Type");
			if (type == "Mushroom") 
			{
				mushroom = new PowerupMushroom(x, y);
				sprites.add(_pUp.add(mushroom));	
			}
			
			else if (type == "FireFlower")
			{
				fireflower = new FireFlower(x, y);
				sprites.add(_pUp.add(fireflower));
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
		FlxG.overlap(player, mushroom, mushroom.getPowerup);
		FlxG.overlap(player, fireflower, fireflower.getPowerup);  
		FlxG.overlap(blockGroup, player.hitBoxComponents, function(b:Block, obj:FlxObject) {b.onTouch(obj, player);} );
		FlxG.overlap(player, dtmGroup, DontTouchMe.playerHitResolve);
		FlxG.overlap(dtmGroup, turGroup, Turtle.enemyHitResolve);
		FlxG.overlap(player, turGroup, Turtle.playerHitResolve);
		FlxG.overlap(player, flyingGroup, Turtle.playerHitResolve);
		FlxG.overlap(player, bullets, bulletHitPlayer);
		FlxG.overlap(player, trapGroup, Trap.playerTrapResolve);
		FlxG.overlap(player, fireBarGroup, Trap.playerTrapResolve);
		//FlxG.overlap(player, sword, player.pickup_item);
		//FlxG.overlap(sword.hitbox.hitboxFrames, dtmGroup, sword.hit_enemy);
		
		// Add collision logic
		FlxG.collide(platformGroup, sprites);
		FlxG.collide(blockGroup, sprites);
		FlxG.collide(_mGround, bullets);
		FlxG.collide(_mGround, sprites);

		//if(player.equipped_item != sword){
			//FlxG.collide(map, sword);
			//FlxG.collide(blockGroup, sword);
		//}
    
   		if (!flagpole.level_over()){
			FlxG.overlap(player, flagpole, flagpole.win_animation);
		} else {
			//kill all enemies and bullets on screen. Deactivate cannons
			bullets.forEachAlive(function(bullet:Bullet){bullet.kill(); });
			dtmGroup.forEachAlive(function(dtm:DontTouchMe){ dtm.kill(); });
			turGroup.forEachAlive(function(tur:Turtle){ tur.kill(); });
			flyingGroup.forEachAlive(function(fly:Turtle){ fly.kill(); });
			sentry.active = false;
			// time (seconds), callback, loops
			new FlxTimer().start(10, resetLevel, 1);
		}
		//FlxG.collide(_pUp, blockGroup);
		//FlxG.collide(map, _pUp);
		//FlxG.collide(_map, mushroom);
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

	public function resetLevel(?Timer:FlxTimer):Void
	{
		FlxG.resetState();
	}
}