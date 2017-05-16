package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

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
		var xOffsets:Array<Float> = [frameWidth / 4, frameWidth / 2, frameWidth , frameWidth*1.3, frameWidth*1.3];
		var yOffsets:Array<Float> = [ -frameHeight / 6, -frameHeight / 8, 0, frameHeight/6, frameHeight / 4];
		var angles:Array<Float> = [40, 60, 80, 100, 120];
		var frameLength:Array<Int> = [3, 6, 9, 12, 15 ];
		hitbox = new HitboxAnimationManager(xOffsets, yOffsets, angles, frameLength, this, SimpleGraphic, true);
		
	}
	
	
	/**
	 * Override update functio
	 * reset the weapon if the hitbox is done animating, but the player is still in the attack state
	 */
	public override function update(elapsed:Float):Void
	{       
		super.update(elapsed);
		if (equipped){
			facing = player_trace.facing;
			if (hitbox.animating == false && player_trace.attacking){
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
	}
	
	/**
	 * Reset the weapon to its original state. 
	 * Reset to player to a regular state and allow keys again
	 * @param	tween
	 */
	private function reset_weapon(){
	  player_trace.attacking = false;
	  FlxG.keys.enabled = true;
  }
}