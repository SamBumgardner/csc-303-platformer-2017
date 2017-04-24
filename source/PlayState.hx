package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;
	
	private var map:FlxTilemap;
	private var player:Player;
	private var flagpole:FlagPole;
	private var flag_x_loc:Int = 17;
	private var flag_y_loc:Int = 11;
	public static var hud:HeadsUpDisplay;

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
		
		if (!flagpole.level_over()){
			FlxG.overlap(player, flagpole, flagpole.win_animation);
		} else {
			// time (seconds), callback, loops
			new FlxTimer().start(10, resetLevel, 1);
		}
	}
	
	private function resetLevel(Timer:FlxTimer):Void
	{
		FlxG.resetState();
	}
	
	
}
