# Final Project Proposal

## Feature branch name:
ControlAndSound

## Planned Features:
* Gamepad Input (Xbox360/Xbox One),
* Reactive Sound API

## Classes to Implement:
### Gamepad Input
#### XboxController
Doesn't inherit from everything

Redefinable button-command mappings that allow the rest of the program to call things like XboxController.jumpButton() so the mapping can be changed in one place and not all over the program.

Will mostly deal with movement/command checks in the player class.

### Reactive Sound
We don't have an existing sound engine of any type. Levels will have to own these objects and be smart enough to activate certain sound events based on triggers, and the player class will have to activate some events based on its status. 

#### ReactiveBGMusic
Inherits from FlxSound - not sure if it needs to, I don't think it does.

A way to define that a bunch of different tracks of the different instruments playing the same song are together and can be re-mixed based on events in the game.

Setting the panning and volume on those tracks.

Pan and volume tweening for groups.

Easily changing the mixing of the song for certain events.

The idea is for this to be like the midi-track fading in Banjo-Kazooie or the ability for "front-running mixes" from Mario Kart 8.
	
#### ReactiveBGPlatforming
Inherits from ReactiveBGMusic

Specialized methods for dealing with platforming levels.

Situations like: Near secret, moving quickly, near goal, chaining bounces off of enemies (if applicable) are set up to be easily defined mix changes that can be activated with functions.

#### ReactiveBGBoss
Inherits from ReactiveBGMusic

Specialized methods for dealing with situations specific to boss battles.

Situations like the boss losing health, boss at low health set up to be easily definable mix changes that can be activated with functions.