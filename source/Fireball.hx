package;
import flixel.FlxSprite;

/**
 * ...
 * @author Caleb Breslin
 */
class Fireball extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		trace("Behold, Fire");
		super(X, Y, AssetPaths.fireball__png);
		velocity.x = 300;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!isOnScreen())
			kill();
	}
}