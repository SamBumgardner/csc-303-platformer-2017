package;

/**
 * ...
 * @author Dillon Woollums
 */
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HeadsUpDisplay extends FlxGroup
{
	private var scoreLabel:FlxText;
	private var timeLabel:FlxText;
	private var coinIcon:FlxSprite;
	private var coinCross:FlxText;
	private var score:FlxText;
	private var time:FlxText;
	private var coins:FlxText;
	//This class is a static member of PlayState, and should be called from there.
	
	/**
	 * Creates a HUD, which cointains the score display, coins, and time remaining.
	 * @param	x	The X coordinate of the top left of the HUD
	 * @param	y	The Y coordinate of the top left of the HUD
	 * @param	playerName The name displayed above the score. Will be converted to upper case.
	 */
	public  function new(x:Int, y:Int, playerName:String) 
	{
		//creates a HUD
		super();
		//put the player name in the top left
		scoreLabel = new FlxText(0 + x, 0 + y, 100, playerName.toUpperCase(), 16);
		scoreLabel.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 3);
		//put the score below the player name
		score = new FlxText(0 + x, 16 + y, 100, "00000000", 16);
		score.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 3);
		//put the time label in the top right
		timeLabel = new FlxText(580 + x, 0 + y, 100, "TIME", 16);
		timeLabel.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 3);
		//put the time below the time label
		time = new FlxText(597 + x, 16 + y, 100, "000", 16);
		time.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 3);
		//the "X" in the coin counter
		coinCross = new FlxText(300 + x, 0 + y, 20, "X", 16);
		coinCross.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 3);
		//number of coins to the right of the X
		coins = new FlxText (316 + x, 0 + y , 50, "00", 16);
		//the coin icon
		coins.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 3);
		coinIcon = new FlxSprite(285 + x, 3 + y, AssetPaths.coinIcon__png);
		
		//add everything to the group.
		add(scoreLabel);
		add(score);
		add(timeLabel);
		add(time);
		add(coinCross);
		add(coins);
		add(coinIcon);
		
		forEach(function(hudObject:FlxBasic){(cast hudObject).scrollFactor.set(0, 0); });
	}
	
	/**
	 * Changes the displayed time in 3 digit form. If the input newTime is more than 3 digits, will display last 3 digits.
	 * Update still needs to be called after this to actually update the HUD.
	 * @param	newTime The time you want displayed on the HUD. Displays last 3 digits of number.
	 */
	private function handleTimeUpdate(newTime:Int):Void{
		//trim number down to last 3 digits if over 3 digits
		var parsedTime:String = Std.string(newTime);
		var timeString:String = "000";
		var parsedLength:Int = parsedTime.length;
		if (timeString.length > parsedLength){
			timeString = timeString.substr(0, -parsedLength) + parsedTime;
		}
		else{
			timeString = parsedTime.substr(-3);
		}
		time.text = timeString;
	}
	/**
	 * Changes the displayed coin count. Will be last 2 digits of coin count. Leading zeroes will be added if less than 2 digits.
	 * Update still needs to be called after this to actually update the HUD.
	 * @param	newCoinCount the coin count you want displayed on the HUD. Displays last 2 digits of number.
	 */
	public function handleCoinsUpdate(newCoinCount:Int){
		//trim number down to last 2 digits if over 2 digits
		var parsedCoins:String = Std.string(newCoinCount);
		var coinString:String = "00";
		var parsedLength:Int = parsedCoins.length;
		if (coinString.length > parsedLength){
			coinString = coinString.substr(0, -parsedLength) + parsedCoins;
		}
		else{
			coinString = parsedCoins.substr(-2);
		}
		coins.text = coinString;
	}
	
	/**
	 * Updates the displayed score. Will display the last 8 digits of the score. Leading zeroes will be added if less than 8 digits.
	 * Update still needs to be called after this to actually update the HUD.
	 * @param	newScore the score you want displayed on the HUD. Displays last 8 digits of number.
	 */
	public function handleScoreUpdate(newScore:Int){
		//trim number down to last 8 digits if over 8 digits
		var parsedScore:String = Std.string(newScore);
		var scoreString:String = "00000000";
		var parsedLength:Int = parsedScore.length;
		if (scoreString.length > parsedLength){
			scoreString = scoreString.substr(0, -parsedLength) + parsedScore;
		}
		else{
			scoreString = parsedScore.substr(-scoreString.length);
		}
		score.text = scoreString;
	}
	
	/**
	 * Updates the hud for the new frame.
	 * @param	elapsed
	 */
	
	public override function update(elapsed:Float):Void
	{
		//UPDATES
		scoreLabel.update(elapsed);
		timeLabel.update(elapsed);
		coinIcon.update(elapsed);
		coinCross.update(elapsed);
		score.update(elapsed);
		time.update(elapsed); 
		coins.update(elapsed);
		super.update(elapsed);
		
	}
}