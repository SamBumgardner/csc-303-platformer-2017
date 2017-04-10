package states;

import flixel.FlxObject;

/**
 * As a note, a state should be responsible for calling its nextState's enter
 * method, and also responsible for calling its own exit method
 *
 * @author Garren Ijames
 */
class BaseState
{
  public  var nextState:Null<BaseState>;

  private var duration:Int;

  public function new()
  {
    duration = -1;
  }

  /**
   * ...
   */
  public function update(object:FlxObject):Null<BaseState>
  {
    if (!transition())
    {
      action(object);
      return null;
    }
    else
    {
      exit(object);
      nextState.enter(object);
      return nextState;
    }
  }

  /**
   * Transition is where the specific transition rules go for each state that
   * extends this base class. The transition state should be responsible for
   * setting the state's nextState as a precondition for returning true.
   *
   * @return boolean value for if it is time to transition to the next state.
   */
  private function transition():Bool
  {
     if (duration > 0)
     {
       duration -= 1;
     }

     else if (duration == 0)
     {
       return true;
     }

     return false;
  }

  /**
   * ...
   */
  public function enter(object:FlxObject):Void
  {}

  /**
   * ...
   */
  private function action(object:FlxObject):Void
  {}

  /**
   * ...
   */
  private function exit(object:FlxObject):Void
  {}
}
