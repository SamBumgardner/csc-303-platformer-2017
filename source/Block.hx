package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * General blocks.  Can be invulnerable or destroyed when hit from below.
 * @author TR Nale
 */
class Block extends FlxSprite 
{
	static public var SCALEFACTOR(default, never):Int = 32;
	public var isBreakable:Bool;
	
	/**
	 * Constructor
	 * 
	 * @param	X	X coordinate in tilemap
	 * @param	Y	Y coordinate in tilemap
	 * @param	SimpleGraphic	Non-animating graphic.
	 * @param	Breakable	Whether the block breaks when hit from below; defaults to false
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, ?Breakable:Bool=false) 
	{
		super(X*SCALEFACTOR, Y*SCALEFACTOR, SimpleGraphic);
		
		if (SimpleGraphic == null)
		{
			makeGraphic(SCALEFACTOR, SCALEFACTOR, FlxColor.WHITE);
		}
		
		immovable = true;
		isBreakable = Breakable;
	}
	
	/**
	 * Processes hit logic for normal blocks
	 */
	public function onTouch(p:Player)
	{
		trace("block x, y: ", x, y);
		trace("player x, y: ", p.x, p.y);
		trace("X diff: ", Math.abs(x - p.x));
		trace("Y diff: ", Math.abs(y - p.y));
		if (Math.abs(x - p.x) > Math.abs(y - p.y))
		{
			touching = ((x - p.x) > 0 ? FlxObject.LEFT: FlxObject.RIGHT);
		}
		else
		{
			touching = ((y - p.y) > 0 ? FlxObject.UP: FlxObject.DOWN);
		}
		//trace("block touched ", isTouching(FlxObject.UP), isTouching(FlxObject.DOWN), isTouching(FlxObject.LEFT), isTouching(FlxObject.RIGHT));
		if (isTouching(FlxObject.DOWN) && isBreakable) //ensure block was hit from below and is breakable
		{
			this.destroy();
		}
	}
}