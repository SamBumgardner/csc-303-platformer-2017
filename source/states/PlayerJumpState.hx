package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayerJumpState extends PlayerAirState
{
  public function new()
  {
    super();
    duration = 0.2; // set maximum jump time for 0.1 seconds
  }

  private override function transition(object:FlxObject):Bool
  {
    var player = cast(object, Player);

    // set default next state
    nextState = new PlayerFallState();

    if (!player.isJumping())
    {
      nextState = new PlayerFallState();
      return true;
    }
    return super.transition(object);
  }

  private override function action(object:FlxObject):Void
  {
    var player = cast(object, Player);

    if (player.isJumping())
    {
      player.acceleration.y = -300;
    }

    super.action(object);
  }
}
