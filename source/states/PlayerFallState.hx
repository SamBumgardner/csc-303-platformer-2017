package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayerFallState extends PlayerGroundState
{
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

  private override function action(object:FlxObject):Void
  {
    super.action(object);
  }
}
