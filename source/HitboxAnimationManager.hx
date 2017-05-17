package;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Cameron Yuan
 */
class HitboxAnimationManager extends FlxBasic
{
	public var hitboxFrames:FlxTypedGroup<FlxObject>;
	public var animating:Bool = false;

	private var frameHolder:Array<FlxObject>;
	private var xOffsets:Array<Float>;
	private var yOffsets:Array<Float>;
	private var widths:Array<Float>;
	private var heights:Array<Float>;
	private var reverseAngleOffsets:Array<Float>;
	private var frameLength:Array<Int>;
	private var currentFrame:Int = 0;
	private var frameCounter:Int = 0;
	private var ObjectReference:FlxSprite;
	private var direction:Int = -1;
	private var reverse:Bool;
	
	/**
	 * Be aware that FlxObjects will not be generated at an angle. Create multipl boxes on top of
	 * each other to achieve the desired effect
	 * @param	x_offsets -	Array of x offsets from the current position of the object
	 * @param	y_offsets - Array of y offsets from the current position of the object
	 * @param	widths - Array of widths for each box to be created
	 * @param	heights - Array of heights for each box to be created
	 * @param	frame_length - The amount of frames any given hitbox should show for. This is cumulative
	 * 							i.e. frame_length = [5,10,13]. Hitbox 1 will show for 5 frames. Hitbox 2 wil show for 
	 * 							5 frames (5+5=10). hitbox 3 will show for 3 frames (5+5+3=13)
	 * @param	referenceObject - The object for which the hitboxes are being made
	 * @param	graphic	- graphic for hitboxes? Might be optional if I can debug FlxObjects not being able to angle
	 * @param	reversible	- Bool if object show 'face' left and right
	 */
	public function new(x_offsets:Array<Float>, y_offsets:Array<Float>, broad:Array<Float>, tall:Array<Float>, 
						frame_length:Array<Int>, referenceObject:FlxSprite, graphic:FlxGraphicAsset, reversible:Bool = false) 
	{
		super();
		xOffsets = x_offsets;
		yOffsets = y_offsets;
		widths = broad;
		heights = tall;
		frameLength = frame_length;
		ObjectReference = referenceObject;
		reverse = reversible;

		var hitbox;
		//create and store the hitboxes
		frameHolder = new Array<FlxObject>();
		hitboxFrames = new FlxTypedGroup<FlxObject>();
		for (i in 0...xOffsets.length){
			hitbox = new FlxObject(ObjectReference.x + xOffsets[i], ObjectReference.y + yOffsets[i], widths[i], heights[i]);
			//hitbox = new FlxSprite(ObjectReference.x + xOffsets[i], ObjectReference.y, graphic);
			hitbox.exists = false;
			frameHolder.push(hitbox);
			hitboxFrames.add(frameHolder[i]);
		}
	}
	
	/**
	 * Override update.
	 * If the object is reverible, make sure the hitboxes face the correct direction
	 * Update the hitboxes relative to the object they reference.
	 * If activated, increment the frameCounter and display the appropriate hitbox
	 * @param	elapsed
	 */
	public override function update(elapsed:Float):Void
	{       
		super.update(elapsed);
		if(reverse){
			if (ObjectReference.facing == FlxObject.LEFT){
				direction = -1;
			}
			else
			{
				direction = 1;
			}
		}
		for (i in 0...frameHolder.length){
			frameHolder[i].x = ObjectReference.x + xOffsets[i] * direction;
			frameHolder[i].y = ObjectReference.y + yOffsets[i];
		}
		if (animating){
			animateFrames();			
		}
	}
	
	/**
	 * Shows the current frame based on frame length
	 *  After all hitboxes have shown for the appropriate number of frames, reset
	 */
	public function animateFrames(){
		frameHolder[currentFrame].exists = true;
		frameCounter = frameCounter + 1;
		if (frameCounter >= frameLength[frameLength.length - 1]){
			frameHolder[frameHolder.length - 1].exists = false;
			animating = false;
			frameCounter = 0;
			currentFrame = 0;	
		}
		else if (frameCounter >= frameLength[currentFrame]){
			currentFrame = currentFrame + 1;
			animateFrames();
			frameHolder[currentFrame-1].exists = false;
		}
	}
}