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
	public var containedItem:String; //placeholder var until we have an item class
	public var isExpended:Bool; //whether the item has been removed yet
	
	/**
	 * Constructor
	 * 
	 * @param	X	X coordinate in tilemap
	 * @param	Y	Y coordinate in tilemap
	 * @param	Item	Placeholder for the contained item
	 * @param	SimpleGraphic	Non-animating graphic.
	 * @param	Breakable	Whether the block is breakable; defaults to false
	 */
	public function new(?X:Float=0, ?Y:Float=0, Item:String, ?SimpleGraphic:FlxGraphicAsset, ?Breakable:Bool=false) 
	{
		super(X, Y, SimpleGraphic, Breakable);
		containedItem = Item;
		isExpended = false;
	}
	
	/**
	 * Destructor
	 */
	override public function destroy()
	{
		containedItem = null;
		isExpended = null;
		super.destroy();
	}
	
	/**
	 * Processes hit logic for item block
	 */
	override public function onTouch(p:Player)
	{
		//produce item logic
		if (isTouching(FlxObject.DOWN))
		{
			color = FlxColor.PURPLE;
		}
	}
}