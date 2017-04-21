package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;
	
	private var map:FlxTilemap;
	public var player:Player;
	private var platform:Platforms;
	public static var hud:HeadsUpDisplay;
	//public var sprites = FlxGroup
	public var sprites:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

	
	override public function create():Void
	{

		if (hud == null){
			hud = new HeadsUpDisplay(0, 0, "MARIO");
		}
		super.create();
		

		player = new Player(50, 50);
		add(player);
		sprites.add(player);

		//Add enemies as they are created
		
		//create new moving platform
		platform =  new Platforms(250, 150, 3, 100, 100, 50, 50, player);
		platform.immovable = platform.solid = true;
		platform.allowCollisions = FlxObject.UP;
		platform.inContact = false;
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
		add(hud);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(map, player);

		platform.platformUpdate(elapsed, sprites, platform);

		hud.update(elapsed);
	}
}