class NNAnnouncer extends Mutator;

function PostBeginPlay ()
{
         super.PostBeginPlay();
         Level.Game.DeathMessageClass = class'IGPlus_DeathMessagePlus';
}