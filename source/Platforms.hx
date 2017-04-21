package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Jess Geiger
 */
class Platforms extends FlxSprite 
{
    //set initial movement
    private var UP:Bool = false;
    private var DOWN:Bool = true;
    private var LEFT:Bool = false;
    private var RIGHT: Bool = true;
    private var heavy:Float = 8000; // Declare higher gravity while on platform
    private var blockSize:Int = 32; //Declare block size to be used in width and height
    //Initialize min and max positioning
    private var minX:Float;
    private var maxX:Float;
    private var minY:Float;
    private var maxY:Float;
    //Set starting position and width of platform
    private var startX:Float;
    private var startY:Float;
    private var platformwidth:Int;
    public var offsetX:Float = 0;
    public var inContact:Bool = false;
    private var platformVelocity:Int = 40;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=0, ?L:Float=0, ?R:Float=0, ?U:Float=0, ?D:Float=0, ?trackPlayer:Player, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		//set starting positions based on requested dimensions/positions
        startX = X;
        startY = Y;
        minX = L;
        maxX = R;
        minY = U;
        maxY = D;
        platformwidth = blockSize * W;

		// Initializes a basic graphic for the player
		makeGraphic(platformwidth, blockSize, FlxColor.YELLOW);

	}

    //Movement as requested by user parameters
    public function movement():Void
    {
		if (DOWN) {
            if (y >= (startY + maxY)) {
                UP = true;
                DOWN = false;
            }
            else {
                velocity.y = platformVelocity;
            }
        }
        if (UP) {
            if (y <= (startY - minY)) {
                UP = false;
                DOWN = true;
            }
            else {
                velocity.y = -platformVelocity;
            }
        }
        if (LEFT) {
            if (x <= (startX - minX)) {
                RIGHT = true;
                LEFT = false;
            }
            else {
                velocity.x = -platformVelocity;
            }
        }
        if (RIGHT) {
            if (x >= startX + maxX) {
               RIGHT = false;
               LEFT = true;
            }
            else {
                velocity.x = platformVelocity;
            }
        }
    }

    public function platformObjects(elapsed:Float, player:FlxObject, platform:Platforms):Void
    {
        trace("made it in objects");
        // If platform and player are not touching, allow offset to be overwritten
		if (!platform.isTouching(FlxObject.UP)) {
            platform.inContact = false;
        }
        else {
            if (!platform.inContact) {
                platform.inContact = true;
                //add thing to array of things
            }
        }


        // if (!FlxG.keys.anyPressed([FlxKey.DOWN])) {
        //     // If the player is NOT pressing down, allow for collisions between platform and player
        //     if (FlxG.collide(player, platform)) {
               
        //         // Only set offset value if touching platform for "first" time
        //         player.acceleration.y = heavy;
        //         if (!platform.inContact) {
        //             platform.inContact = true;
        //             platform.offsetX = player.x - platform.x;
        //         }
                
        //         // Multiply velocity by elapsed to get the player's movement each frame.
        //         platform.offsetX += player.velocity.x * elapsed;

        //         // Update player x position
        //         player.x = platform.x + platform.offsetX;
        //     }
        //     else {
        //         // Return gravity to normal (in PlayState) as soon as not on platform
        //         player.acceleration.y = cast(FlxG.state, PlayState).GRAVITY;
        //     }
        // }
        // else {
        //     // Reset gravity if player drops down through platform
        //     player.acceleration.y = cast(FlxG.state, PlayState).GRAVITY;
        // }
		
    }


    public function platformUpdate(elapsed:Float, objects:FlxTypedGroup<FlxObject>, platform:Platforms):Void
    {
        for (i in 0...objects.length)
        {
            if (FlxG.overlap(platform, objects.members[i])) {
                trace(i);
                platformObjects(elapsed, objects.members[i], platform);
            }
        }
       
    }


    public override function update(elapsed:Float):Void
	{
        movement();
		super.update(elapsed);
	}
}