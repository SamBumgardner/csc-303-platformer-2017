package;
import flash.display.InterpolationMethod;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Cameron Yuan
 */
class Item extends FlxSprite
{
	public var weildable:Bool = false;
	public var equipped:Bool = false;
	private var player_trace:Player;
	private var item_activated:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		acceleration.y = (cast FlxG.state).GRAVITY;
		
	}
	
	/**
	 * Override for update function
	 * If the player has the item equipped, Item should follow the player
	 */
	public override function update(elapsed:Float):Void
	{       
		super.update(elapsed);
		if (equipped){
			if (!player_trace.alive){
				drop_item();
			}
			else 
			{	if(!item_activated){
					if (player_trace.facing == FlxObject.LEFT){
					x = player_trace.x;
					}
					else {
					x = player_trace.x+player_trace.frameWidth-frameWidth;
					}
					y = player_trace.y;
				}
			}
		}
	}
	
	/**
	 * Equips the item to the player
	 * @param	player - Player object to keep track of the player x/y positions
	 */	
	public function equip(player:Player){
		equipped = true;
		player_trace = player;
	}
	
	/**
	 * Functionality to add a keypress event to drop items
	 * If the player dies, item should drop. 
	 */
	
	public function drop_item(){
		if (player_trace.facing == FlxObject.LEFT){
			x -= frameWidth;
		}
		else {
			x += frameWidth;
		}
		equipped = false;
	}
	
	public function attack_state(){
		item_activated = true;
		FlxG.keys.reset();
		FlxG.keys.enabled = false;
	}
	

	
}