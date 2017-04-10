package;

import states.BaseState;
import states.PlayerGroundState;
import states.PlayerAirState;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

/**
 * ...
 * @author Sam Bumgardner
 */
 class Player extends FlxSprite
 {
  public var activeState:BaseState;

	public var xAccel:Float = 400;
	public var xMaxSpeed(default, set):Float;

	public var walkSpeed:Float = 100;
	public var runSpeed:Float = 200;

	public var xSlowdown:Float = 600;

	public var onGround:Bool = false;

	/**
	 * Intializer
	 *
	 * @param	X	Starting x coordinate
	 * @param	Y	Starting y coordinate
	 * @param	SimpleGraphic	Non-animating graphic. Nothing fancy (optional)
	 */
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);

		// Initializes a basic graphic for the player
		makeGraphic(32, 32, FlxColor.ORANGE);

		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;

		// Sets the starting x max velocity.
		xMaxSpeed = walkSpeed;

		// Initialize the finite-state machine with initial state
		activeState = new PlayerAirState();
	}

	/**
	 * Setter for the xMaxSpeed variable.
	 * Updates maxVelocity's x component to match the new value.
	 *
	 * @param	newXSpeed	The new max speed in the x direction.
	 * @return	The new value contained in xMaxSpeed.
	 */
	public function set_xMaxSpeed(newXSpeed:Float):Float
	{
		maxVelocity.x = newXSpeed;
		return xMaxSpeed = newXSpeed;
	}

	/**
	 * Update function.
	 *
	 * Responsible for calling the update method of the current state and
   * switching states if a new one is returned.
	 *
	 * @param	elapsed	Time passed since last call to update in seconds.
	 */
	public override function update(elapsed:Float):Void
	{
		var nextState = activeState.update(this);

    if (nextState != null)
    {
      activeState = nextState;
    }

		super.update(elapsed);
	}
}
