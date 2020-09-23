class bbSavedMove extends SavedMove;

// Player attributes after applying this move
var vector IGPlus_SavedLocation;
var vector IGPlus_SavedVelocity;
var rotator IGPlus_SavedViewRotation;
var int IGPlus_MergeCount;

function Clear2() {
    Clear();
    IGPlus_MergeCount = 0;
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
}
