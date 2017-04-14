package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayerJumpState extends PlayerAirState
{
  public function new()
  {
    super();
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
}
