package;

/**
 * ...
 * @author Dillon Woollums
 */
import flixel.input.gamepad

class ReconfigurableController 
{
	private var theGamepad:FlxGamepad;
	private var jumpButton:String;
	private var runButton:String;
	private var right:String;
	private var left:String;
	private var up:String;
	private var down:String;
	
	public function new() 
	{
		
		theGamepad = new FlxGamepad; //TODO: init gamepad
	}
	
	private function getButton(buttonName:String):Bool
	{
		switch(buttonName)
		{
		case "A": return theGamepad.pressed.A;
		case "B": return theGamepad.pressed.B;
		case "BACK": return theGamepad.pressed.BACK;
		case "DPAD_DOWN": return theGamepad.pressed.DPAD_DOWN;
		case "DPAD_LEFT": return theGamepad.pressed.DPAD_LEFT;
		case "DPAD_RIGHT": return theGamepad.pressed.DPAD_RIGHT;
		case "DPAD_UP": return theGamepad.pressed.DPAD_UP;
		case "EXTRA_0": return theGamepad.pressed.EXTRA_0;
		case "EXTRA_1": return theGamepad.pressed.EXTRA_1;
		case "EXTRA_2": return theGamepad.pressed.EXTRA_2;
		case "EXTRA_3": return theGamepad.pressed.EXTRA_3;
		case "LEFT_SHOULDER": return theGamepad.pressed.LEFT_SHOULDER;
		case "LEFT_STICK_CLICK": return theGamepad.presssed.LEFT_STICK_CLICK;
		case "LEFT_TRIGGER": return theGamepad.pressed.LEFT_TRIGGER;
		case "RIGHT_SHOULDER": return theGamepad.presssed.RIGHT_SHOULDER;
		case "RIGHT_STICK_CLICK": return theGamepad.pressed.RIGHT_STICK_CLICK;
		case "RIGHT_TRIGGER": return theGamepad.pressed.RIGHT_TRIGGER;
		case "START": return theGamepad.pressed.START;
		case "X": return theGamepad.pressed.X;
		case "Y": return theGamepad.pressed.Y;
		}
	}
	
	private function loadConfiguration(){
		
	}
	
}