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
	private var _grpTrap:FlxTypedGroup<Trap>;
	private var trap:Trap;
	private var trap1:Trap;
	private var trap2:Trap;
	private var trap3:Trap;
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


		//Trap group ceration and addition to playstate (Trying to push this into its own build function, WIP)
		_grpTrap = new FlxTypedGroup<Trap>();

		trap = new Trap(320,256);
		trap1 = new Trap();
		trap2 = new Trap();
		trap3 = new Trap();

		_grpTrap.add(trap);
		_grpTrap.add(trap1);
		_grpTrap.add(trap2);
		_grpTrap.add(trap3);

		add(trap);
		add(trap1);
		add(trap2);
		add(trap3);
		
		trap1.barCreate(trap1, trap2, trap3, 320,256);
		//End trap creation



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
		FlxG.overlap(player, _grpTrap, trap.playerTrapResolve);
	}
}
