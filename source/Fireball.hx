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
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!isOnScreen())
			kill();
		else
			velocity.x = 300;
	}
}