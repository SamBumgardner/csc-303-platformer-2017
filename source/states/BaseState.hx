package states;

import flixel.FlxObject;

/**
 * General state class for representing states for any generic FlxObject
 *
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
   * If it is not yet time to enter into a new state, this state's specific
   * actions are executed. Otherwise this state is first exited, the next state
   * is entered, and then returned.
   *
   * @param object The FlxObject this state belongs to
   * @return The next state for the object to enter into or null
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
   * This method should be called on the FlxObject entering the state extending
   * this base class. Properties that need to be changed one upon entering the
   * state should be set here
   *
   * @param object The FlxObject this state belongs to
   */
  public function enter(object:FlxObject):Void
  {}

  /**
   * The regular actions for this state to perform on the object it belongs to.
   *
   * @param object The FlxObject this state belongs to
   */
  private function action(object:FlxObject):Void
  {}

  /**
   * The exit method should reset to an appropriate value any variables of the
   * object this state belongs to that were perhaps changed in the enter method
   * or during the regular state actions
   *
   * @param object The FlxObject this state belongs to
   */
  private function exit(object:FlxObject):Void
  {}
}
