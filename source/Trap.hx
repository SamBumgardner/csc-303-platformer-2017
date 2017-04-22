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
    private var subtrap1:Trap;
    private var subtrap2:Trap;
    private var subtrap3:Trap;

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

        // Initializes a basic graphic for the Trap
        makeGraphic(32, 32, FlxColor.RED);  

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


    //Builds flame bar - adds tweens (WIP)
    public function barCreate(trap1:Trap, trap2:Trap, trap3:Trap, x:Float, y:Float)
    {
        
        subtrap1 = trap1;
        subtrap2 = trap2;
        subtrap3 = trap3;
        
        FlxTween.circularMotion(subtrap1, x, y, 96, 0, true, 10, true, { type: FlxTween.LOOPING });
        FlxTween.circularMotion(subtrap2, x, y, 64, 0, true, 10, true, { type: FlxTween.LOOPING });
        FlxTween.circularMotion(subtrap3, x, y, 32, 0, true, 10, true, { type: FlxTween.LOOPING });
    }

    //Overlap Resolution (WIP)
    public function playerTrapResolve(player:Player, trap:Trap):Void
    {
        //player.takeHit()
        player.kill();
    }

 }