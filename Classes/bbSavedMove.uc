class bbSavedMove extends SavedMove;

// Player attributes after applying this move
var vector IGPlus_SavedLocation;
var vector IGPlus_SavedVelocity;
var rotator IGPlus_SavedViewRotation;
var int IGPlus_MergeCount;
var int JumpIndex;
var int DodgeIndex;

function Clear2() {
    Clear();
    IGPlus_MergeCount = 0;
    JumpIndex = -1;
    DodgeIndex = -1;
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
     JumpIndex=-1
     DodgeIndex=-1
}
