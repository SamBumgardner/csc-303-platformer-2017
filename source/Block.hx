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
	static public var IMAGE(default, never):FlxGraphicAsset = AssetPaths.Brick__png;
	public var isBreakable:Bool;
	
	/**
	 * Constructor
	 * 
	 * @param	X	X coordinate in tilemap
	 * @param	Y	Y coordinate in tilemap
	 * @param	Breakable	Whether the block breaks when hit from below; defaults to false
	 * @param	SimpleGraphic	Non-animating graphic.
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?Breakable:Bool=false, ?Graphic:FlxGraphicAsset) 
	{
		//if no graphic is provided, use the default brick image
		if (Graphic == null)
		{
			Graphic = IMAGE;
		}
		super(X*SCALEFACTOR, Y*SCALEFACTOR, Graphic);
		
		immovable = true;
		isBreakable = Breakable;
	}
	
	/**
	 * Processes hit logic for normal blocks
	 * @param	obj	The object overlapping the block
	 * @param	player	The Player object needed to check which hitbox is overlapping and adjust player y-velocity if needed
	 */
	public function onTouch(obj:FlxObject, player:Player)
	{
		if ((obj == player.topBox) && isBreakable) //ensure block was hit from below and is breakable
		{
			this.destroy();
			player.velocity.y = 0;
		}
	}
}