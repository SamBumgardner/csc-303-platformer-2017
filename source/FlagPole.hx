package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

/**
 * ...
 * @author Cameron Yuan
 */
class FlagPole extends FlxSprite 
{
	
	public var totalFlxGrp:FlxGroup;
	
	private var flag:WinFlag;
	private var pole_height:Int = 110;
	private var pole_width:Int = 5;
	/**
	 * Intializer
	 * 
	 * @param	X	Starting x coordinate
	 * @param	Y	Starting y coordinate
	 * @param	pole_graphic	Non-animating flagpole graphic. Nothing fancy (optional)
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?pole_graphic:FlxGraphicAsset) 
	{
		super(X, Y, pole_graphic);
		//Win flag with a height of 10 and width of 30
		flag = new WinFlag(x, y, pole_height);
		
		totalFlxGrp = new FlxGroup();
		totalFlxGrp.add(flag);
		totalFlxGrp.add(this);
		
		// Initializes a basic graphic for the flagpole
		makeGraphic(pole_width, pole_height, FlxColor.GRAY);
	}
	
	public function level_over():Bool{
		return flag.isLevelOver;
	}
	
	
	/**
	 * Overlap function for player and flagpole
	 * Control win animation and music. Begin transition to next level
	 * 
	 * @param	player		Player character object
	 * @param	flagpole	FlagPole object 
	 * @return  Void		
	 */
	public function win_animation(player:FlxBasic, flagpole:FlxBasic ):Void
	{
		flag.isLevelOver = true;
		flag.flag_animate();
	}
}