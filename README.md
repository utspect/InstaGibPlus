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
<b>ServerPackages=InstaGibPlus</b><br>
<b>ServerActors=InstaGibPlus.NewNetServer</b><br>
<b>ServerActors=InstaGibPlus.PureStats</b><br>

<b>It is highly recommended to set your server's tickrate to 100.</b>

# Usage
If you want to make sure InstaGib+ is loaded every map you can also add under <b>[Engine.GameEngine]</b>:<br><br>
<b>ServerActors=InstaGibPlus.NewNetIG</b><br><br>
otherwise make sure the mutator <b>InstaGibPlus.NewNetIG</b> is loaded via your map vote configuration or during server launch.<br><br>
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