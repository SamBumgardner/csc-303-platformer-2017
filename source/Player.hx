package;

import haxe.Timer;
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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.TweenOptions;

/**
 * ...
 * @author Sam Bumgardner
 */
 class Player extends FlxSprite
 {
	public var brain:FSM;
	public var player:FlxSprite;

	public var xAccel:Float = 400;
	public var xMaxSpeed(default, set):Float;

	public var walkSpeed:Float = 100;
	public var runSpeed:Float = 200;

	public var xSlowdown:Float = 600;
	
	public var coinCount:Int = 0;
	public var scoreTotal:Int = 0;

	public var hitBoxComponents:FlxTypedGroup<FlxObject>;
	public var topBox:FlxObject;
	public var btmBox:FlxObject;
	public var canTakeDamage:Bool = true;
  
	private var hitBoxHeight:Int = 3;
	private var hitBoxWidthOffset:Int = 4;  //how much narrower the hitboxes are than the player
  
  // Variable used for overlap/collide logic with enemies. Checks if player is holding the star powerup.
	public var star:Bool = false;
	
	public var invincibleTimer:Float = 0;
	public var hurtInvincibility:Float = 2;
	public var hasFlower:Bool = false;
	public var tween:FlxTween;
  
  
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
		player = makeGraphic(32, 32, FlxColor.ORANGE);

		// Initialize gravity. Assumes the currentState has GRAVITY property.
		acceleration.y = (cast FlxG.state).GRAVITY;
		maxVelocity.y = acceleration.y;

		// Sets the starting x max velocity.
		xMaxSpeed = walkSpeed;

		// Initialize the finite-state machine with initial state
		brain = new FSM( new PlayerAirState() );

    // Multiple hitbox support
    hitBoxComponents = new FlxTypedGroup<FlxObject>(2);
    topBox = new FlxObject(X + hitBoxWidthOffset, Y, width - hitBoxWidthOffset*2, hitBoxHeight);
    btmBox = new FlxObject(X + hitBoxWidthOffset, Y + height - hitBoxHeight, width - hitBoxWidthOffset*2, hitBoxHeight);
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
		// Implements an invincibilty timer to make the player temprarily invulnerable for a time after being hurt
		if (invincibleTimer > 0)
		{
			// If there is still time left on the timer, continue counting down
			invincibleTimer -= elapsed;
		}
		else if (invincibleTimer <= 0)
		{
			// When the timer runs out, the player is able to take damage again
			invincibleTimer = 0;
			canTakeDamage = true;
		}
		
		if (hasFlower)
		{
			if (FlxG.keys.anyJustPressed([FlxKey.SPACE, FlxKey.ENTER]))
			{
				new Fireball(x, y);
				trace("Fire");
			}
		}
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
   
  /**
   * When the coin gets collected, the update function in the playstate will call collectCoin.
   * collectCoin will then call this function based on the color of the coin collected.
   * Depending on the coin collected, then the respective total will be incremented.
   * @param	color The color of the coin being collected
   */
  public function scoreCoin(color:FlxColor):Void 
  {
	if (color == FlxColor.RED) {
		coinCount += 5;
		scoreTotal += 500;
	}
	if (color == FlxColor.YELLOW) {
		coinCount += 1;
		scoreTotal += 100;
	}
  }
    
  /**
   * This method is called during every Player update cycle
   * to keep the hitboxes in the same position relative to the player
   */
  private function updateHitBoxes():Void
  {
    topBox.x = btmBox.x = x + hitBoxWidthOffset;
    topBox.y = y;
    btmBox.y = y + height - hitBoxHeight;
  }
  
  /**
   * Overrides the parent "hurt" function to use the implement invincibilty timer
   * @param	damage - the amount of damage dealth by whatever enemy or object caused the damamge
   */
  override public function hurt(damage:Float)
  {
	  var options:TweenOptions = { type: FlxTween.PINGPONG};
	  if (canTakeDamage)
	  {
		  // Damages player
		 super.hurt(damage);
		 // Makes player invulnerable
		 canTakeDamage = false;
		 // Starts the invicibility timer
		 invincibleTimer = hurtInvincibility;
		//tween = FlxTween.color(player, .1, FlxColor.ORANGE, FlxColor.TRANSPARENT, options);
	  }  
  } 
}
