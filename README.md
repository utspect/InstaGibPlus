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
<b>ServerActors=InstaGibPlus.PureStats</b><br><br>

<b>It is highly recommended to set your server's tickrate to 100.</b>

# Usage
If you want to make sure InstaGib+ is loaded every map you can also add under <b>[Engine.GameEngine]</b>:<br><br>
<b>ServerActors=InstaGibPlus.NewNetIG</b><br><br>
otherwise make sure the mutator <b>InstaGibPlus.NewNetIG</b> is loaded via your map vote configuration or during server launch.<br><br>
InstaGib+ has minimal weapons code and will load the default UT weapons if the NewNetIG mutator is not loaded, so it is absolutely unusable in normal weapons, make sure to use it only if your objective is to play or to run an InstaGib centered server.<br><br>
When connected to the server type <b>'mutate playerhelp'</b> in the console to view the available commands and options.


# Credits<br>
<b>TimTim</b> - Original NewNet.<br>
<b>Deepu</b> - Ultimate NewNet.<br>
<b>Deaod</b> - For the support and pointers when I got stuck, without him I don't think I could've finished this so fast.<br>
<b>UT99 Community</b> - For their endless patience, support and help testing and reporting bugs.<br>
<b>Epic</b> - For not open sourcing a 20 year old game running on their 20 year old engine.
