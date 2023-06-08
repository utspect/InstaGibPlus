# InstaGib+
An InstaGib focussed fork of TimTim's NewNet mutator for Unreal Tournament.

1. [Features](#features)
2. [Client Settings](#client-settings)
3. [Client Commands](#client-commands)
4. [Server Installation](#server-installation)
5. [Usage](#usage)
6. [Admin Commands](#admin-commands)
6. [Server Settings](#server-settings)
7. [Building](#building)
8. [Credits](#credits)

# Features

* Reworked netcode in order to drastically reduce visible glitches when observing players on bad connections
* Working client forced models for enemies and teammates
* Working client-side hitsounds with the option to use custom hitsound packages
* Different Shock beam types (team-colored, none, instant beam)
* Fixed pop-in of enemies around corners
* Fixed delay of visible flag pick-up
* Fixed stuttering on respawn with high ping
* Fixed Bunny Jumping

# Client Settings

These settings can be found in **InstaGibPlus.ini** under section **\[ClientSettings\]**.

1. [bForceModels](#bforcemodels)
2. [DesiredSkin](#desiredskin)
3. [DesiredSkinFemale](#desiredskinfemale)
4. [DesiredTeamSkin](#desiredteamskin)
5. [DesiredTeamSkinFemale](#desiredteamskinfemale)
6. [SkinEnemyIndexMap](#skinenemyindexmap)
7. [SkinTeamIndexMap](#skinteamindexmap)
8. [bSkinEnemyUseIndexMap](#bskinenemyuseindexmap)
9. [bSkinTeamUseIndexMap](#bskinteamuseindexmap)
10. [bUnlitSkins](#bunlitskins)
11. [HitSound](#hitsound)
12. [TeamHitSound](#teamhitsound)
13. [bDisableForceHitSounds](#bdisableforcehitsounds)
14. [bEnableHitSounds](#benablehitsounds)
15. [bEnableTeamHitSounds](#benableteamhitsounds)
16. [bHitSoundPitchShift](#bhitsoundpitchshift)
17. [bHitSoundTeamPitchShift](#bhitsoundteampitchshift)
18. [HitSoundSource](#hitsoundsource)
19. [SelectedHitSound](#selectedhitsound)
20. [SelectedTeamHitSound](#selectedteamhitsound)
21. [HitSoundVolume](#hitsoundvolume)
22. [HitSoundTeamVolume](#hitsoundteamvolume)
23. [sHitSound](#shitsound)
24. [bDoEndShot](#bdoendshot)
25. [bAutoDemo](#bautodemo)
26. [DemoMask](#demomask)
27. [DemoPath](#demopath)
28. [DemoChar](#demochar)
29. [bTeamInfo](#bteaminfo)
30. [bShootDead](#bshootdead)
31. [cShockBeam](#cshockbeam)
32. [bHideOwnBeam](#bhideownbeam)
33. [BeamScale](#beamscale)
34. [BeamFadeCurve](#beamfadecurve)
35. [BeamDuration](#beamduration)
36. [BeamOriginMode](#beamoriginmode)
37. [BeamDestinationMode](#beamdestinationmode)
38. [SSRRingType](#ssrringtype)
39. [bNoOwnFootsteps](#bnoownfootsteps)
40. [DesiredNetUpdateRate](#desirednetupdaterate)
41. [DesiredNetspeed](#desirednetspeed)
42. [FakeCAPInterval](#fakecapinterval)
43. [bNoSmoothing](#bnosmoothing)
44. [bLogClientMessages](#blogclientmessages)
45. [bDebugMovement](#bdebugmovement)
46. [bEnableKillCam](#benablekillcam)
47. [MinDodgeClickTime](#mindodgeclicktime)
48. [bUseOldMouseInput](#buseoldmouseinput)
49. [SmoothVRController](#smoothvrcontroller)
50. [bShowFPS](#bshowfps)
51. [FPSLocationX](#fpslocationx)
52. [FPSLocationY](#fpslocationy)
53. [FPSDetail](#fpsdetail)
54. [FPSCounterSmoothingStrength](#fpscountersmoothingstrength)
55. [KillCamMinDelay](#killcammindelay)
56. [bAllowWeaponShake](#ballowweaponshake)
57. [bAutoReady](#bautoready)
58. [bShowDeathReport](#bshowdeathreport)
59. [bSmoothFOVChanges](#bsmoothfovchanges)
60. [bEnableKillFeed](#benablekillfeed)
61. [KillFeedX](#killfeedx)
62. [KillFeedY](#killfeedy)
63. [KillFeedSpeed](#killfeedspeed)
64. [KillFeedScale](#killfeedscale)
65. [FraggerScopeChoice](#fraggerscopechoice)
66. [bEnableHitMarker](#benablehitmarker)
67. [bEnableTeamHitMarker](#benableteamhitmarker)
68. [HitMarkerColorMode](#hitmarkercolormode)
69. [HitMarkerColor](#hitmarkercolor)
70. [HitMarkerTeamColor](#hitmarkerteamcolor)
71. [HitMarkerSize](#hitmarkersize)
72. [HitMarkerOffset](#hitmarkeroffset)
73. [HitMarkerDuration](#hitmarkerduration)
74. [HitMarkerDecayExponent](#hitmarkerdecayexponent)
75. [HitMarkerSource](#hitmarkersource)
76. [bUseCrosshairFactory](#busecrosshairfactory)
77. [CrosshairLayers](#crosshairlayers)

## bForceModels
**Type: bool**  
**Default: False**  

If set to `True`, forces all other players to use fixed models and skins (see DesiredSkin settings).
If set to `False`, all players will show as their chosen model and skin.

### List of Skins
Note that these numbers only apply when editing INI settings

0. Class: Female Commando, Skin: Aphex, Face: Idina
1. Class: Female Commando, Skin: Commando, Face: Anna
2. Class: Female Commando, Skin: Mercenary, Face: Jayce
3. Class: Female Commando, Skin: Necris, Face: Cryss
4. Class: Female Soldier, Skin: Marine, Face: Annaka
5. Class: Female Soldier, Skin: Metal Guard, Face: Isis
6. Class: Female Soldier, Skin: Soldier, Face: Lauren
7. Class: Female Soldier, Skin: Venom, Face: Athena
8. Class: Female Soldier, Skin: War Machine, Face: Cathode
9. Class: Male Commando, Skin: Commando, Face: Blake
10. Class: Male Commando, Skin: Mercenary, Face: Boris
11. Class: Male Commando, Skin: Necris, Face: Grail
12. Class: Male Soldier, Skin: Marine, Face: Malcolm
13. Class: Male Soldier, Skin: Metal Guard, Face: Drake
14. Class: Male Soldier, Skin: RawSteel, Face: Arkon
15. Class: Male Soldier, Skin: Soldier, Face: Brock
16. Class: Male Soldier, Skin: War Machine, Face: Matrix
17. Class: Boss, Skin: Boss, Face: Xan

Any value below zero disables forcing models. For example, if you set [DesiredSkin](#desiredskin) to `-1`, enemy players that have selected male skins will not be forced to another skin.

## DesiredSkin
**Type: int**  
**Default: 9**  

## DesiredSkinFemale
**Type: int**  
**Default: 0**  

## DesiredTeamSkin
**Type: int**  
**Default: 9**  

## DesiredTeamSkinFemale
**Type: int**  
**Default: 0**  

## SkinEnemyIndexMap
**Type: int\[16\]**  
**Default: 0**  

## SkinTeamIndexMap
**Type: int\[16\]**  
**Default: 0**  

## bSkinEnemyUseIndexMap
**Type: bool**  
**Default: False**

* `False` ➜ Assign each enemy `DesiredSkin` or `DesiredSkinFemale`
* `True` ➜ Assigns each enemy a different skin, according to that players index into [SkinEnemyIndexMap](#skinenemyindexmap)

## bSkinTeamUseIndexMap
**Type: bool**  
**Default: False**

* `False` ➜ Assign each teammate `DesiredTeamSkin` or `DesiredTeamSkinFemale`
* `True` ➜ Assigns each teammate a different skin, according to that players index into [SkinTeamIndexMap](#skinteamindexmap)

## bUnlitSkins
**Type: bool**  
**Default: True**

If `True`, player skins will not be affected by surrounding lighting, usually making them brighter.

## HitSound
**Reserved**

## TeamHitSound
**Reserved**

## bDisableForceHitSounds
**Reserved**

## bEnableHitSounds
**Type: bool**  
**Default: True**  

If `True`, plays a sound when a weapon you fire hits an enemy on your client.
If `False`, no sound is played.

## bEnableTeamHitSounds
**Type: bool**  
**Default: False**  

If `True`, plays a sound when a weapon you fire hits a teammate on your client.
If `False`, no sound is played.

## bHitSoundPitchShift
**Type: bool**  
**Default: True**  

Whether the HitSound from hitting enemies should be pitch shifted depending on damage dealt or not.

## bHitSoundTeamPitchShift
**Type: bool**  
**Default: False**  

Whether the HitSound from hitting teammates should be pitch shifted depending on damage dealt or not.

## SelectedHitSound
**Type: int**  
**Default: 0**  

Index into sHitSound array for the sound to play when hitting an enemy.

## SelectedTeamHitSound
**Type: int**  
**Default: 2**  

Index into sHitSound array for the sound to play when hitting a teammate.

## HitSoundVolume
**Type: float**  
**Default: 4.0**  

Volume of the HitSound from hitting enemies.

## HitSoundTeamVolume
**Type: float**  
**Default: 4.0**  

Volume of the HitSound from hitting teammates.

## sHitSound
**Type: string\[16\]**  

Specifies sounds that can be played.

## bDoEndShot
**Type: bool**  
**Default: False**  

If `True`, automatically create a screenshot at the end of a match.
If `False`, no screenshot is automatically created.
## bAutoDemo
**Type: bool**  
**Default: False**  

If `True`, automatically start recording a demo when the game starts.
## DemoMask
**Type: string**  
**Default: %l\_\[%y\_%m\_%d\_%t\]\_\[%c\]\_%e**  

Template for the name of the demo started because of [bAutoDemo](#bautodemo).
The following (case-insensitive) placeholders will be replaced with match-specific details:

- `%E` ➜ Name of the map file
- `%F` ➜ Title of the map
- `%D` ➜ Day (two digits)
- `%M` ➜ Month (two digits)
- `%Y` ➜ Year
- `%H` ➜ Hour
- `%N` ➜ Minute
- `%T` ➜ Combined Hour and Minute (two digits each)
- `%C` ➜ Clan Tags (detected by determining common prefix of all players on a team, or "Unknown")
- `%L` ➜ Name of the recording player
- `%%` ➜ Replaced with a single %

## DemoPath
**Type: string**  
**Default: *empty***  

Prefix for name of the demo started because of [bAutoDemo](#bautodemo) or [DemoStart](#demostart).

## DemoChar
**Type: string**  
**Default: *empty***  

Characters filesystems can not handle are replaced with this.

## bTeamInfo
**Type: bool**  
**Default: True**  

if Client wants extra team info.

## bShootDead
**Type: bool**  
**Default: False**  

If `True`, client shots can collide with carcasses from dead players.
If `False`, client shots will not collide with carcasses.

## cShockBeam
**Type: int**  
**Default: 1**  

The style of beam to use for the SuperShockRifle.

1. Default beam
2. Team colored beam that looks like a projectile
3. No beam at all
4. Team colored, instant beam

## bHideOwnBeam
**Type: bool**  
**Default: False**  

If `True`, hides your own SuperShockRifle beams, no matter the value of [cShockBeam](#cshockbeam). 

## BeamScale
**Type: float**  
**Default: 0.45**  

Visuals for the beam are scaled with this factor
## BeamFadeCurve
**Type: float**  
**Default: 4.0**  

Exponent of the polynomial curve the beam's visuals decay with
## BeamDuration
**Type: float**  
**Default: 0.75**  
**Unit: s**  

The time the beam's visuals decay over.
## BeamOriginMode
**Type: int**  
**Default: 0**  

0. Originates where the player was when the shot was fired
1. Originates at an offset from where the player is on your screen.

## BeamDestinationMode
**Type: int**  
**Default: 0**  

0. Beam ends where it ended on server
1. Beam ends on target

## SSRRingType
**Type: int**  
**Default: 1**  

0. No Ring
1. Default Ring
2. Team-colored Ring

## bNoOwnFootsteps
**Type: bool**  
**Default: False**  

If `True`, footstep sounds are not played for your own footsteps.
If `False`, your own footstep sounds will be played.

## DesiredNetUpdateRate
**Type: float**  
**Default: 200**  
**Unit: Hz**  

How often you want your client to update the server on your movement. The server places upper and lower limits on this (see [MinNetUpdateRate](#minnetupdaterate), [MaxNetUpdateRate](#maxnetupdaterate)), and the actual update rate will never exceed your netspeed divided by 100.

This is here to provide players with constrained upload bandwidth a way to reduce the required upload bandwidth at the expense of greater susceptibility to packet loss, and glitches arising from it.

Players with high upload bandwidth can set this to a high value to lessen the impact of packet loss.

## DesiredNetspeed
**Type: int**  
**Default: 25000**  
**Unit: B/s**  

Always tries to keep your netspeed at the value of this variable, unless the server prevents this.

## FakeCAPInterval
**Type: float**  
**Default: 0.1**  
**Unit: s**  

Tells the server to send an acknowledgement of your movement updates (see [DesiredNetUpdateRate](#desirednetupdaterate)) after this amount of time has passed since the last acknowledgement. This saves download bandwidth and lessens server load.

Smaller values (closer to 0) result in acknowledgements being sent more frequently, negative values send an acknowledgement for every movement update.
Higher values result in less frequent acknowledgements which can result in degraded client performance (FPS), or even crashes.

## bNoSmoothing
**Type: bool**  
**Default: False**  

The default mouse input smoothing algorithm always smears input over at least two frames, half the input being applied on one frame, the other half on the next frame. If set to `True`, the game will always apply all input on the current frame. If set to `False`, the default algorithm will be used.

This is a backport from UT99 client version 469, where the equivalent setting is called bNoMouseSmoothing.
## bLogClientMessages
**Type: bool**  
**Default: True**  

Causes all ClientMessages to be logged, if set to `True`
## bDebugMovement
**Type: bool**  
**Default: False**  

Causes IG+ to write movement debugging events to console/demo, depending on whether debug data is enabled at the moment (see [EnableDebugData](#enabledebugdata))
## bEnableKillCam
**Type: bool**  
**Default: False**  

KillCam follows the player that killed you for two seconds.
## MinDodgeClickTime
**Type: float**  
**Default: 0.0**  
**Unit: s**  

Minimum time between two rising edges of movement in the same direction for them to count as a dodge.
## bUseOldMouseInput
**Type: bool**  
**Default: False**  

The old mouse input processing algorithm discards the fractional part before turning the view according to the mouse input. The new algorithm preserves fractional rotation across frames.

A players view is defined by yaw and pitch, which are quantized to 65536 degrees (a circle has 65536 degrees instead of 360). If a players mouse input sensitivity is set such that the players mouse input can result in some fraction of a degree, that fractional part must be discarded before the view is changed. The new algorithm preserves that fractional part and adds it to the next mouse input.

If `True`, two successive inputs of 1.5° change in yaw result in a 2° turn (int(1.5) + int(1.5) = 1 + 1 = 2).
If `False`, two successive inputs of 1.5° change in yaw result in a 3° turn.
## SmoothVRController
**Type: PIDControllerSettings**  
**Default: (p=0.09,i=0.05,d=0.00)**  

This holds the PID settings for the controller thats smoothing the view of players youre spectating as a spectator (see [PID controller](https://en.wikipedia.org/wiki/PID_controller)).

## bShowFPS
**Type: bool**  
**Default: False**  

If `True`, show averaged FPS information in top right corner. If `False`, show nothing.

## FPSLocationX

**Type: float**  
**Default: 1.0**  

Placement of the FPS information on the horizontal axis. `0.0` is left edge, `1.0` is right edge.

## FPSLocationY

**Type: float**  
**Default: 0.0**  

Placement of the FPS information on the vertical axis. `0.0` is top edge, `1.0` is bottom edge.

## FPSDetail
**Type: int**  
**Default: 0**  

How much detail to display about FPS

* 0 ➜ Average FPS only
* 1 ➜ Average Frame-Time
* 2 ➜ Standard deviation of Frame-Time
* 3 ➜ Min/Max Frame-Time over the last 3 seconds

## FPSCounterSmoothingStrength
**Type: int**  
**Default: 1000**  

How many samples to average FPS over.

## KillCamMinDelay
**Type: float**  
**Default: 0.0**  
**Unit: seconds**  

Minimum time between death and when KillCam starts rotating towards killer.

## bAllowWeaponShake
**Type: bool**  
**Default: True**  

If `True`, weapons can shake view. If `False` weapons can't shake view.

## bAutoReady
**Type: bool**  
**Default: True**  

If `True`, you ready up when spawning for the first time during warmup. If `False` you have to manually ready up using the [Ready](#ready) command, or using `mutate ready`, or by saying one of `ready`, `rdy`, `r`, `!ready`, `!rdy`.

## bShowDeathReport
**Type: bool**  
**Default: False** 

If `True`, show a report of damage taken that lead to death. The report starts from the last time you gained health or armor.

## bSmoothFOVChanges
**Type: bool**  
**Default: False** 

If `True`, smooth changes to your FOV, which can happen when spawning, teleporting or zooming.  
If `False`, your FOV immediately changes to the desired FOV without a smooth transition.

## bEnableKillFeed
**Type: bool**  
**Default: True**  

If `True` kills are reported in a separate list in condensed form, using symbols to represent the cause of death.  
If `False` nothing is shown.

## KillFeedX
**Type: float**  
**Default: 0.0**  

Horizontal position of the KillFeed. Left edge of screen is 0. Right edge of screen is 1.

## KillFeedY
**Type: float**  
**Default: 0.5**  

Vertical position of the KillFeed. Top of screen is 0. Bottom of screen is 1.

## KillFeedSpeed
**Type: float**  
**Default: 1.0**  

Linear factor on the speed at which individual lines in the KillFeed disappear.

Increase to make lines disappear sooner. Decrease to make lines disappear later. 0 and below mean the lines stay until they are rotated out by subsequent kills. Maximum of 4 lines at any time.

## KillFeedScale
**Type: float**  
**Default: 1.0**  

Scales the size of individual lines of the KillFeed.

## FraggerScopeChoice
**Type: EFraggerScopeChoice**  
**Default: `FSC_Moveable`**  

Which scope the FraggerRifle uses when zoming.

* `FSC_None` ➜ Keeps the default crosshair
* `FSC_Static` ➜ Few moving parts when zooming in
* `FSC_Moveable` ➜ More moving parts when zooming in

## bEnableHitMarker
**Type: bool**  
**Default: False** 

If `True`, plays an animation on the hud whenever you damage an enemy.

## bEnableTeamHitMarker
**Type: bool**  
**Default: False** 

If `True`, plays an animation on the hud whenever you damage a teammate.

## HitMarkerColorMode
**Type: EHitMarkerColorMode**  
**Default: HMCM_FriendOrFoe** 

* `HMCM_FriendOrFoe` ➜ Use [HitMarkerColor](#hitmarkercolor) for enemies and [HitMarkerTeamColor](#hitmarkerteamcolor) for friends.
* `HMCM_TeamColor` ➜ Use team color in team games, [HitMarkerColor](#hitmarkercolor) in FFA games.

## HitMarkerColor
**Type: color**  
**Default: (R=255,G=0,B=0,A=255)** 

The color of the HitMarker when damaging enemies. Fades over [HitMarkerDuration](#hitmarkerduration) to completely transparent.

## HitMarkerTeamColor
**Type: color**  
**Default: (R=0,G=0,B=255,A=255)** 

The color of the HitMarker when damaging teammates. Fades over [HitMarkerDuration](#hitmarkerduration) to completely transparent.

## HitMarkerSize
**Type: float**  
**Default: 128.0**  
**Unit: pixel** 

The length of the arrows that the HitMarker places on screen.

## HitMarkerOffset
**Type: float**  
**Default: 32.0**  
**Unit: pixel** 

How far away from the center of the screen the arrows are placed.

## HitMarkerDuration
**Type: float**  
**Default: 0.3**  
**Unit: seconds** 

How long the HitMarker stays on screen. Negative values effectively disable HitMarker.

## HitMarkerDecayExponent
**Type: float**  
**Default: 5.0**  

How quickly the HitMarker becomes transparent. Higher values mean sharper drop-off. Values closer to zero make the HitMarker stay on screen at full brightness for longer until [HitMarkerDuration](#hitmarkerduration) is reached.

## HitMarkerSource
**Type: EHitMarkerSource**  
**Default: HMSRC_Server** 

* `HMSRC_Server` ➜ HitMarkers are triggered server-side, accurate but delayed by ping
* `HMSRC_Client` ➜ HitMarkers are triggered client-side, inaccurate but instant

## bUseCrosshairFactory
**Type: bool**  
**Default: False**  

If `True`, override default crosshair drawing with custom one, as described by [CrosshairLayers](#crosshairlayers).

## CrosshairLayers
**Type: CrosshairLayerDescr\[10\]**  
**Default: `(Texture="",OffsetX=0,OffsetY=0,ScaleX=0.000000,ScaleY=0.000000,Color=(R=0,G=0,B=0,A=0),Style=0,bSmooth=False,bUse=False)`**  

The type `CrosshairLayerDescr` is defined like this:
```unrealscript
struct CrosshairLayerDescr {
    var() config string Texture;
    var() config int    OffsetX, OffsetY;
    var() config float  ScaleX, ScaleY;
    var() config color  Color;
    var() config byte   Style;
    var() config bool   bSmooth;
    var() config bool   bUse;
};
```

A crosshair is made up of individual images that are drawn in a specific order potentially on top of each other, which are called layers. The current factory supports up to 10 layers for a single crosshair.

* `Texture` refers to the image to draw. If left empty, a 1x1 white pixel will be used.
* `OffsetX` and `OffsetY` is the offset from the center of the screen in pixels where the image should be drawn
* `ScaleX` and `ScaleY` represent how large the image should be
* `Color` is the color in RGB that should be used to draw the image
* `Style` is the drawing style to use for the image, one of
    * 0 (`STY_None`) - equivalent to 1 (`STY_Normal`) for our purposes here
    * 1 (`STY_Normal`) - RGB image (no transparency)
    * 2 (`STY_Masked`) - Paletted image, first color in palette is transparent (?)
    * 3 (`STY_Translucent`) - Greyscale image, brightness is opacity, used for default crosshairs
    * 4 (`STY_Modulated`) - ?
* `bSmooth` controls whether sharp edges should be smoothed out when `ScaleX` or `ScaleY` are greater than 1
* `bUse` controls whether this layer should be drawn, `True` to draw, `False` to ignore

# Client Commands
The following commands are additions by IG+ to the standard set of commands.

Types for parameters:

* bool: Binary value, `True`/`1` or `False`/`0`
* int: Whole number, e.g. `6`, `78`
* float: Real number, e.g. `1.35`, accurate up to 7 significant digits
* string: String of characters, e.g. `"Hello, World!"`

Parameters marked `optional` do not have to be supplied.

1. [EnableDebugData](#enabledebugdata)
2. [EnableHitSound](#enablehitsound)
3. [EnableTeamHitSound](#enableteamhitsound)
4. [SetHitSound](#sethitsound)
5. [SetTeamHitSound](#setteamhitsound)
6. [ForceModels](#forcemodels)
7. [ListSkins](#listskins)
8. [SetForcedSkins](#setforcedskins)
9. [SetForcedTeamSkins](#setforcedteamskins)
10. [SetShockBeam](#setshockbeam)
11. [SetBeamScale](#setbeamscale)
12. [MyIgSettings](#myigsettings)
13. [SetNetUpdateRate](#setnetupdaterate)
14. [SetMouseSmoothing](#setmousesmoothing)
15. [SetKillCamEnabled](#setkillcamenabled)
16. [DropFlag](#dropflag)
17. [PureLogo](#purelogo)
18. [TeamInfo](#teaminfo)
19. [SetMinDodgeClickTime](#setmindodgeclicktime)
20. [mdct](#mdct)
21. [EndShot](#endshot)
22. [Hold](#hold)
23. [Go](#go)
24. [AutoDemo](#autodemo)
25. [ShootDead](#shootdead)
26. [SetDemoMask](#setdemomask)
27. [DemoStart](#demostart)
28. [ShowFPS](#showfps)
29. [ShowOwnBeam](#showownbeam)
30. [Ready](#ready)
31. [ZoomToggle](#zoomtoggle)

## EnableDebugData
**Parameters: (bool b)**  

Displays a variety of useful debugging information on screen.
## EnableHitSound
**Parameters: (bool b)**

Enables/Disables hitsound when hitting enemies.

## EnableTeamHitSound
**Parameters: (bool b)**

Enables/Disables hitsound when hitting teammates.

## SetHitSound
**Parameters: (byte hs)**

Switches between the 16 slots available for enemy hitsounds (see [sHitSound](#shitsound)). `hs` must be a value between `0` and `15`.

## SetTeamHitSound
**Parameters: (byte hs)**

Switches between the 16 slots available for teammate hitsounds (see [sHitSound](#shitsound)). `hs` must be a value between `0` and `15`.


## ForceModels
**Parameters: (bool b)**

Enables/Disables forced models/skins for all players.

## ListSkins
Prints a list of models/skins you can force enemies and teammates to.

## SetForcedSkins
**Parameters: (int maleSkin, int femaleSkin)**

Sets the forced models/skins for opponents who are using male or female models respectively. Valid values for `maleSkin` and `femaleSkin` range from `1` to `18`. The [ListSkins](#listskins) command prints how those numbers map to models and skins.

### Examples
Forcing all opponents to Xan:

    SetForcedSkins 18 18

Forcing opponents to bright skins:

    SetForcedSkins 16 7
## SetForcedTeamSkins
**Parameters: (int maleSkin, int femaleSkin)**

Sets the forced models/skins for teammates who are using male or female models respectively. Valid values for `maleSkin` and `femaleSkin` range from `1` to `18`. The [ListSkins](#listskins) command prints how those numbers map to models and skins.
## SetShockBeam
**Parameters: (int sb)**

Changes the style of beam fired by the SuperShockRifle. See [cShockBeam setting](#cshockbeam-int-default-1).
## SetBeamScale
**Parameters: (float bs)**
Changes [BeamScale setting](#beamscale).
## MyIgSettings
Prints a selection of IG+ settings.
## SetNetUpdateRate
**Parameters: (float NewVal)**

Changes how often your client will send a movement update to the server. See [DesiredNetUpdateRate setting](#desirednetupdaterate).
## SetMouseSmoothing
**Parameters: (bool b)**

Changes [bNoSmoothing setting](#bnosmoothing).
## SetKillCamEnabled
**Parameters: (bool b)**

Changes [bEnableKillCam setting](#benablekillcam).
## DropFlag
Drops the currently held flag, if any.
## PureLogo
Shows IG+ version in the bottom left corner of the screen.
## TeamInfo
**Parameters: (bool b)**
## SetMinDodgeClickTime
**Parameters: (float f)**

Changes [MinDodgeClickTime setting](#mindodgeclicktime).
## mdct
**Parameters: (float f)**

Changes [MinDodgeClickTime setting](#mindodgeclicktime).
## EndShot
**Parameters: (optional bool b)**

Changes [bDoEndShot setting](#bdoendshot).
## Hold
Resets the AutoPause countdown. Can only be used if the AutoPause was triggered by an opponent leaving or switching sides.
## Go
Resumes the game immediately. Can only be used by the team that lost at least one of its players.
## AutoDemo
**Parameters: (bool b)**

Changes [bAutoDemo setting](#bautodemo).
## ShootDead
Toggles [bShootDead setting](#bshootdead) between `True` and `False`.
## SetDemoMask
**Parameters: (optional string Mask)**

Changes [DemoMask setting](#demomask).
## DemoStart
Starts recording a demo with the [DemoPath](#demopath) and [DemoMask](#demomask) that are currently configured.

## ShowFPS
Toggles displaying FPS information in the top right corner. See [bShowFPS](#bshowfps).

## ShowOwnBeam
Toggles showing your own beam when firing the SuperShockRifle. See [bHideOwnBeam](#bhideownbeam).

## Ready
Toggles ready state during warmup.

## ZoomToggle
**Parameters: (float SensitivityX, optional float SensitivityY)**

Toggles between FOV 80 and the players desired FOV.  
`SensitivityX` and `SensitivityY` are multiplicative factors on mouse sensitivity in their respective directions (X is side-to-side / yaw, Y is up-down / pitch) while zooming.

If `SensitivityY` is not provided by the user, it is assumed to be the same as `SensitivityX`.

### Examples
- Same sensitivity as un-zoomed: `ZoomToggle 1.0`
- Half the sensitivity as un-zoomed: `ZoomToggle 0.5`

# Server Installation

Extract the zipped files to your system folder.  
Remove any mention in your ServerPackages and ServerActors of TimTim's NewNet or Deepu's Ultimate NewNet.  
Add the following lines to your server's **UnrealTournament.ini** under **[Engine.GameEngine]**:

**ServerPackages=InstaGibPlus9**
**ServerActors=InstaGibPlus9.NewNetServer**
**ServerActors=InstaGibPlus9.PureStats**

<b>It is highly recommended to set your server's tickrate to 100.</b>

# Usage
For InstaGib, make sure the mutator **InstaGibPlus9.NewNetIG** is loaded via your map vote configuration or during server launch.

InstaGib+ has minimal weapons code and will load the default UT weapons if the NewNetIG mutator is not loaded, so it is absolutely unusable in normal weapons, make sure to use it only if your objective is to play or to run an InstaGib centered server.

When connected to the server type **'mutate playerhelp'** in the console to view the available commands and options.


# Admin Commands
- ShowIPs (Shows the IP of players)
- ShowID (Shows the ID of players)
- KickID x (Will Kick player with ID x)
- BanID x (Will Ban & Kick player with ID x)
- EnablePure/DisablePure
- ShowDemos (Will show who is recording demos)

As spectator, you may need to add 'mutate pure' + command (mutate pureshowtickrate)

# Server Settings
Server settings can be found inside InstaGibPlus.ini.

1. [HeadshotDamage](#headshotdamage)
2. [SniperSpeed](#sniperspeed)
3. [SniperDamagePri](#sniperdamagepri)
4. [SetPendingWeapon](#setpendingweapon)
5. [NNAnnouncer](#nnannouncer)
6. [bUTPureEnabled](#butpureenabled)
7. [Advertise](#advertise)
8. [AdvertiseMsg](#advertisemsg)
9. [bAllowCenterView](#ballowcenterview)
10. [CenterViewDelay](#centerviewdelay)
11. [bAllowBehindView](#ballowbehindview)
12. [TrackFOV](#trackfov)
13. [bAllowMultiWeapon](#ballowmultiweapon)
14. [bFastTeams](#bfastteams)
15. [bUseClickboard](#buseclickboard)
16. [MinClientRate](#minclientrate)
17. [MaxClientRate](#maxclientrate)
18. [bAdvancedTeamSay](#badvancedteamsay)
19. [ForceSettingsLevel](#forcesettingslevel)
20. [bWarmup](#bwarmup)
21. [bCoaches](#bcoaches)
22. [bAutoPause](#bautopause)
23. [ForceModels](#forcemodels)
24. [ImprovedHUD](#improvedhud)
25. [bDelayedPickupSpawn](#bdelayedpickupspawn)
26. [bTellSpectators](#btellspectators)
27. [PlayerPacks](#playerpacks)
28. [DefaultHitSound](#defaulthitsound)
29. [DefaultTeamHitSound](#defaultteamhitsound)
30. [bForceDefaultHitSounds](#bforcedefaulthitsounds)
31. [TeleRadius](#teleradius)
32. [ThrowVelocity](#throwvelocity)
33. [bForceDemo](#bforcedemo)
34. [bRestrictTrading](#brestricttrading)
35. [MaxTradeTimeMargin](#maxtradetimemargin)
36. [TradePingMargin](#tradepingmargin)
37. [KillCamDelay](#killcamdelay)
38. [KillCamDuration](#killcamduration)
39. [bJumpingPreservesMomentum](#bjumpingpreservesmomentum)
40. [bOldLandingMomentum](#boldlandingmomentum)
41. [bEnableSingleButtonDodge](#benablesinglebuttondodge)
42. [bUseFlipAnimation](#buseflipanimation)
43. [bEnableWallDodging](#benablewalldodging)
44. [bDodgePreserveZMomentum](#bdodgepreservezmomentum)
45. [MaxMultiDodges](#maxmultidodges)
46. [BrightskinMode](#brightskinmode)
47. [PlayerScale](#playerscale)
48. [bAlwaysRenderFlagCarrier](#balwaysrenderflagcarrier)
49. [bAlwaysRenderDroppedFlags](#balwaysrenderdroppedflags)
50. [MinPosError](#minposerror)
51. [MaxPosError](#maxposerror)
52. [MaxHitError](#maxhiterror)
53. [MaxJitterTime](#maxjittertime)
54. [MinNetUpdateRate](#minnetupdaterate)
55. [MaxNetUpdateRate](#maxnetupdaterate)
56. [bEnableInputReplication](#benableinputreplication)
57. [bEnableServerExtrapolation](#benableserverextrapolation)
58. [bEnableServerPacketReordering](#benableserverpacketreordering)
59. [bEnableLoosePositionCheck](#benableloosepositioncheck)
60. [bPlayersAlwaysRelevant](#bplayersalwaysrelevant)
61. [bEnablePingCompensatedSpawn](#benablepingcompensatedspawn)
62. [bEnableJitterBounding](#benablejitterbounding)
63. [bEnableWarpFix](#benablewarpfix)
64. [WarpFixDelay](#warpfixdelay)
65. [ShowTouchedPackage](#showtouchedpackage)
66. [ExcludeMapsForKickers](#excludemapsforkickers)
67. [ForcedSettings](#forcedsettings)

## HeadshotDamage

**Type: float**  
**Default: 100**  

Controls how much damage a headshot with the sniper rifle deals.

## SniperSpeed

**Type: float**  
**Default: 1**  

Controls sniper rifle reload time, higher values lead to less time between shots.

## SniperDamagePri

**Type: float**  
**Default: 60**  

Controls damage of body hits by sniper rifle.

## SetPendingWeapon

**removed**

## NNAnnouncer

**Type: bool**  
**Default: False**  

Whether to automatically add an announcer for multi-kills, or not.

## bUTPureEnabled

**Type: bool**  
**Default: True**  

Big switch to enable/disable IG+.

## Advertise

**Type: int**  
**Default: 1**  

Controls whether to add a tag to the server's name.

- `1` ➜ Add tag at the beginning of the server's name
- `2` ➜ Add tag at the end of the server's name
- anything else - Dont advertise

## AdvertiseMsg

**Type: int**  
**Default: 1**  

Controls the tag to add to the server's name

- `0` ➜ `[CSHP]`
- `1` ➜ `[IG+]`
- anything else ➜ `[PWND]`

## bAllowCenterView

**Type: bool**  
**Default: False**  

Whether to allow use of the bSnapLevel button or not.

## CenterViewDelay

**Type: float**  
**Default: 1**  
**Unit: s**  

If bAllowCenterView is True, controls how much time has to pass between uses of bSnapLevel.

## bAllowBehindView

**Type: bool**  
**Default: False**  

Whether to allow 3rd Person perspective or not.

## TrackFOV

**Type: int**  
**Default: 0**  

Controls how strictly the FOV is checked.

- `1` ➜ very strict, no zooming with sniper
- `2` ➜ looser, zooming with sniper possible
- anything else ➜ no restrictions

## bAllowMultiWeapon

**Type: bool**  
**Default: False**  

Whether to allow the multi-weapon bug to be (ab)used.

## bFastTeams

**Type: bool**  
**Default: True**  

Whether to allow the use of `mutate FixTeams`, `mutate NextTeam`, and `mutate ChangeTeam <Team>` or not. `True` enables the use of these commands, `False` disables.

## bUseClickboard

**Type: bool**  
**Default: True**  

Enables a set of alternative scoreboards that show the ready-status for players before the match has started.

## MinClientRate

**Type: int**  
**Default: 10000**  
**Unit: B/s**  

The server will force clients to use at least this netspeed.

## MaxClientRate

**Type: int**  
**Default: 25000**  
**Unit: B/s**  

Maximum netspeed allowed for clients.

## bAdvancedTeamSay

**Type: bool**  
**Default: True**  

Whether to allow the use of advanced TeamSay or not.
Advanced TeamSay allows showing game-information in your chat messages, by replacing the following with the corresponding information:

- `%H` ➜ "<Health> Health"
- `%h` ➜ "<Health>%"
- `%W` ➜ "<WeaponName>" or "Empty hands"
- `%A` ➜ "Shieldbelt and <Armor> Armor" or "<Armor> Armor"
- `%a` ➜ "SB <Armor>A" or "<Armor>A"
- `%P`, `%p` ➜ Current CTF objective

## ForceSettingsLevel

**Type: int**  
**Default: 2**  

When to check that default settings for all objects are correct client-side.

- `0` and below ➜ never
- `1` ➜ once after PostNetBeginPlay
- `2` ➜ in addition, every time a new object is spawned
- `3` and above ➜ in addition, once every 5000 server-ticks on average

## bWarmup

**Type: bool**  
**Default: True**  

Whether to allow warmup in tournament games or not.

### bCoaches

**Type: bool**  
**Default: False**  

Whether to allow spectators to coach teams in tournament games or not.

## bAutoPause

**Type: bool**  
**Default: True**  

Whether to automatically pause the game in tournament games or not.

### ForceModels

**Type: int**  
**Default: 1**  

Force models mode.

- `1` ➜ Client controlled
- `2` ➜ Forced on
- anything else ➜ Disabled

## ImprovedHUD

**Type: int**  
**Default: 1**  

Enable various HUD improvements. Depends on PureClickBoard mutator (set [bUseClickboard](#buseclickboard) to `True`, or add mutator through configuration).

- `1` ➜ Show boots, Clock
- `2` ➜ In addition, show enhanced team info
- anything else ➜ dont show anything

## bDelayedPickupSpawn

**Type: bool**  
**Default: False**  

Enable or disable delayed first pickup spawn.

## bTellSpectators

**Type: bool**  
**Default: False**  

Enable or disable telling spectators of reason for kicks.

## PlayerPacks

**Type: string\[8\]**  
**Default: *empty***  

Config list of supported player packs

## DefaultHitSound
**Reserved**

## DefaultTeamHitSound
**Reserved**

## bForceDefaultHitSounds
**Reserved**

## TeleRadius

**Type: int**  
**Default: 210**  
**Unit: uu**  

Radius within which to telefrag enemies using translocator.

## ThrowVelocity

**Type: int**  
**Default: 750**  
**Unit: uu/s**  

Horizontal speed with which to throw weapons.

## bForceDemo

**Type: bool**  
**Default: False**  

Forces clients to do demos.

## MinPosError

**Type: float**  
**Default: 100**  
**Unit: uu²**  

Unused. Intended to be minimum squared distance error for updating clients.

## MaxPosError

**Type: float**  
**Default: 3000**  
**Unit: uu²**

Unused. Intended to be maximum squared distance error for updating clients.

## MaxHitError

**Type: float**  
**Default: 10000**  
**Unit: uu**  

Distance to any position over the last 500ms for hits to be counted.

## ShowTouchedPackage

**Type: bool**  
**Default: False**  

Send package-names of touched actors to clients when those clients touch the actors.

## ExcludeMapsForKickers

**Type: string\[128\]**  
**Default: *empty***  

List of map names (with or without .unr) for maps that should not have their Kickers replaced with NN_Kickers.

## MaxJitterTime

**Type: float**  
**Default: 0.1**  
**Unit: s**  

Maximum time between updates by clients that's tolerated by IG+. Allowed position error scales with time since last update, up to this amount of time. Guideline setting is half the maximum supported ping.

## MinNetUpdateRate

**Type: float**  
**Default: 60**  
**Unit: Hz**  

Minimum frequency of client updates for server.

## MaxNetUpdateRate

**Type: float**  
**Default: 200**  
**Unit: Hz**  

Maximum frequency of client updates for server.

## bRestrictTrading

**Type: bool**  
**Default: True**  

If True, the server tries to determine who shot first, and prevents shots from players that are already dead and fired their last shot after their killer by in-game time from causing a trade.

If False, any shot made while alive on your client counts.

## MaxTradeTimeMargin

**Type: float**  
**Default: 0.1**  
**Unit: s**  

Maximum time after death (on server) that players can still fire their weapons. Only applies if [bRestrictTrading](#brestricttrading) is True.

## TradePingMargin

**Type: float**  
**Default: 0.5**  

Trade uncertainty relative to shooters ping. Reasonable values range from 0 to 1. Higher values lead to more trades.

## bEnableInputReplication

**Type: bool**
**Default: False**

If enabled, players will replicate their movement at a higher fidelity, in exchange for more upstream traffic.  
Players will replicate (up to) the 10 most recent simulation steps to the server at their selected NetUpdateRate.

[bEnableServerPacketReordering](#benableserverpacketreordering) has no effect if input replication is enabled.

Restrictions:
- Players should not run very high FPS (>500).
- Speed parameters of movement axis inputs are ignored.
- Pitch is only replicated within [-90°..+90°). Values outside this range may not be replicated correctly.

Disable to restore default netcode behavior.

## bEnableServerExtrapolation

**Type: bool**  
**Default: False**  

If enabled the server will extrapolate client movement when the client's movement updates are too far behind the server's timepoint.

Disable to restore default netcode behavior.

## bEnableServerPacketReordering

**Type: bool**  
**Default: False**  

If enabled, the server will try to reorder incoming ServerMove calls to extract the maximum amount of usable data. More relevant at lower TickRates.

Disable to restore default netcode behavior.

## bEnableLoosePositionCheck

**Type: bool**  
**Default: False**  

If enabled the server will loosen the check of players position, by factoring in current movement The server will even use the players reported position instead of the calculated one, if the loose check is successful.

Disable to restore default netcode behavior.

## bPlayersAlwaysRelevant

**Type: bool**  
**Default: True**  

If enabled the server will always replicate all players to each other, increasing network traffic in order to make sure players always appear on screen.

Disable to restore default netcode behavior.

## bEnablePingCompensatedSpawn

**Type: bool**  
**Default: True**  

If enabled, players will not become visible to others until they can actually move on their end.  
If disabled, players will stand on their spawn-point visible to other players without being able to move for the duration of their ping.

Disable to restore default netcode behavior.

## bEnableJitterBounding

**Type: bool**  
**Default: False**  

If enabled, updates by clients over more than [MaxJitterTime](#maxjittertime) will be cut down to MaxJitterTime in order to reduce visible warping for other players.

Disable to restore default netcode behavior.

## bEnableWarpFix

**Type: bool**  
**Default: True**  

If enabled, other players will not be extrapolated indefinitely on clients. Instead, after a short amount of time they will be forcibly reset to the last position the client received from the server.

## WarpFixDelay

**Type: float**  
**Default: 0.25**  
**Unit: s**  

The amount of time that has to pass without an update from a player before forcing them back to their position on the server for all other clients. Also controls 

## KillCamDelay

**Type: float**  
**Default: 0**  
**Unit: s**  

KillCam can not start before a player has been dead for this long.

## KillCamDuration

**Type: float**  
**Default: 2**  
**Unit: s**  

KillCam follows the killing player for this long after its start.

## bJumpingPreservesMomentum

**Type: bool**  
**Default: False**  

If False, players will be slowed down to ground speed upon landing, which prevents Bunny Hopping. If True, landing works like before.

## bOldLandingMomentum

**Type: bool**  
**Default: True**  

If True, players retain the momentum of their in-air movement upon landing. If False, players can cancel their momentum by moving in the opposite direction of their in-air movement.

## bEnableSingleButtonDodge

**Type: bool**  
**Default: False**  

Enables an input button clients can bind to a key, which makes the client dodge in the direction it is currently walking.

Button can be bound to a key by assigning Button bDodge to a key in User.ini under section \[Engine.Input\]

## bUseFlipAnimation

**Type: bool**  
**Default: True**  

If False, models will not do a flip when dodging forwards, but use an animation similar to that of all other dodge directions.

## bEnableWallDodging

**Type: bool**  
**Default: False**  

If enabled, allows players to dodge off of walls while in the air.

## bDodgePreserveZMomentum

**Type: bool**  
**Default: False**  

If True, preserves upward momentum (from lifts and regular jumps) when dodging. Downward momentum is always cancelled out.

## MaxMultiDodges

**Type: int**  
**Default: 1**  

How many additional dodges you can perform after the first dodge. Only applies when [bEnableWallDodging](#benablewalldodging) is True.

## BrightskinMode

**Type: int**  
**Default: 1**  

What brightskin mode is allowed for clients.

* 0 ➜ No brightskins allowed
* 1 ➜ Unlit skins allowed

## PlayerScale

**Type: float**  
**Default: 1.0**  

Scale factor for player models. Scales both DrawScale (visuals) and CollisionRadius/-Height (hitbox).

## bAlwaysRenderFlagCarrier

**Type: bool**  
**Default: False**  

If True, team-mates of flag carriers will be able to see the carrier through walls.

## bAlwaysRenderDroppedFlags

**Type: bool**  
**Default: False**  

If True, players are able to see their own flags through walls if those flags are currently dropped on the ground.

## ForcedSettings

**Type: ForcedSettingsEntry\[128\]**
**Default: (Key="",Value="",Mode=0)**

Type `ForcedSettingsEntry` is defined like this:  
```unrealscript
struct ForceSettingsEntry {
    var string Key;
    var string Value;
    var int Mode;
};
```

Each entry can be used to force a setting on clients:
* `Key` is the name of the setting to force
* `Value` is the value to force the setting to
* `Mode` describes how to force the setting:
  * `0` ➜ Initial only
  * `1` ➜ Always, but reset after leaving server
  * `2` ➜ Always, but don't reset (should not be used)

# Building

1. Go to the installation directory of UT99 in a command shell
2. Use `git clone https://github.com/utspect/InstaGibPlus` to clone the repo
3. Navigate to the newly created directory `InstaGibPlus`
4. Execute `Build.bat`
5. The result of the build process will be available in the `System` folder that is next to `Build.bat`

# Credits

**TimTim** - Original NewNet.  
**Deepu** - Ultimate NewNet.  
**AnthraX** - Lots and lots of help with debugging tricky problems.  
**spect** - Starting this project.  
**Deaod** - Maintenance.  
**UT99 Community** - For their endless patience, support and help testing and reporting bugs.  
**Epic** - For not open sourcing a 20 year old game running on their 20 year old engine.