package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

/**
 * SWORDS!!!!!!
 * @author Cameron Yuan
 */
class Sword extends Item 
{
	
	
	public var hitbox:HitboxAnimationManager;
	
	 
	/**
	 * Constructor method for Sword class
	 * @param	X
	 * @param	Y
	 * @param	SimpleGraphic - Optional
	 */
	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		weildable = true;
		
		//Create hitbox parameters and create the Frame animation manager
		//var angles:Array<Float> = [40, 60, 80, 100, 120];
		var xOffsets:Array<Float> = [frameWidth / 4, frameWidth / 2, frameWidth , frameWidth, frameWidth];
		var yOffsets:Array<Float> = [ -frameHeight / 8, 0, frameHeight / 6, frameHeight / 4, frameHeight / 2];
		var widths:Array<Float> = [frameHeight * 4 / 9, frameHeight * 6 / 9, frameHeight * 8 / 9, frameHeight, frameHeight * 7/9];
		var heights:Array<Float> = [frameWidth * 9 / 4, frameWidth * 9 / 6, frameWidth * 9 / 8, frameWidth * 9 / 10, frameWidth * 3 / 4];
		var frameLength:Array<Int> = [3, 6, 9, 12, 15 ];
		hitbox = new HitboxAnimationManager(xOffsets, yOffsets, widths, heights, frameLength, this, SimpleGraphic, true);
		
	}
	
	
	/**
	 * Override update functio
	 * reset the weapon if the hitbox is done animating, but the player is still in the attack state
	 */
	public override function update(elapsed:Float):Void
	{       
		super.update(elapsed);
		if (equipped){
			facing = (cast (FlxG.state, PlayState)).player.facing;
			if (hitbox.animating == false && (cast (FlxG.state, PlayState)).player.attacking){
				reset_weapon();
			}
		}
	}
	
	/**
	 * playstate collide function. If it hits the enemy, kill them. 
	 * It is assumed the player is attacking when this is used
	 * @param	sword
	 * @param	enemy
	 */
	public function hit_enemy(sword:Sword, enemy:Enemy){
		if (equipped){
			enemy.kill();
		}	
	}
	
	/**
	 * Begin attack state animations
	 */
	public override function attack(){
		hitbox.animating = true;
		visible = false;
	}
	
	/**
	 * Reset the weapon to its original state. 
	 * Reset to player to a regular state and allow keys again
	 * @param	tween
	 */
	private function reset_weapon(){
	  new FlxTimer().start(.4, function(timer: FlxTimer){(cast (FlxG.state, PlayState)).player.attacking = false; }, 1);  
  }
}