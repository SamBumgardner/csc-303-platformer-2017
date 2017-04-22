package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import haxe.Timer;

/**
 * Item blocks that produce their items when hit from below
 * @author TR Nale
 */
class ItemBlock extends Block
{
	static public var IMAGE(default, never):FlxGraphicAsset = AssetPaths.Item__png;
	public var containedItem:String; //placeholder var until we have an item class
	public var isExpended:Bool; //whether the item has been removed yet
	
	/**
	 * Constructor
	 * 
	 * @param	X	X coordinate in tilemap
	 * @param	Y	Y coordinate in tilemap
	 * @param	Item	Placeholder for the contained item
	 * @param	Breakable	Whether the block is breakable; defaults to false
	 * @param	SimpleGraphic	Non-animating graphic.
	 */
	public function new(?X:Float=0, ?Y:Float=0, Item:String, ?Breakable:Bool=false, ?Graphic:FlxGraphicAsset) 
	{
		if (Graphic == null)
		{
			Graphic = IMAGE;
		}
		super(X, Y, Breakable, Graphic);
		containedItem = Item;
		isExpended = false;
	}
	
	/**
	 * Processes hit logic for item block
	 * @param	obj	The object overlapping the block
	 * @param	player	The Player object needed to check which hitbox is overlapping and adjust player y-velocity if needed
	 */
	override public function onTouch(obj:FlxObject, player:Player)
	{
		if (obj == player.topBox) {
			//produce item logic
			loadGraphic(AssetPaths.Empty__png);
			player.velocity.y = 0;
		}
	}
}