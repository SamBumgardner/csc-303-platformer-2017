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
	 * Destructor
	 */
	override public function destroy():Void 
	{
		isBreakable = null;
		super.destroy();
	}
	
	/**
	 * Processes hit logic for normal blocks
	 */
	public function onTouch()
	{
		if (isTouching(FlxObject.DOWN) && isBreakable) //ensure block was hit from below and is breakable
		{
			this.destroy();
		}
	}
}