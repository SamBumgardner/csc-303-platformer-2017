package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import haxe.Timer;


/**
 * ...
 * @author Cameron Yuan
 */
class Item extends FlxSprite
{
	
	public var weildable:Bool = false;
	public var equipped:Bool = false;
	public var justDropped:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		acceleration.y = (cast FlxG.state).GRAVITY;
	}
	
	/**
	 * Override for update function
	 * If the player has the item equipped, Item should follow the player
	 * and face the same direction as them
	 * Optimally, the player would have a different sprite on equip, So this
	 * could be considered a temporary change
	 */
	public override function update(elapsed:Float):Void
	{       
		super.update(elapsed);
		if (equipped){
			//Optimally we would set exists to false, 
			//and change the graphic of the character to show it has been equipped
			if (facing == FlxObject.LEFT){
			x = (cast (FlxG.state, PlayState)).player.x;
			}
			else {
			x = (cast (FlxG.state, PlayState)).player.x+(cast (FlxG.state, PlayState)).player.frameWidth-frameWidth;
			}
			y = (cast (FlxG.state, PlayState)).player.y;
		}
	}
	
	/**
	 * Equips the item to the player
	 * @param	player - Player object to keep track of the player x/y positions
	 */	
	public function equip(player:Player){
		equipped = true;
	}
	
	/**
	 * Functionality of keypress event to drop items
	 * If the player dies, item should drop as well
	 */	
	public function drop_item(){
		justDropped = true;
		equipped = false;
		velocity.y = 0;
		acceleration.y = (cast FlxG.state).GRAVITY;
		Timer.delay(function(){ justDropped = false; }, 1000);
	}
	
	/**
	 * Begin attack state animations
	 * Used in weapon subclasses
	 */
	public function attack(){}
	
}