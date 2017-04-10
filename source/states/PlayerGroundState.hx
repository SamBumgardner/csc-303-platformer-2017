package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayerGroundState extends PlayerState
{
  public function new()
  {
    super();

    onGround = true;
  }

  private override function transition():Bool
  {
    // Determine if attempted to jump
    var attemptedJump:Bool = FlxG.keys.anyJustPressed([FlxKey.X, FlxKey.SLASH]);

    if (attemptedJump)
    {
      nextState = new PlayerAirState();
      return true;
    }
    return super.transition();
  }

  private override function action(object:FlxObject):Void
  {
    var player = cast(object, Player);
    var horizontalMove:Int = pollForHorizontalMove();

    if (isPlayerRunning())
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
