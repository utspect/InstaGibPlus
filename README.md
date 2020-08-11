# InstaGib+
A competitive Unreal Tournament GOTY InstaGib fork of TimTim's NewNet.

# Features
Tweaked netcode values.<br>
Working client forced models for enemies and team mates.<br>
Working client hitsounds with the option to use custom hitsound packages.<br>
Different Shock beam types.<br>

# Installation
Extract the zipped files to your system folder.<br>
Remove any mention in your ServerPackages and ServerActors of TimTim's NewNet or Deepu's Ultimate NewNet.<br>
Add the following lines to your server's <b>UnrealTournament.ini</b> under <b>[Engine.GameEngine]</b>:<br><br>
<b>ServerPackages=InstaGibPlus4</b><br>
<b>ServerActors=InstaGibPlus4.NewNetServer</b><br>
<b>ServerActors=InstaGibPlus4.PureStats</b><br>

<b>It is highly recommended to set your server's tickrate to 100.</b>

# Usage
For InstaGib, make sure the mutator <b>InstaGibPlus4.NewNetIG</b> is loaded via your map vote configuration or during server launch.<br><br>
InstaGib+ has minimal weapons code and will load the default UT weapons if the NewNetIG mutator is not loaded, so it is absolutely unusable in normal weapons, make sure to use it only if your objective is to play or to run an InstaGib centered server.<br><br>
When connected to the server type <b>'mutate playerhelp'</b> in the console to view the available commands and options.

# InstaGib Plus Player Commands:
	
