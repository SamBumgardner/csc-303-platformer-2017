package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author TR Nale
 */
class Block extends FlxSprite 
{
	static var SCALEFACTOR:Int = 32;
	
	public var isBreakable:Bool;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, ?Breakable:Bool) 
	{
		super(X*SCALEFACTOR, Y*SCALEFACTOR, SimpleGraphic);
		immovable = true;
		
		makeGraphic(SCALEFACTOR, SCALEFACTOR, FlxColor.BLUE);
		
		isBreakable = Breakable;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
	public function onHit(Direction:Int)
	{
		//hit logic
		if (Direction == FlxObject.DOWN)
		{
			this.destroy();
		}
	}
}

class ItemBlock extends Block
{
	public var containedItem:String; //placeholder var until we have an item class
	public var isExpended:Bool; //whether the item has been removed yet
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, Item:String) 
	{
		super(X*Block.SCALEFACTOR, Y*Block.SCALEFACTOR, SimpleGraphic);
		containedItem = Item;
		isExpended = false;
	}
	
	override public function destroy()
	{
		super.destroy();
	}
	
	override public function onHit(Direction:Int)
	{
		//produce item logic
	}
}

class FallingBlock extends Block
{
	public var fallAccel:Float;
	public var maxSpeed:Float;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X*Block.SCALEFACTOR, Y*Block.SCALEFACTOR, SimpleGraphic);
	}
	
	override public function destroy()
	{
		super.destroy();
	}
	
	public function onStep()
	{
		//fall logic
	}
}