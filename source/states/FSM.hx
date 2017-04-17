package states;

import flixel.FlxObject;

class FSM
{
  public var activeState:BaseState;

  public function new(initState:BaseState)
  {
    activeState = initState;
  }

  public function update(object:FlxObject):Void
  {
    var nextState = activeState.update(object);

    if (nextState != null)
    {
      activeState = nextState;
    }
  }
}
