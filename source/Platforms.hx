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
    /**
     *  Set the movement variables for the platform
     *  
     *  @params UP, DOWN, LEFT, RIGHT are bools used to track which direction the platform is moving
     *  @param heavy sets the higher gravity on any objects touching the platform
     *  @param blockSize sets the height/width of the cube used as a graphic for the map,
     *  and is used to sure the platform is the same height and multiple of width
     */

    private var UP:Bool = false;
    private var DOWN:Bool = true;
    private var LEFT:Bool = false;
    private var RIGHT: Bool = true;
    private var heavy:Float = 8000;
    private var blockSize:Int = 32;

    /**
     *  Set the minimum and maximum X and Y coordinate positioning for the platform
     */
    private var minX:Float;
    private var maxX:Float;
    private var minY:Float;
    private var maxY:Float;

    /**
     *  Set the starting position and size of platform
     *  
     *  @params startX and startY are the coordinates in which the platform spawns on the map
     *  @param platformwidth is the number of blocks which connect to make the platform
     *  @param inContact helps check if the object is in the sprite group or already touching the platform
     *  @param platformVelocity is the velocity of the platform through its path
     *  @param touchingSprites is a collection of the objects touching the platform
     *  @param countTouching is a tracker of the number of objects touching the platform,
     *  since touchingSprites.length wasn't working
     */
    private var startX:Float;
    private var startY:Float;
    private var platformwidth:Int;
    public var inContact:Bool = false;
    private var platformVelocity:Int = 40;
    public var touchingSprites:Array<PlatformTracker> = new Array<PlatformTracker>();
    private var countTouching:Int = 0;

    
    /**
     *  Create object and initialize variables based on PlayState declarations
     *  
     *  @param   trackPlayer is used to make the player accessible to the platform class
     */
    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=0, ?L:Float=0, ?R:Float=0, ?U:Float=0, ?D:Float=0, ?trackPlayer:Player, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
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
    
    /**
     *  Movement as requested by user parameters. When the object hits the maximum position in 
     *  one direction, it is directed in the other direction. Corresponding booleans are changed
     *  as well.
     *  
     */
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

    /**
     *  Add or update sprites colliding with the platform. Add the sprite to the touching platform group if
     *  the group is empty. If it is not empty, iterate through until the sprite is either found (in which
     *  case update its positioning) or add it to the list if it is not already present.
     *  
     *  @param   elapsed is the time passed since last update
     *  @param   player is the sprite object
     *  @param   platform is the platform which the sprite object is touching
     */
    public function platformObjects(elapsed:Float, player:FlxObject, platform:Platforms):Void
    {
        // If there is nothing in the touching platform group, add this object
        if (countTouching == 0)
        {  
            var obj = new PlatformTracker(player, (player.x - platform.x));
            touchingSprites.push(obj);
			player.acceleration.y = heavy;
            countTouching++;
        }
        else
        {
            inContact = false;
            for (i in 0...countTouching)
            {
                if (touchingSprites[i].baseObj == player)
                {
                    inContact = true;
                    // Multiply velocity by elapsed to get the player's movement each frame.
                    touchingSprites[i].trackedOffsetX += player.velocity.x * elapsed;
                    player.x = platform.x + touchingSprites[i].trackedOffsetX;
                }
            }
            if (!inContact)
            {
                var obj = new PlatformTracker(player, (player.x - platform.x));
                touchingSprites.push(obj);
				player.acceleration.y = heavy;
                countTouching++;
            }
        }
    }

    /**
     *  Remove sprites NOT colliding with the platform. If objects are touching the platform, check that 
     *  this sprite is not one of them. If the object is found in the list of sprites touching, 
     *  remove it from the group and set its y acceleration back to Gravity as declared in PlayState.hx
     *  
     *  @param   elapsed is the time passed since last update
     *  @param   sprite is the sprite object not touching the platform
     *  @param   platform is the platform not being touched by the sprite
     *  @param   originalCount is the number of sprites in the group before any changes are made; used to 
     *  prevent changes to loop duration
     */
    private function notPlatformObjects(elapsed:Float, sprite:FlxObject, platform:Platforms):Void
    {
        if (countTouching != 0)
        {
			var originalCount:Int = countTouching;
            for (i in 0...originalCount)
            {
				var index:Int = originalCount - (1 + i);
                if (touchingSprites[index].baseObj == sprite)
                { 
                    sprite.acceleration.y = cast(FlxG.state, PlayState).GRAVITY;
                    touchingSprites.remove(touchingSprites[index]);
                    countTouching--;
                }
            }
        }
    }
	

    /**
     *  Function called on every update in PlayState.hx. Iterates through every sprite object on the map and 
     *  checks each to see if it is either touching or not touching the platform
     *  
     *  @param   objects is the list of all sprites present
     *  @param   platform is the platform with which sprites are checked for contact
     */
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

    /**
     *  Call movement function to determine movement of platform and update the platform's position
     *  
     */
    public override function update(elapsed:Float):Void
	{
        movement();
		super.update(elapsed);
	}
}