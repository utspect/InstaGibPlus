# InstaGib+
A competitive Unreal Tournament GOTY InstaGib fork of TimTim's NewNet.

# Features
Tweaked netcode values.<br>
Working client forced models for enemies and team mates.<br>
Working client hitsounds with the option to use custom hitsound packages.<br>
Different Shock beam types.<br>

# Installation
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
- SetShockBeam (1 = Default, 2 = smithY's beam, 3 = No beam) - Sets your Shock Rifle beam type.
- SetBeamScale (Sets your Shock Rifle beam scale. Range: 0.1-1, Default 0.45)


# InstaGib Plus Admin Commands:
- ShowIPs (Shows the IP of players)
- ShowID (Shows the ID of players)
- KickID x (Will Kick player with ID x)
- BanID x (Will Ban & Kick player with ID x)
- EnablePure/DisablePure
- ShowDemos (Will show who is recording demos)


# Credits<br>
<b>TimTim</b> - Original NewNet.<br>
<b>Deepu</b> - Ultimate NewNet.<br>
<b>Deaod</b> - For the support and pointers when I got stuck, without him I don't think I could've finished this so fast.<br>
<b>UT99 Community</b> - For their endless patience, support and help testing and reporting bugs.<br>
<b>Epic</b> - For not open sourcing a 20 year old game running on their 20 year old engine.
