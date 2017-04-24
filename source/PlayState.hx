package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;


class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;

	private var map:FlxTilemap;
	private var player:Player;
	private var trap:Trap;
	public static var hud:HeadsUpDisplay;

	override public function create():Void
	{
		if (hud == null){
			hud = new HeadsUpDisplay(0, 0, "MARIO");
		}
		super.create();

		player = new Player(50, 50);
		add(player);
		add(player.hitBoxComponents);


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
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		hud.update(elapsed);
		FlxG.collide(map, player);
		FlxG.overlap(player, trap._grpBarTrap, trap.playerTrapResolve);
	}
}
