package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

class PlayerState extends BaseState
{
  private var isRunning:Bool;
  private var onGround:Bool;

  public function new()
  {
    isRunning = false;

    // This initial value might change depending upon how levels begin
    onGround  = false;

    super();
  }

  /**
   * Convenience method for polling for horizontal movement as
   * most of the player states need to take it into account
   *
   * @return scalar value of the players next horizontal move
   */
  private function pollForHorizontalMove():Int
  {
    var step:Int = 0;

    if (FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.A]))
    {
      step--;
    }
    if (FlxG.keys.anyPressed([FlxKey.RIGHT, FlxKey.D]))
    {
      step++;
    }

    return step;
  }

  /**
   * Convenience method for checking if the player is running for use
   * within player states that extend this base class
   *
   * @return boolean value for if the player is running or not
   */
   public function isPlayerRunning():Bool
   {
     return FlxG.keys.anyPressed([FlxKey.Z]);
   }

   /**
    * Convenience method for checking if the player is touching the ground. Many
    * player related states that extend one might need this information
    *
    * @return boolean value for if the player is touching the ground or not
    */
    public function isPlayerOnGround():Bool
    {
      return (cast FlxG.state).player.isTouching(FlxObject.DOWN);
    }
}
