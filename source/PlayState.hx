package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	public var GRAVITY(default, never):Float = 600;
	
	private var map:FlxTilemap;
	private var player:Player;
	public static var hud:HeadsUpDisplay;
	public var _pUp:FlxGroup;
	
	override public function create():Void
	{
		if (hud == null){
			hud = new HeadsUpDisplay(0, 0, "MARIO");
		}
		super.create();
		
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
		
		_pUp = new FlxGroup();
		createPowerUp(25, 25);
		createPowerUp(40,60);
		add(_pUp);	
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		hud.update(elapsed);
		FlxG.collide(map, player);
		FlxG.overlap(player, _pUp, getPowerup);
	}
	
	public function createPowerUp (x:Int, y:Int): Void
	{	
		var powerup:FlxSprite = new FlxSprite(x*8 + 3, y*8 + 2);
		powerup.makeGraphic(32,32, FlxColor.YELLOW);
		_pUp.add(powerup);
	}
	
	private function getPowerup(Player:FlxObject, PowerUp:FlxObject):Void
	{
		trace("PowerUp Collected");
		PowerUp.kill();
	}
}
