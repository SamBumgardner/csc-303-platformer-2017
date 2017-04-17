package;

/**
 * ...
 * @author Samuel Faulkner
 */

import flixel.util.FlxColor;
import flixel.FlxSprite;
 
class Coin
{
	/**
	 * 
	 * @param	X	X-coordinate of the coin
	 * @param	Y	Y-coordinate of the coin
	 * @param	red	Bool value that tells creator if coin is red or yellow
	 * @return
	 */
	static public function createCoin(X:Float=0, Y:Float=0, red:Bool=false):FlxSprite 
	{
		var coin:FlxSprite = new FlxSprite(X * 32, Y * 32);
		if (red == true)
			coin.makeGraphic(8, 8, FlxColor.RED);
		else
			coin.makeGraphic(8, 8, FlxColor.YELLOW);
		return coin;
	}
	
	/**
	 * 
	 * @param	player	Player object
	 * @param	coin	Coin object
	 */
	static public function getCoin(player:Player, coin:FlxSprite):Void
	{
		coin.kill();
	}
	
}