- ForceModels x (0 = Off, 1 = On. Default = 0) - The models will be forced to the model you select.
- TeamInfo x (0 = Off, 1 = On, Default = 1)
- MyIGSettings (Displays your current IG+ settings)
- ShowNetSpeeds (Shows the netspeeds other players currently have)
- ShowTickrate (Shows the tickrate server is running on)
- SetForcedTeamSkins x (Set forced skins for your team mates. Range: 0-16, Default: 0)
- SetForcedSkins x (Set forced skins for your enemies. Range: 0-16, Default: 0)
- EnableHitSounds x (Enables or disables hitsounds, 0 is disabled, 1 is enabled. Default: 1)
- SetHitSound x (Sets your current hitsound. Range: 0-16, Default: 0 )
- ListSkins (Lists the available skins that can be forced)
- SetShockBeam (1 = Default, 2 = smithY's beam, 3 = No beam, 4 = instant beam) - Sets your Shock Rifle beam type.
- SetBeamScale x (Sets your Shock Rifle beam scale. Range: 0.1-1, Default 0.45)
- SetNetUpdateRate x (Changes how often you update the server on your position, Default: 100)
- SetMouseSmoothing x (0/False disables smoothing, 1/True enables smoothing, Default: True)


# InstaGib Plus Admin Commands:
- ShowIPs (Shows the IP of players)
- ShowID (Shows the ID of players)
- KickID x (Will Kick player with ID x)
- BanID x (Will Ban & Kick player with ID x)
- EnablePure/DisablePure
- ShowDemos (Will show who is recording demos)

As spectator, you may need to add 'mutate pure' + command (mutate pureshowtickrate)

# Credits<br>
<b>TimTim</b> - Original NewNet.<br>
<b>Deepu</b> - Ultimate NewNet.<br>
<b>Deaod</b> - For the support and pointers when I got stuck, without him I don't think I could've finished this so fast.<br>
<b>UT99 Community</b> - For their endless patience, support and help testing and reporting bugs.<br>
<b>Epic</b> - For not open sourcing a 20 year old game running on their 20 year old engine.

# Settings

## Client Settings

### bForceModels (bool, default: False)
If set to `True`, forces all other players to use fixed models and skins (see DesiredSkin settings).
If set to `False`, all players will show as their chosen model and skin.
#### List of Skins
Note that these numbers only apply when editing INI settings
- `0` - Class: Female Commando, Skin: Aphex, Face: Idina
- `1` - Class: Female Commando, Skin: Commando, Face: Anna
- `2` - Class: Female Commando, Skin: Mercenary, Face: Jayce
- `3` - Class: Female Commando, Skin: Necris, Face: Cryss
- `4` - Class: Female Soldier, Skin: Marine, Face: Annaka
- `5` - Class: Female Soldier, Skin: Metal Guard, Face: Isis
- `6` - Class: Female Soldier, Skin: Soldier, Face: Lauren
- `7` - Class: Female Soldier, Skin: Venom, Face: Athena
- `8` - Class: Female Soldier, Skin: War Machine, Face: Cathode
- `9` - Class: Male Commando, Skin: Commando, Face: Blake
- `10` - Class: Male Commando, Skin: Mercenary, Face: Boris
- `11` - Class: Male Commando, Skin: Necris, Face: Grail
- `12` - Class: Male Soldier, Skin: Marine, Face: Malcolm
- `13` - Class: Male Soldier, Skin: Metal Guard, Face: Drake
- `14` - Class: Male Soldier, Skin: RawSteel, Face: Arkon
- `15` - Class: Male Soldier, Skin: Soldier, Face: Brock
- `16` - Class: Male Soldier, Skin: War Machine, Face: Matrix
- `17` - Class: Boss, Skin: Boss, Face: Xan
### DesiredSkin (int, default: 9)
### DesiredSkinFemale (int, default: 0)
### DesiredTeamSkin (int, default: 9)
### DesiredTeamSkinFemale (int, default: 0)

### HitSound (int, default: 2)
Plays the specified sound when the server detects you dealing damage to enemies.
### TeamHitSound (int, default: 3)
Plays the specified sound when the server detects you dealing damage to teammates.
### bDisableForceHitSounds (bool, default: False)
If `False`, server can override HitSound and TeamHitSound.
If `True`, server can not override HitSound and TeamHitSound.

### bEnableHitSounds (bool, default: True)
If `True`, plays a sound when a weapon you fire hits an enemy on your client.
If `False`, no sound is played.
### selectedHitSound (int, default: 0)
Index into sHitSound array for the sound to play.
### sHitSound (string\[16\])
Specifies sounds that can be played.

### bDoEndShot (bool, default: False)
If `True`, automatically create a screenshot at the end of a match.
If `False`, no screenshot is automatically created.
### bAutoDemo (bool, default: False)
If `True`, automatically start recording a demo when the game starts.
### DemoMask (string)
Template for the name of the demo started because of [bAutoDemo](#bautodemo-bool-default-false).
The following (case-insensitive) placeholders will be replaced with match-specific details:
- `%E` -> Name of the map file
- `%F` -> Title of the map
- `%D` -> Day (two digits)
- `%M` -> Month (two digits)
- `%Y` -> Year
- `%H` -> Hour
- `%N` -> Minute
- `%T` -> Combined Hour and Minute (two digits each)
- `%C` -> Clan Tags (detected by determining common prefix of all players on a team, or "Unknown")
- `%L` -> Name of the recording player
- `%%` -> Replaced with a single %
### DemoPath (string)
Prefix for name of the demo started because of [bAutoDemo](#bautodemo-bool-default-false).
### DemoChar (string)
Characters filesystems can not handle are replaced with this.

### bTeamInfo (bool, default: True)
if Client wants extra team info.
### bShootDead (bool, default: False)
If `True`, client shots can collide with carcasses from dead players.
If `False`, client shots will not collide with carcasses.

### cShockBeam (int, default: 1)
The style of beam to use for the SuperShockRifle.
- `1` -> Default beam
- `2` -> Team colored beam that looks like a projectile
- `3` -> No beam at all
- `4` -> Team colored, instant beam
### BeamScale (float, default: 0.45)
Visuals for the beam are scaled with this factor
### BeamFadeCurve (float, default: 4.0)
Exponent of the polynomial curve the beam's visuals decay with
### BeamDuration (float, default: 0.75)
The time the beam's visuals decay over.
### BeamOriginMode (int, default: 0)
- `0` -> Originates where the player was when the shot was fired
- `1` -> Originates at an offset from where the player is on your screen.

### bNoOwnFootsteps (bool, default: False)
If `True`, footstep sounds are not played for your own footsteps.
If `False`, your own footstep sounds will be played.
### DesiredNetUpdateRate (float, default: 100)
How often you want your client to update the server on your movement. The server places upper and lower limits on this (see [MinNetUpdateRate](#minnetupdaterate-float-default-60), [MaxNetUpdateRate](#maxnetupdaterate-float-default-250)), and the actual update rate will never exceed your netspeed divided by 100.

This is here to provide players with constrained upload bandwidth a way to reduce the required upload bandwidth at the expense of greater susceptibility to packet loss, and glitches arising from it.

Players with high upload bandwidth can set this to a high value to lessen the impact of packet loss.
### FakeCAPInterval (float, defaul: 0.1)
Tells the server to send an acknowledgement of your movement updates (see [DesiredNetUpdateRate](#desirednetupdaterate-float-default-100)) after this amount of time has passed since the last acknowledgement. This saves download bandwidth and lessens server load.

Smaller values (closer to 0) result in acknowledgements being sent more frequently, negative values send an acknowledgement for every movement update.
Higher values result in less frequent acknowledgements which can result in degraded client performance (FPS), or even crashes.
### bNoSmoothing (bool, default: False)
The default mouse input smoothing algorithm always smears input over at least two frames, half the input being applied on one frame, the other half on the next frame. If set to `True`, the game will always apply all input on the current frame. If set to `False`, the default algorithm will be used.

This is a backport from UT99 client version 469, where the equivalent setting is called bNoMouseSmoothing.
### bLogClientMessages (bool, default: True)
Causes all ClientMessages to be logged, if set to `True`
### bEnableKillCam (bool, default: False)
KillCam follows the player that killed you for two seconds.
### MinDodgeClickTime (float, default: 0.0)
Minimum time between two presses of the same direction for them to count as a dodge.
### bUseOldMouseInput (bool, default: False)
The old mouse input processing algorithm discards the fractional part before turning the view according to the mouse input. The new algorithm preserves fractional rotation across frames.

A players view is defined by yaw and pitch, which are quantized to 65536 degrees (a circle has 65536 degrees instead of 360). If a players mouse input sensitivity is set such that the players mouse input can result in some fraction of a degree, that fractional part must be discarded before the view is changed. The new algorithm preserves that fractional part and adds it to the next mouse input.

If `True`, two successive inputs of 1.5° change in yaw result in a 2° turn (int(1.5) + int(1.5) = 1 + 1 = 2).
If `False`, two successive inputs of 1.5° change in yaw result in a 3° turn.
### SmoothVRController (PIDControllerSettings, default: (p=0.09,i=0.05,d=0.00))
This holds the PID settings for the controller thats smoothing the view of players youre spectating as a spectator (see [PID controller](https://en.wikipedia.org/wiki/PID_controller)).

## Server Settings
Server settings can be found inside InstaGibPlus.ini.

### HeadshotDamage (float, default: 100)
Controls how much damage a headshot with the sniper rifle deals.
### SniperSpeed (float, default: 1)
Controls sniper rifle reload time, higher values lead to less time between shots.
### SniperDamagePri (float, default: 60)
Controls damage of body hits by sniper rifle.
### SetPendingWeapon (bool, default: False)
???
### NNAnnouncer (bool, default: False)
Whether to automatically add an announcer for multi-kills, or not.
### bUTPureEnabled (bool, default: True)
Big switch to enable/disable IG+.
### Advertise (int, default: 1)
Controls whether to add a tag to the server's name.
- `1` - Add tag at the beginning of the server's name
- `2` - Add tag at the end of the server's name
- anything else - Dont advertise
### AdvertiseMsg (int, default: 1)
Controls the tag to add to the server's name
- `0` - `[CSHP]`
- `1` - `[IG+]`
- anything else - `[PWND]`
### bAllowCenterView (bool, default: False)
Whether to allow use of the bSnapLevel button or not.
### CenterViewDelay (float, default: 1)
If bAllowCenterView is True, controls how much time has to pass between uses of bSnapLevel.
### bAllowBehindView (bool, default: False)
Whether to allow 3rd Person perspective or not.
### TrackFOV (int, default: 0)
Controls how strictly the FOV is checked.
- `1` - very strict, no zooming with sniper
- `2` - looser, zooming with sniper possible
- anything else - no restrictions
### bAllowMultiWeapon (bool, default: False)
Whether to allow the multi-weapon bug to be (ab)used
### bFastTeams (bool, default: True)
Whether to allow the use of `mutate FixTeams`, `mutate NextTeam`, and `mutate ChangeTeam <Team>` or not. `True` enables the use of these commands, `False` disables.
### bUseClickboard (bool, default: True)
Enables a set of alternative scoreboards that show the ready-status for players before the match has started.
### MinClientRate (int, default: 10000)
The server will force clients to use at least this netspeed.
### bAdvancedTeamSay (bool, default: True)
Whether to allow the use of advanced TeamSay or not.
Advanced TeamSay allows showing game-information in your chat messages, by replacing the following with the corresponding information:
- `%H` -> "<Health> Health"
- `%h` -> "<Health>%"
- `%W` -> "<WeaponName>" or "Empty hands"
- `%A` -> "Shieldbelt and <Armor> Armor" or "<Armor> Armor"
- `%a` -> "SB <Armor>A" or "<Armor>A"
- `%P`, `%p` -> Current CTF objective
### ForceSettingsLevel (int, default: 2)
When to check that default settings for all objects are correct client-side.
- `0` and below -> never
- `1` -> once after PostNetBeginPlay
- `2` -> in addition, every time a new object is spawned
- `3` and above -> in addition, once every 5000 server-ticks on average
### bNoLockdown (bool, default: True)
Whether to have lockdown when players get hit by mini/pulse or not.
- `True` -> don't allow lockdown
- `False` -> allow lockdown
### bWarmup (bool, default: True)
Whether to allow warmup in tournament games or not.
### bCoaches (bool, default: False)
Whether to allow spectators to coach teams in tournament games or not.
### bAutoPause (bool, default: True)
Whether to automatically pause the game in tournament games or not.
### ForceModels (int, default: 1)
Force models mode.
- `1` -> Client controlled
- `2` -> Forced on
- anything else -> Disabled
### ImprovedHUD (int, default: 1)
Enable various HUD improvements. Depends on PureClickBoard mutator (set [bUseClickboard](#buseclickboard-bool-default-true) to `True`, or add mutator through configuration).
- `1` -> Show boots, Clock
- `2` -> In addition, show enhanced team info
- anything else -> dont show anything
### bDelayedPickupSpawn (bool, default: False)
Enable or disable delayed first pickup spawn.
### bTellSpectators (bool, default: False)
Enable or disable telling spectators of reason for kicks.
### PlayerPacks (string\[8\], default: Empty)
Config list of supported player packs
### DefaultHitSound (int, default: 2)
HitSound for enemy damage to use when forcing clients (see [bForceDefaultHitSounds](#bforcedefaulthitsounds-bool-default-false)).
### DefaultTeamHitSound (int, default: 3)
HitSound for friendly fire to use when forcing clients (see [bForceDefaultHitSounds](#bforcedefaulthitsounds-bool-default-false)).
### bForceDefaultHitSounds (bool, default: False)
Force clients to use a specific HitSound.
### TeleRadius (int, default: 210)
Radius within which to telefrag enemies using translocator.
### ThrowVelocity (int, default: 750)
Horizontal speed with which to throw weapons.
### bForceDemo (bool, default: False)
Forces clients to do demos.
### MinPosError (float, default: 100)
Unused. Intended to be minimum squared distance error for updating clients.
### MaxPosError (float, default: 3000)
Unused. Intended to be maximum squared distance error for updating clients.
### MaxHitError (float, default: 10000)
Distance to any position over the last 500ms for hits to be counted.
### ShowTouchedPackage (bool, default: False)
Send package-names of touched actors to clients when those clients touch the actors.
### ExcludeMapsForKickers (string\[128\], default: Empty)
List of map names (with or without .unr) for maps that should not have their Kickers replaced with NN_Kickers.
### MaxJitterTime (float, default 0.1)
Maximum time between updates by clients that's tolerated by IG+. If a client exceeds this time and [bEnableJitterBounding](#benablejitterbounding-bool-default-true) is `True` an update is generated for the client. Guideline setting is half the maximum supported ping.
### MinNetUpdateRate (float, default: 60)
Minimum frequency of client updates for server.
### MaxNetUpdateRate (float, default: 250)
Maximum frequency of client updates for server.
### MaxClientRate (int, default: 25000)
Maximum netspeed allowed for clients.
### MaxTradeTimeMargin (float, default: 0.1)
Maximum time after death (on server) that players can still fire their weapons.
### bEnableServerExtrapolation (bool, default: True)
If enabled the server will extrapolate client movement when the client's movement updates are too far behind the server's timepoint.
### bEnableJitterBounding (bool, default: True)
If enabled the server will generate movement updates for clients that havent sent updates in a while.