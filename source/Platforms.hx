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
    public var touchingSprites:FlxTypedGroup<PlatformTracker> = new FlxTypedGroup<PlatformTracker>();
    private var countTouching:Int = 0;

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

    // Add or update sprites colliding with platform
    public function platformObjects(elapsed:Float, player:FlxObject, platform:Platforms):Void
    {
        // If there is nothing in the touching platform group, add this object
        if (countTouching == 0)
        {  
            var obj = new PlatformTracker(player, (player.x - platform.x));
            touchingSprites.add(obj);
			player.acceleration.y = heavy;
            countTouching++;
        }
        else
        {
            inContact = false;
            // Iterate through the members of the group
            for (i in 0...countTouching)
            {
                // If this sprite touching the platform has already been touching the platform
                if (touchingSprites.members[i].returnBase() == player)
                {
                    // Mark that this sprite has been found and was already in contact
                    inContact = true;

                    // Multiply velocity by elapsed to get the player's movement each frame.
                    touchingSprites.members[i].trackedOffsetX += player.velocity.x * elapsed;

                    // Update player x position
                    player.x = platform.x + touchingSprites.members[i].returnOffset();
                }
            }
            // If the end of the group is reached and this object isn't already in contact, add it
            if (!inContact)
            {
                var obj = new PlatformTracker(player, (player.x - platform.x));
                touchingSprites.add(obj);
				player.acceleration.y = heavy;
                countTouching++;
            }
        }
    }

    // Remove sprites NOT colliding with platform
    private function notPlatformObjects(elapsed:Float, sprite:FlxObject, platform:Platforms):Void
    {
        // If there are objects touching the platform, make sure it isn't this one
        if (countTouching != 0)
        {
			// Set up an unchanging variable so the loop's duration won't change as the count decreases.
			var originalCount:Int = countTouching;
			
            for (i in 0...originalCount)
            {
				// Use i to count backward through the list indices, necessary when removing objects.
				var index:Int = originalCount - (1 + i);
				
                // If this object is STILl in the list of sprites touching the platform, remove it
                if (touchingSprites.members[index].returnBase() == sprite)
                { 
                    // Exit loop and Remove from touchingSprites
                    touchingSprites.update(elapsed);
                    touchingSprites.remove(touchingSprites.members[index], true);
                    countTouching--;
                }
            }
        }
    }
	


    public function platformUpdate(elapsed:Float, objects:FlxTypedGroup<FlxObject>, platform:Platforms):Void
    {
        for (i in 0...objects.length)
        {
            if (FlxG.collide(platform, objects.members[i])) {
                platformObjects(elapsed, objects.members[i], platform);
            }
            else {
                notPlatformObjects(elapsed, objects.members[i], platform);
            }
        }
       
    }


    public override function update(elapsed:Float):Void
	{
        movement();
		super.update(elapsed);
	}
}