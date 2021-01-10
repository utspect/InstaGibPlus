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
6. [bUnlitSkins](#bunlitskins)
7. [HitSound](#hitsound)
8. [TeamHitSound](#teamhitsound)
9. [bDisableForceHitSounds](#bdisableforcehitsounds)
10. [bEnableHitSounds](#benablehitsounds)
11. [selectedHitSound](#selectedhitsound)
12. [sHitSound](#shitsound)
13. [bDoEndShot](#bdoendshot)
14. [bAutoDemo](#bautodemo)
15. [DemoMask](#demomask)
16. [DemoPath](#demopath)
17. [DemoChar](#demochar)
18. [bTeamInfo](#bteaminfo)
19. [bShootDead](#bshootdead)
20. [cShockBeam](#cshockbeam)
21. [bHideOwnBeam](#bhideownbeam)
22. [BeamScale](#beamscale)
23. [BeamFadeCurve](#beamfadecurve)
24. [BeamDuration](#beamduration)
25. [BeamOriginMode](#beamoriginmode)
26. [BeamDestinationMode](#beamdestinationmode)
27. [SSRRingType](#ssrringtype)
28. [bNoOwnFootsteps](#bnoownfootsteps)
29. [DesiredNetUpdateRate](#desirednetupdaterate)
30. [DesiredNetspeed](#desirednetspeed)
31. [FakeCAPInterval](#fakecapinterval)
32. [bNoSmoothing](#bnosmoothing)
33. [bLogClientMessages](#blogclientmessages)
34. [bEnableKillCam](#benablekillcam)
35. [MinDodgeClickTime](#mindodgeclicktime)
36. [bUseOldMouseInput](#buseoldmouseinput)
37. [SmoothVRController](#smoothvrcontroller)
38. [bShowFPS](#bshowfps)
39. [FPSCounterSmoothingStrength](#fpscountersmoothingstrength)
40. [KillCamMinDelay](#killcammindelay)
41. [bAllowWeaponShake](#ballowweaponshake)
42. [bAutoReady](#bautoready)
43. [bUseCrosshairFactory](#busecrosshairfactory)
44. [CrosshairLayers](#crosshairlayers)

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

## bUnlitSkins
**Type: bool**  
**Default: True**

If `True`, player skins will not be affected by surrounding lighting, usually making them brighter.

## HitSound
**Type: int**  
**Default: 2**  

Plays the specified sound when the server detects you dealing damage to enemies.
## TeamHitSound
**Type: int**  
**Default: 3**  

Plays the specified sound when the server detects you dealing damage to teammates.
## bDisableForceHitSounds
**Type: bool**  
**Default: False**  

If `False`, server can override HitSound and TeamHitSound.
If `True`, server can not override HitSound and TeamHitSound.

## bEnableHitSounds
**Type: bool**  
**Default: True**  

If `True`, plays a sound when a weapon you fire hits an enemy on your client.
If `False`, no sound is played.
## selectedHitSound
**Type: int**  
**Default: 0**  

Index into sHitSound array for the sound to play.
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
**Default: 250**  
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
2. [EnableHitSounds](#enablehitsounds)
3. [SetHitSound](#sethitsound)
4. [ForceModels](#forcemodels)
5. [ListSkins](#listskins)
6. [SetForcedSkins](#setforcedskins)
7. [SetForcedTeamSkins](#setforcedteamskins)
8. [SetShockBeam](#setshockbeam)
9. [SetBeamScale](#setbeamscale)
10. [MyIgSettings](#myigsettings)
11. [SetNetUpdateRate](#setnetupdaterate)
12. [SetMouseSmoothing](#setmousesmoothing)
13. [SetKillCamEnabled](#setkillcamenabled)
14. [DropFlag](#dropflag)
15. [PureLogo](#purelogo)
16. [HitSounds](#hitsounds)
17. [TeamHitSounds](#teamhitsounds)
18. [DisableForceHitSounds](#disableforcehitsounds)
19. [MyHitsounds](#myhitsounds)
20. [TeamInfo](#teaminfo)
21. [SetMinDodgeClickTime](#setmindodgeclicktime)
22. [mdct](#mdct)
23. [EndShot](#endshot)
24. [Hold](#hold)
25. [Go](#go)
26. [AutoDemo](#autodemo)
27. [ShootDead](#shootdead)
28. [SetDemoMask](#setdemomask)
29. [DemoStart](#demostart)
30. [ShowFPS](#showfps)
31. [ShowOwnBeam](#showownbeam)
32. [Ready](#ready)

## EnableDebugData
**Parameters: (bool b)**  

Displays a variety of useful debugging information on screen.
## EnableHitSounds
**Parameters: (bool b)**

Enables/Disables client-side hitsounds.
## SetHitSound
**Parameters: (int hs)**

Switches between the 16 slots available for hitsounds (see [sHitSound](#shitsound)). `hs` must be a value between `0` and `15`.

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
## HitSounds
**Parameters: (int b)**

Changes server-side hit-sound when damaging enemies. See [HitSound setting](#hitsound).
## TeamHitSounds
**Parameters: (int b)**

Changes server-side hit-sound when damaging teammates. See [TeamHitSound setting](#teamhitsound).
## DisableForceHitSounds
Overrides (Team)HitSound choice of the server, even if the server forces its (Team)HitSound choice. See [bDisableForceHitSounds setting](#bdisableforcehitsounds).
## MyHitsounds
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

# Server Installation

Extract the zipped files to your system folder.  
Remove any mention in your ServerPackages and ServerActors of TimTim's NewNet or Deepu's Ultimate NewNet.  
Add the following lines to your server's **UnrealTournament.ini** under **[Engine.GameEngine]**:

**ServerPackages=InstaGibPlus6**  
**ServerActors=InstaGibPlus6.NewNetServer**  
**ServerActors=InstaGibPlus6.PureStats**  

<b>It is highly recommended to set your server's tickrate to 100.</b>

# Usage
For InstaGib, make sure the mutator **InstaGibPlus6.NewNetIG** is loaded via your map vote configuration or during server launch.

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
20. [bNoLockdown](#bnolockdown)
21. [bWarmup](#bwarmup)
22. [bCoaches](#bcoaches)
23. [bAutoPause](#bautopause)
24. [ForceModels](#forcemodels)
25. [ImprovedHUD](#improvedhud)
26. [bDelayedPickupSpawn](#bdelayedpickupspawn)
27. [bTellSpectators](#btellspectators)
28. [PlayerPacks](#playerpacks)
29. [DefaultHitSound](#defaulthitsound)
30. [DefaultTeamHitSound](#defaultteamhitsound)
31. [bForceDefaultHitSounds](#bforcedefaulthitsounds)
32. [TeleRadius](#teleradius)
33. [ThrowVelocity](#throwvelocity)
34. [bForceDemo](#bforcedemo)
35. [bRestrictTrading](#brestricttrading)
36. [MaxTradeTimeMargin](#maxtradetimemargin)
37. [TradePingMargin](#tradepingmargin)
38. [KillCamDelay](#killcamdelay)
39. [KillCamDuration](#killcamduration)
40. [bJumpingPreservesMomentum](#bjumpingpreservesmomentum)
41. [MinPosError](#minposerror)
42. [MaxPosError](#maxposerror)
43. [MaxHitError](#maxhiterror)
44. [MaxJitterTime](#maxjittertime)
45. [MinNetUpdateRate](#minnetupdaterate)
46. [MaxNetUpdateRate](#maxnetupdaterate)
47. [bEnableServerExtrapolation](#benableserverextrapolation)
48. [ShowTouchedPackage](#showtouchedpackage)
49. [ExcludeMapsForKickers](#excludemapsforkickers)

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

**Type: bool**  
**Default: False**  

???

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

## bNoLockdown

**Type: bool**  
**Default: True**  

Whether to have lockdown when players get hit by mini/pulse or not.

- `True` ➜ don't allow lockdown
- `False` ➜ allow lockdown

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

**Type: int**  
**Default: 2**  

HitSound for enemy damage to use when forcing clients (see [bForceDefaultHitSounds](#bforcedefaulthitsounds)).

## DefaultTeamHitSound

**Type: int**  
**Default: 3**  

HitSound for friendly fire to use when forcing clients (see [bForceDefaultHitSounds](#bforcedefaulthitsounds)).

## bForceDefaultHitSounds

**Type: bool**  
**Default: False**  

Force clients to use a specific HitSound.

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
**Default: 250**  
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
**Default: 0.2**  

Trade uncertainty relative to shooters ping. Reasonable values range from 0 to 1. Higher values lead to more trades.

## bEnableServerExtrapolation

**Type: bool**  
**Default: True**  

If enabled the server will extrapolate client movement when the client's movement updates are too far behind the server's timepoint.

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

# Building

1. Go to the installation directory of UT99 in a command shell
2. Use `git clone https://github.com/utspect/InstaGibPlus InstaGibPlus6` to clone the repo
3. Navigate to the newly created directory `InstaGibPlus6`
4. Execute `build.bat`
5. The result of the build process will be available in the `System` folder that is next to `build.bat`

# Credits

**TimTim** - Original NewNet.  
**Deepu** - Ultimate NewNet.  
**AnthraX** - Lots and lots of help with debugging tricky problems.  
**spect** - Starting this project.  
**Deaod** - Maintenance.  
**UT99 Community** - For their endless patience, support and help testing and reporting bugs.  
**Epic** - For not open sourcing a 20 year old game running on their 20 year old engine.