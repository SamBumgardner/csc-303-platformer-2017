package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxPath;

/**
 * ...
 * @author Cameron Yuan
 */
class FlagPole extends FlxSprite 
{
	
	public var totalFlxGrp:FlxGroup;
	
	private var flag:WinFlag;
	private var pole_height:Int = 210;
	private var pole_width:Int = 5;
	private var pole_x_pos:Float;
	private var pole_y_pos:Float;
	private var player_x:Float;
	private var player_y:Float;
	private var win_sound:FlxSound;
	/**
	 * Intializer
	 * 
	 * @param	X	Starting x coordinate
	 * @param	Y	Starting y coordinate: Ground level
	 * @param	pole_graphic	Non-animating flagpole graphic. Nothing fancy (optional)
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?pole_graphic:FlxGraphicAsset) 
	{
		win_sound = FlxG.sound.load(AssetPaths.win__wav);
		win_sound.looped = true;
		pole_x_pos = X;
		pole_y_pos = Y-pole_height;
		super(pole_x_pos, pole_y_pos, pole_graphic);
		
		//Win flag with a height of 10 and width of 30
		flag = new WinFlag(pole_x_pos, pole_y_pos, pole_height);
		
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
		cast(player, FlxSprite).velocity.x = 0;
		//subtract 16 for the half of the character image
		player_x = cast(player, FlxSprite).x + 16; // - pole_width / 2;
		player_y =  cast(player, FlxSprite).y;
		cast(player, FlxSprite).path = new FlxPath().start([new FlxPoint(player_x, player_y+16), new FlxPoint(player_x, pole_y_pos+pole_height-16)], 25, FlxPath.FORWARD);
		
		
		flag.flag_animate();
		win_sound.play();
	}
}