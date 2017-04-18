package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;
	
	private var map:FlxTilemap;
	public var player:Player;
	private var platform:Platforms;
	private var x:Float = 0;
	override public function create():Void
	{
		super.create();
		
		player = new Player(50, 50);
		//player.collisonXDrag = true;
		add(player);
		
		//create new moving platform
		platform =  new Platforms(250, 150, 3, 100, 100, 50, 50, player);
		platform.immovable = platform.solid = true;
		//platform.collisonXDrag = true;
		platform.allowCollisions = FlxObject.UP;
		platform.sticky = false;
		add(platform);

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

		// If platform and player are not touching, allow offset to be overwritten
		if (!FlxG.overlap(player, platform) || FlxG.keys.anyJustPressed([FlxKey.RIGHT, FlxKey.LEFT])) {
			platform.sticky = false;
		}

		if (FlxG.collide(player, platform)) {
			// Only set offset value if touching platform for "first" time
			if (!platform.sticky) {
				platform.sticky = true;
				platform.offsetX = player.x - platform.x;
			}

			// Update offset when player position changes based on keypress
			if (FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.RIGHT, FlxKey.A, FlxKey.D]))
			{
				platform.offsetX += player.x - player.last.x;
			}


			// Set player x and y to follow platform
			player.x = platform.x + platform.offsetX;
			player.y = platform.y - 32;
			

			player.velocity.x += platform.velocity.x;
			player.velocity.y = platform.velocity.y;
		}

	}
}