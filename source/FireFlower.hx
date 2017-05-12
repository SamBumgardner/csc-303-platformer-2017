package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;

/**
 * ...
 * @author Caleb Breslin
 */
class FireFlower extends PowerUp 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X * 8 + 3, Y * 8 + 2, AssetPaths.fireflower__png);
		acceleration.y = (cast FlxG.state).GRAVITY;
	}
	
	public function getPowerup(Player:FlxObject, PowerUp:FlxObject):Void
	{
		Player.health = 3;
		Player.hasFlower = true;
		PowerUp.kill();
	}
	
}