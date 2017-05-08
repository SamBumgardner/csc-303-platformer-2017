package;

/**
 * ...
 * @author Dillon Woollums
 */
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

typedef ControlConfig = {
	var jump:String;
	var run:String;
	var left:String;
	var right:String;
	var up:String;
	var down:String;
}

class ReconfigurableController 
{
	private var theGamepad:FlxGamepad;
	private var jumpButton:String;
	private var runButton:String;
	private var right:String;
	private var left:String;
	private var up:String;
	private var down:String;
	private var gamepadExists:Bool;
	
	public function new() 
	{
		
		theGamepad = FlxG.gamepads.getByID(0);
		if (theGamepad == null){
			gamepadExists = false;
		}
		else{
			gamepadExists = true;
			loadConfiguration();
		}
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
		case "LEFT_STICK_CLICK": return theGamepad.pressed.LEFT_STICK_CLICK;
		case "LEFT_TRIGGER": return theGamepad.pressed.LEFT_TRIGGER;
		case "RIGHT_SHOULDER": return theGamepad.pressed.RIGHT_SHOULDER;
		case "RIGHT_STICK_CLICK": return theGamepad.pressed.RIGHT_STICK_CLICK;
		case "RIGHT_TRIGGER": return theGamepad.pressed.RIGHT_TRIGGER;
		case "START": return theGamepad.pressed.START;
		case "X": return theGamepad.pressed.X;
		case "Y": return theGamepad.pressed.Y;
		default:{
			#if debug
				trace("CONTROL CONFIG SET TO INVALID ID: " + buttonName);
			#end
			return false;
		}
		}
	}
	
	private function loadConfiguration(){
		var fname:String = "config/Controls.ini";
		if (FileSystem.exists(fname)){
			var config:ControlConfig = Json.parse(File.getContent(fname));
			jumpButton = config.jump;
			runButton = config.run;
			right = config.right;
			left = config.left;
			up = config.up;
			down = config.down;
		}
		else{
			trace("CONTROL CONFIG DOES NOT EXIST AT:"+FileSystem.absolutePath(fname));
			jumpButton = "A";
			runButton = "X";
			right = "DPAD_RIGHT";
			left = "DPAD_LEFT";
			up = "DPAD_UP";
			down = "DPAD_DOWN";
			
		}
		
	}
	
	public function isJumping(){
		return getButton(jumpButton);
	}
	
	public function isRunning(){
		return getButton(runButton);
	}
	
	public function isLeft(){
		return getButton(left);
	}
	
	public function isRight(){
		return getButton(right);
	}
	
	public function isUp(){
		return getButton(up);
	}
	
	public function isDown(){
		return getButton(down);
	}
	
	
}