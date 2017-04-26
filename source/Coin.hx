package;

/**
 * ...
 * @author Samuel Faulkner
 */

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
 
class Coin extends FlxSprite
{
	public var coinColor:FlxColor;
	
	/**
	 * 
	 * @param	X	X-coordinate of the coin
	 * @param	Y	Y-coordinate of the coin
	 * @param	color	String value telling if coin is yellow or red
	 * @return
	 */
	public function new(X:Float=0, Y:Float=0, color:String)
	{
		super(X * 32, Y * 32);
		if (color == "red")
		{
			coinColor = FlxColor.RED;
		}
		if (color == "yellow") 	
		{
			coinColor = FlxColor.YELLOW;
		}
		makeGraphic(8, 8, coinColor);
	}
	
	override public function kill():Void
	{
		super.kill();
	}
}