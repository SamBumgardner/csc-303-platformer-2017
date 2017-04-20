package;

import states.FSM;
import states.BaseState;
import states.PlayerGroundState;
import states.PlayerAirState;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;

/**
 * ...
 * @author Sam Bumgardner
 */
 class Player extends FlxSprite
 {
  public var brain:FSM;

	public var xAccel:Float = 400;
	public var xMaxSpeed(default, set):Float;

	public var walkSpeed:Float = 100;
	public var runSpeed:Float = 200;

	public var xSlowdown:Float = 600;

  public var hitBoxComponents:FlxTypedGroup<FlxObject>;
  public var topBox:FlxObject;
  public var btmBox:FlxObject;

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
		brain = new FSM( new PlayerAirState() );

    // Multiple hitbox support
    hitBoxComponents = new FlxTypedGroup<FlxObject>(2);
    topBox = new FlxObject(X + 1, Y, width - 2, 3);
    btmBox = new FlxObject(X + 1, Y + height - 4, width - 2, 3);
    hitBoxComponents.add(topBox);
    hitBoxComponents.add(btmBox);
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
		brain.update(this);
		super.update(elapsed);
    updateHitBoxes();
	}

  /**
   * Convenience method for polling for horizontal movement as
   * most of the player states need to take it into account
   *
   * @return scalar value of the players next horizontal move
   */
  public function pollForHorizontalMove():Int
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
   * Convenience method for checking if a jump is being requested.
   *
   * @return boolean value for if the jump key is being held
   */
  public function isJumping():Bool
  {
    return FlxG.keys.anyPressed([FlxKey.X, FlxKey.SLASH]);
  }

  /**
   * Convenience method for checking if the player is currently touching a
   * surface from above the surface.
   *
   * @return boolean value for if the player is touching a surface from above
   *         the surface
   */
  public function isOnGround():Bool
  {
    return isTouching(FlxObject.DOWN);
  }

  /**
   * Convenience method for checking if the player is running
   *
   * @ return boolean value for if the run key is eing held
   */
  public function isRunning():Bool
  {
    return FlxG.keys.anyPressed([FlxKey.Z]);
  }

  private function updateHitBoxes():Void
  {
    var hitBoxHeight = 3;
    var hitBoxOffset = 1;
    var hitBoxWidth = width - hitBoxOffset * 2;
    var hitBoxX = x + hitBoxOffset;

    topBox.x = btmBox.x = hitBoxX;
    topBox.y = y + hitBoxOffset;
    btmBox.y = y + height - hitBoxOffset - hitBoxHeight;
  }
}
