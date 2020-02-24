class NNAnnouncer expands Mutator;

#exec AUDIO IMPORT FILE="Sounds\LudicrousKill.WAV" NAME="LudicrousKill"
#exec AUDIO IMPORT FILE="Sounds\HolyShit.WAV" NAME="HolyShit"

function PostBeginPlay ()
{
         super.PostBeginPlay();
         Level.Game.DeathMessageClass = class'DDeathMessagePlus';
}