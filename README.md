# InstaGib+
A competitive Unreal Tournament GOTY InstaGib fork of TimTim's NewNet.

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
6. [HitSound](#hitsound)
7. [TeamHitSound](#teamhitsound)
8. [bDisableForceHitSounds](#bdisableforcehitsounds)
9. [bEnableHitSounds](#benablehitsounds)
10. [selectedHitSound](#selectedhitsound)
11. [sHitSound](#shitsound)
12. [bDoEndShot](#bdoendshot)
13. [bAutoDemo](#bautodemo)
14. [DemoMask](#demomask)
15. [DemoPath](#demopath)
16. [DemoChar](#demochar)
17. [bTeamInfo](#bteaminfo)
18. [bShootDead](#bshootdead)
19. [cShockBeam](#cshockbeam)
20. [BeamScale](#beamscale)
21. [BeamFadeCurve](#beamfadecurve)
22. [BeamDuration](#beamduration)
23. [BeamOriginMode](#beamoriginmode)
24. [bNoOwnFootsteps](#bnoownfootsteps)
25. [DesiredNetUpdateRate](#desirednetupdaterate)
26. [FakeCAPInterval](#fakecapinterval)
27. [bNoSmoothing](#bnosmoothing)
28. [bLogClientMessages](#blogclientmessages)
29. [bEnableKillCam](#benablekillcam)
30. [MinDodgeClickTime](#mindodgeclicktime)
31. [bUseOldMouseInput](#buseoldmouseinput)
32. [SmoothVRController](#smoothvrcontroller)

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

# Client Commands
The following commands are additions by IG+ to the standard set of commands.

Types for parameters:

* bool: Binary value, `True`/`1` or `False`/`0`
* int: Whole number, e.g. `6`, `78`
* float: Real number, e.g. `1.35`, accurate up to 7 significant digits
* string: String of characters, e.g. `"Hello, World!"`

Parameters marked `optional` do not have to be supplied.

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

# Server Installation

Extract the zipped files to your system folder.  
Remove any mention in your ServerPackages and ServerActors of TimTim's NewNet or Deepu's Ultimate NewNet.  
Add the following lines to your server's **UnrealTournament.ini** under **[Engine.GameEngine]**:

**ServerPackages=InstaGibPlus5**  
**ServerActors=InstaGibPlus5.NewNetServer**  
**ServerActors=InstaGibPlus5.PureStats**  

<b>It is highly recommended to set your server's tickrate to 100.</b>

# Usage
For InstaGib, make sure the mutator **InstaGibPlus5.NewNetIG** is loaded via your map vote configuration or during server launch.

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

Maximum time between updates by clients that's tolerated by IG+. If a client exceeds this time and [bEnableJitterBounding](#benablejitterbounding) is `True` an update is generated for the client. Guideline setting is half the maximum supported ping.

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
## MaxClientRate
**Type: int**  
**Default: 25000**  
**Unit: B/s**  

Maximum netspeed allowed for clients.

## MaxTradeTimeMargin

**Type: float**  
**Default: 0.1**  
**Unit: s**  

Maximum time after death (on server) that players can still fire their weapons.

## bEnableServerExtrapolation

**Type: bool**  
**Default: True**  

If enabled the server will extrapolate client movement when the client's movement updates are too far behind the server's timepoint.

## bEnableJitterBounding

**Type: bool**  
**Default: True**  

If enabled the server will generate movement updates for clients that havent sent updates in a while.

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

# Building

1. Go to the installation directory of UT99 in a command shell
2. Use `git clone https://github.com/utspect/InstaGibPlus InstaGibPlus5` to clone the repo
3. Navigate to the newly created directory `InstaGibPlus5`
4. Execute `build.bat`
5. The result of the build process will be available in the `System` folder that is next to `build.bat`

# Credits

**TimTim** - Original NewNet.  
**Deepu** - Ultimate NewNet.  
**Deaod** - For the support and pointers when I got stuck, without him I don't think I could've finished this so fast.  
**UT99 Community** - For their endless patience, support and help testing and reporting bugs.  
**Epic** - For not open sourcing a 20 year old game running on their 20 year old engine.