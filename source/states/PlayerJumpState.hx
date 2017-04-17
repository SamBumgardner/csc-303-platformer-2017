package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayerJumpState extends PlayerAirState
{
  static private var JUMP:Int = 400;
  
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

  public override function enter(object:FlxObject):Void
  {
      var player = cast(object, Player);
      player.velocity.y = -JUMP;
  }
}
