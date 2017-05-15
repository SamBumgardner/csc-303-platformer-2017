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
	private var player_trace:Player;
	
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
			x = player_trace.x;
			}
			else {
			x = player_trace.x+player_trace.frameWidth-frameWidth;
			}
			y = player_trace.y;
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
	 * Functionality of keypress event to drop items
	 * If the player dies, item should drop as well
	 */	
	public function drop_item(){
		justDropped = true;
		equipped = false;
		player_trace = null;
		velocity.y = 0;
		acceleration.y = (cast FlxG.state).GRAVITY;
		Timer.delay(function(){ justDropped = false; }, 1000);
	}
	
	
	/**
	 * Functionality for keypress event to attack if an item is currently being 
	 * weilded. Disables user input to put them in the 'attacking state', but 
	 * still keeps their current velocity and acceleration
	 */
	public function attack_state(){
		FlxG.keys.reset();
		FlxG.keys.enabled = false;
	}
	

	
}