package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayerGroundState extends BaseState
{
  public function new()
  {
    super();
  }

  private override function transition(object:FlxObject):Bool
  {
    var player = cast(object, Player);
    var attemptedJump:Bool = player.isJumping();

    if (attemptedJump)
    {
      nextState = new PlayerJumpState();
      return true;
    }

    return super.transition(object);
  }

  private override function action(object:FlxObject):Void
  {
    var player = cast(object, Player);
    var horizontalMove:Int = player.pollForHorizontalMove();

    if (player.isRunning())
    {
      player.xMaxSpeed = player.runSpeed;
    }
    else
    {
      player.xMaxSpeed = player.walkSpeed;
    }

    // If horizontalMove is -1, the Player should move left.
    if (horizontalMove == -1)
    {
      if (player.velocity.x > 0)
      {
        player.acceleration.x = -player.xSlowdown + -player.xAccel;
      }
      else
      {
        player.acceleration.x = -player.xAccel;
      }
    }

    // If horizontalMove is 1, the Player should move right.
    else if (horizontalMove == 1)
    {
      if (player.velocity.x < 0)
      {
        player.acceleration.x = player.xSlowdown + player.xAccel;
      }
      else
      {
        player.acceleration.x = player.xAccel;
      }
    }

    // Slow down if no direction held
    else if (horizontalMove == 0)
    {
      if (player.velocity.x > 0)
      {
        if (player.velocity.x <= player.xSlowdown * FlxG.elapsed)
        {
          player.velocity.x = 0;
          player.acceleration.x = 0;
        }
        else
        {
          player.acceleration.x = -player.xSlowdown;
        }
      }
      else if (player.velocity.x < 0)
      {
        if (player.velocity.x >= -player.xSlowdown * FlxG.elapsed)
        {
          player.velocity.x = 0;
          player.acceleration.x = 0;
        }
        else
        {
          player.acceleration.x = player.xSlowdown;
        }
      }
    }
    #if debug // Only compile this code into a debug version of the game.

    // Display an error message in the console if an invalid horizontalMove
    // 	value is detected.
    else
    {
      trace("ERROR: An invalid value for horizontalMove (" +
      horizontalMove + ") found for this action");
    }

    #end // End of the conditional compilation section.
  }
}
