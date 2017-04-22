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

 class PlatformTracker extends Player
 {
    public var trackedOffsetX:Float;
    public var baseObj:FlxObject;

    /** 
     *  Initialize the new PlatformTracker object and set its variables to the requested initial values.
     *  
     *  @param trackedOffsetX is the difference in the x position of the platform
     *  and the x position of the object when it first touches the platform
     *  @param baseObj is the base player/enemy sprite object which is built upon
     *  in this class
     */
    public function new(?obj:FlxObject, ?offsetX:Float = 0)
	{
        super(); 

        trackedOffsetX = offsetX;
        baseObj = obj;
    }
 }