package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

/**
 * ...
 * @author Jess Geiger
 */
class Platforms extends FlxSprite 
{
    //set initial movement
    public var UP:Bool = false;
    public var DOWN:Bool = true;
    public var LEFT:Bool = false;
    public var RIGHT: Bool = true;
    //Initialize min and max positioning
    public var minX:Float;
    public var maxX:Float;
    public var minY:Float;
    public var maxY:Float;
    //Set starting position and width of platform
    public var startX:Float;
    public var startY:Float;
    public var platformwidth:Int;

	public function new(?X:Float=0, ?Y:Float=0, ?W:Int=0, ?L:Float=0, ?R:Float=0, ?U:Float=0, ?D:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		//set starting positions based on requested dimensions/positions
        startX = X;
        startY = Y;
        minX = L;
        maxX = R;
        minY = U;
        maxY = D;
        platformwidth = 32 * W;

		// Initializes a basic graphic for the player
		makeGraphic(platformwidth, 32, FlxColor.YELLOW);

	}

    //Movement as requested by user parameters
    public override function update(elapsed:Float):Void
	{
		if (DOWN) {
            if (y >= (startY + maxY)) {
                UP = true;
                DOWN = false;
            }
            else {
                y += 1;
            }
        }
        if (UP) {
            if (y <= (startY - minY)) {
                UP = false;
                DOWN = true;
            }
            else {
                y -= 1;
            }
        }
        if (LEFT) {
            if (x <= (startX - minX)) {
                RIGHT = true;
                LEFT = false;
            }
            else {
                x -= 1;
            }
        }
        if (RIGHT) {
            if (x >= startX + maxX) {
               RIGHT = false;
               LEFT = true;
            }
            else {
                x += 1;
            }
        }
		super.update(elapsed);
	}
}