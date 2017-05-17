package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;

class Trap extends FlxSprite
 {
    private var baseTrap:Trap;
    private var subtrap1:Trap;
    private var subtrap2:Trap;
    private var subtrap3:Trap;
  
    private var h:Int = 0;
    private var w:Int = 0;

    public var _grpBarTrap = new FlxTypedGroup<Trap>();
    

    /**
     * Intializer
     *
     * @param	X	Starting x coordinate
     * @param	Y	Starting y coordinate
     * @param	SimpleGraphic	Non-animating graphic. Nothing fancy (optional)
     */
    public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
    {
        super(X, Y, SimpleGraphic);

        //Values for the height and width of the sprite
        h = 16;
        w = 16;

        // Initializes a basic graphic for the Trap using the h, and w values
        makeGraphic(w, h, FlxColor.RED);  

    }

    /**
	 * Update function.
	 *
	 * Responsible for calling the update method of the current state and
     * switching states if a new one is returned.
	 *
	 * @param	elapsed	Time passed since last call to update in seconds.
	 */
	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);
    
	}

     /**
	 * buildTrap function.
	 *
	 * Builds the Trap framework based on original trap and adds it to its own FlxGroup
	 *
	 * @param	primeTrap	The original trap created in the playstate
	 */
    public function buildTrap(primeTrap:Trap){
        primeTrap._grpBarTrap.add(primeTrap);
        primeTrap._grpBarTrap.add(primeTrap.getSubtrap(1));
        primeTrap._grpBarTrap.add(primeTrap.getSubtrap(2));
        primeTrap._grpBarTrap.add(primeTrap.getSubtrap(3));
    }
    
     /**
	 * getSubtrap function.
	 *
	 * Creates and returns subsections of the fire bar trap
	 *
	 * @param	num	The num id of the subtrap you want to get()
	 */
    public function getSubtrap(num:Int):Trap{
        if(num == 1){
            subtrap1 = new Trap();
            return subtrap1;
        }
        else if(num == 2){
            subtrap2 = new Trap();
            return subtrap2;
        }
        else if(num == 3){
            subtrap3 = new Trap();
            return subtrap3;
        }
        else {
            baseTrap = new Trap();
            return baseTrap;
        }
    }
    
      /**
	 * placeTrap function.
	 *
     * Builds flame bar - via tweening
     *  
     *  This adds circular animation to each subsection of the bar
     *  Adds a sub trap to a circular motion tween, sets its radius of rotation based off of the original sprite's height (h)
     *  Sets the rotation time to 10 sec.
	 *
	 * @param	_grpBarTrap	The FlxGroup in which the parts of the flame bar are stored
     * @param	x	The x value for the location of the center of the flame bar
     * @param	y	The y value for the location of the center of the flame bar
	 */
    public function placeTrap(?_grpBarTrap:FlxTypedGroup<Trap>, ?x:Float, ?y:Float)
    {
        FlxTween.circularMotion(_grpBarTrap.members[1], x, y, (h*3), 0, true, 10, true, { type: FlxTween.LOOPING });
        FlxTween.circularMotion(_grpBarTrap.members[2], x, y, (h*2), 0, true, 10, true, { type: FlxTween.LOOPING });
        FlxTween.circularMotion(_grpBarTrap.members[3], x, y, h, 0, true, 10, true, { type: FlxTween.LOOPING });
    }

      /**
	 * overlap function.
	 *
     * This function resolves the overlap of the player and the trap
	 * 
     * @param	player	The player character object
     * @param	trap	The trap object
	 */
    public function playerTrapResolve(player:Player, trap:Trap):Void
    {
        //This is a call to the player's damage function
        //player.takeHit() 

        //This is for testing only
        player.kill();
    }

 }