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

    public function new(?obj:FlxObject, ?offsetX:Float = 0)
	{
        super(); 
        trackedOffsetX = offsetX;  
        baseObj = obj;    
    }

    public function returnOffset():Float
    {
        return trackedOffsetX;
    }

    public function returnBase():FlxObject
    {
        return baseObj;
    }
 }