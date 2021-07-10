class IGPlus_SavedMove extends SavedMove;

// Player attributes after applying this move
var vector IGPlus_SavedLocation;
var vector IGPlus_SavedVelocity;
var rotator IGPlus_SavedViewRotation;
var int IGPlus_MergeCount;
var int JumpIndex;
var int DodgeIndex;
var int RunChangeIndex;
var int DuckChangeIndex;
var int FireIndex;
var int AltFireIndex;
var int AddVelocityId;
var vector Momentum;

function Clear2() {
    Clear();
    IGPlus_MergeCount = 0;
    JumpIndex = -1;
    DodgeIndex = -1;
    RunChangeIndex = -1;
    DuckChangeIndex = -1;
    FireIndex = -1;
    AltFireIndex = -1;
    Momentum = vect(0,0,0);
}

defaultproperties
{
     bHidden=True
     RemoteRole=ROLE_None
     JumpIndex=-1
     DodgeIndex=-1
     RunChangeIndex=-1
     DuckChangeIndex=-1
     FireIndex=-1
     AltFireIndex=-1
}
