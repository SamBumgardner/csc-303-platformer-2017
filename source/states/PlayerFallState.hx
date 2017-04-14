package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayerFallState extends PlayerGroundState
{
  static private var SLOW_DOWN:Int = 150;

  public function new()
  {
    super();
  }

  private override function transition(object:FlxObject)
  {
    var player = cast(object, Player);

    if (player.isOnGround())
    {
      nextState = new PlayerGroundState();
      return true;
    }
    return false;
  }

  public override function enter(object:FlxObject):Void
  {
    if (object.velocity.y < -SLOW_DOWN)
    {
      object.velocity.y = -SLOW_DOWN;
    }
  }

  private override function action(object:FlxObject):Void
  {
    super.action(object);
  }
}
