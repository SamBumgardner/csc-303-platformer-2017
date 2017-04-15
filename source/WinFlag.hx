package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

/**
 * ...
 * @author Cameron Yuan
 */
class WinFlag extends FlxSprite 
{
	public var isLevelOver:Bool = false;
	
	private var flag_height:Float;
	private var flag_distance:Float;
	private var graphic_width:Int = 30;
	private var graphic_height:Int = 10;

	/**
	 * Intializer
	 * 
	 * @param	X	Starting x coordinate
	 * @param	Y	Starting y coordinate
	 * @param	flag_graphic	animating flag graphic. Nothing fancy (optional)
	 */
	public function new(?X:Float = 0, ?Y:Float = 0, ?height:Float, ?flag_graphic:FlxGraphicAsset) 
	{
		super(X, Y, flag_graphic);
		flag_height = height;
		flag_distance = height + y - graphic_height;
		
		// Initializes a basic graphic for the winflag
		makeGraphic(graphic_width, graphic_height, FlxColor.RED);
		
	}
	
	
	/**
	 * Flag animation - fall down the pole with the player
	 * 
	 * 
	 * @param	player		Player character object
	 * @param	flagpole	FlagPole object 
	 * @return  Void		
	 */
	public function flag_animate():Void
	{
		this.x -= graphic_width/2; // move it to the other side of the pole
		//angle = 180; //rotate the image
		velocity.y = 25;
	}
	
	public override function update(elapsed:Float):Void
	{
        if (isLevelOver){
			//if (y > (y + flag_height)) //this will evaluate false no matter what?
			if (y > flag_distance){ // but this will function correctly
				velocity.y = 0;
			}
		}

       
		super.update(elapsed);
	}
	
}