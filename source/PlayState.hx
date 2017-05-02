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
import flixel.system.FlxAssets;
import flixel.math.FlxPoint;

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
	private var playerLastVelocity:FlxPoint;
	public static var hud:HeadsUpDisplay;

	public var sprites:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

	private var blockGroup:FlxTypedGroup<Block> = new FlxTypedGroup<Block>(10);
	
	// Enemies
	private var dtmEnemy1:DontTouchMe;
	private var sentry1:Sentry;
	private var bullets:FlxTypedGroup<Bullet>;
	
	//Music
	private var music:ReactiveBGMusic;
	
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
		#if debug
			trace("Initializing PlayState");
		#end
		//if (hud == null){
			hud = new HeadsUpDisplay(0, 0, "MARIO");
		//}
		super.create();
		
		music = setUpBackgroundMusic(); //create the music object
		music.play();
		
		playerLastVelocity = new FlxPoint(0, 0);
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
		decideMusicMix();
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
			//check for the goal being reached
			FlxG.overlap(player, flagpole, flagpole.win_animation);
			//allow for music changes
			//trigger music change on speed if neccessary

			
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
		c.kill();
  }

	private function resetLevel(Timer:FlxTimer):Void
	{
		FlxG.resetState();
	}
	
	private function setUpBackgroundMusic():ReactiveBGMusic
	{
		//Set up bass track and mixes
		#if debug
			trace("setting up bass track");
		#end
		var bassTrack:ReactiveBGMusicTrack = new ReactiveBGMusicTrack(FlxAssets.getSound("assets/music/FlyingBatteryZoneBass"), 0, 0, 1.595, 107.205, false, ReactiveBGMusicTrackType.Bass);
		bassTrack.addMix("Normal", 0.9, 0.5);
		bassTrack.addMix("RunningFast", 0.97, 0.7);
		bassTrack.addMix("NearTurret", 0.2, 0.5);
		bassTrack.addMix("YouWin", 1, 1);
		
		//Set up effects track and mixes
		#if debug
			trace("setting up effects track");
		#end
		var effectsTrack:ReactiveBGMusicTrack = new ReactiveBGMusicTrack(FlxAssets.getSound("assets/music/FlyingBatteryZoneEffects"), 0, 0, 1.595, 107.205, false, ReactiveBGMusicTrackType.Effects);
		effectsTrack.addMix("Normal", 0.9, 0.5);
		effectsTrack.addMix("RunningFast", .9, 0.5);
		effectsTrack.addMix("NearTurret", 0.2, 0.5);
		effectsTrack.addMix("YouWin", 0, 0.5);
		
		//Set up GenesisKit track and mixes
		#if debug
			trace("setting up genesis track");
		#end
		var genesisKitTrack:ReactiveBGMusicTrack = new ReactiveBGMusicTrack(FlxAssets.getSound("assets/music/FlyingBatteryZoneGenesisKit"), 0, 0, 1.595, 107.205, false, ReactiveBGMusicTrackType.GeneralPercussion);
		genesisKitTrack.addMix("Normal", 0, 0.5);
		genesisKitTrack.addMix("RunningFast", 1, 0.5);
		genesisKitTrack.addMix("NearTurret", 0, 0.5);
		genesisKitTrack.addMix("YouWin", 1, 0.5);
		
		//Set up MetalKit track and mixes
		#if debug
			trace("setting up metalKit track");
		#end
		var metalKitTrack:ReactiveBGMusicTrack = new ReactiveBGMusicTrack(FlxAssets.getSound("assets/music/FlyingBatteryZoneMetalKit"), 0, 0, 1.595, 107.205, false, ReactiveBGMusicTrackType.GeneralPercussion);
		metalKitTrack.addMix("Normal", .9, 0.5);
		metalKitTrack.addMix("RunningFast", 0.4, 0.5);
		metalKitTrack.addMix("NearTurret", 0.5, 0.5);
		metalKitTrack.addMix("YouWin", 0, 0.5);
		
		//Set up Lead track and mixes
		#if debug
			trace("setting up lead track");
		#end
		var leadTrack:ReactiveBGMusicTrack = new ReactiveBGMusicTrack(FlxAssets.getSound("assets/music/FlyingBatteryZoneLead"), 0, 0, 1.595, 107.205, false, ReactiveBGMusicTrackType.Lead);
		leadTrack.addMix("Normal", .8, 0.5);
		leadTrack.addMix("RunningFast", 0.99, 0.5);
		leadTrack.addMix("NearTurret", 0.5, 0.5);
		leadTrack.addMix("YouWin", 0, 0.5);
		
		//Set up Rhythm track and mixes
		#if debug
			trace("setting up rhythm track");
		#end
		var rhythmTrack:ReactiveBGMusicTrack = new ReactiveBGMusicTrack(FlxAssets.getSound("assets/music/FlyingBatteryZoneRhythm"), 0, 0, 1.595, 107.205, false, ReactiveBGMusicTrackType.Rhythm);
		rhythmTrack.addMix("Normal", 1, 0.5);
		rhythmTrack.addMix("RunningFast", 0.99, 0.3);
		rhythmTrack.addMix("NearTurret", 0.7, 0.5);
		rhythmTrack.addMix("YouWin", 0.4, 0.0);
		
		//Set up Rhythm 2 track and mixes
		#if debug
			trace("setting up rhythm2 track");
		#end
		var rhythm2Track:ReactiveBGMusicTrack = new ReactiveBGMusicTrack(FlxAssets.getSound("assets/music/FlyingBatteryZoneRhythm2"), 0, 0, 1.595, 107.205, false, ReactiveBGMusicTrackType.Rhythm);
		rhythm2Track.addMix("Normal", 1, 0.5);
		rhythm2Track.addMix("RunningFast", 0.99, 0.3);
		rhythm2Track.addMix("NearTurret", 0.5, 0.5);
		rhythm2Track.addMix("YouWin", 0.5, 0.0);
		
		
		//set up track object
		var song:ReactiveBGMusic = new ReactiveBGMusic(false);
		song.addTrack(bassTrack);
		song.addTrack(effectsTrack);
		song.addTrack(genesisKitTrack);
		song.addTrack(metalKitTrack);
		song.addTrack(rhythmTrack);
		song.addTrack(rhythm2Track);
		song.setMix("Normal");
		return song;
	}
	
	public function decideMusicMix(){
			if (flagpole.level_over()){
				if( music.currentMix != "YouWin")
				music.setMix("YouWin");
			}
			else{
				if (player.getPosition().distanceTo(sentry1.getPosition()) <= 150){
					if (music.currentMix != "NearTurret"){
						music.setMix("NearTurret");
					}
				}
				else{
					if (music.currentMix != "RunningFast"){
						if (player.maxVelocity.x== player.runSpeed && Math.abs(player.velocity.x) >= player.walkSpeed){
							music.setMix("RunningFast");
						}
					}
					if (music.currentMix != "Normal"){
						if (Math.abs(player.velocity.x) <= player.walkSpeed){
							music.setMix("Normal");
						}
					}
				}

			}
	}
	
	
	override public function destroy(){
		super.destroy();
		music.destroy();
	}
}


	