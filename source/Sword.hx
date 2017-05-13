package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxPath;

/**
 * SWORDS!!!!!!
 * @author Cameron Yuan
 */
class Sword extends Item 
{
	
	
	public var blade_hitbox:FlxObject;
	
	 
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
		//frameHeight -6 for the sword grip offset.
		blade_hitbox = new FlxObject(X, Y, frameWidth, frameHeight - 6);

		
	}
	
	public override function update(elapsed:Float):Void
	{       
		super.update(elapsed);
		if(equipped){
			update_sword_hitbox();
		}
	}
	
	public function update_sword_hitbox(){
		blade_hitbox.x = x;
		blade_hitbox.y = y;
	}
	
	public function hit_enemy(sword:Sword, enemy:DontTouchMe){
		if(equipped){
			if (player_trace.attacking){
				enemy.kill();
			}
		}
		
	}
	
	public override function attack_state(){
		super.attack_state();
		if (player_trace.facing == FlxObject.LEFT) {
			FlxTween.angle(this, 360, 270, .5, {
			onComplete: reset_weapon,
			type: FlxTween.ONESHOT
		});
		} 
		else {
			swing(270, 275, 0, 1);
			/*FlxTween.angle(this, 0, 90, .5, {
			onComplete: reset_weapon,
			type: FlxTween.ONESHOT
		});*/
		}
	}
	
	private function swing(startAngle:Float, endAngle:Float, iteration:Int, direction:Int){
		if (iteration < 10){
			this.path = new FlxPath().start([new FlxPoint(player_trace.x, player_trace.y), new FlxPoint(player_trace.x+50, player_trace.y+50)], 1, FlxPath.FORWARD);
			trace(iteration);
			/*var radius = 16;
			var angle1:Float = startAngle * Math.PI / 180;
			trace(angle1);
			var angle2:Float = endAngle * Math.PI / 180;
			var startX:Float = (player_trace.x+player_trace.frameWidth)+radius * Math.cos(angle1);
			var startY:Float = (player_trace.y+player_trace.frameHeight)+radius* Math.sin(angle1);
			var endX:Float = (player_trace.x+player_trace.frameWidth)+radius* Math.cos(angle2);
			var endY:Float = (player_trace.y+player_trace.frameHeight)+radius * Math.sin(angle2);
			this.path = new FlxPath().start([new FlxPoint(startX, startY), new FlxPoint(endX, endY)], .017, FlxPath.FORWARD);
			this.path.onComplete = function(path:FlxPath):Void{trace("Path complete");  swing(endAngle, endAngle+5, iteration + 1, 1); };*/
		} else {
			reset_weapon();
		}
		
	}
	
	private function reset_weapon(?tween:FlxTween){
	  angle = 0;
	  player_trace.attacking = false;
	  FlxG.keys.enabled = true;
	  item_activated = false;
  }
}