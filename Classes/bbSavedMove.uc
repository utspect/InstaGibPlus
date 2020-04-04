class bbSavedMove extends SavedMove;

// Player attributes after applying this move
var vector SavedLocation;
var vector SavedVelocity;
var rotator SavedViewRotation;

function string ToString()
{
    return "[STAMP]"@TimeStamp@"[DELTA]"@Delta@"[DODGE]"@DodgeMove@"[LOC]"@SavedLocation@"[VEL]"@SavedVelocity@"("@VSize(SavedVelocity)@")"@"[ACCEL]"@Acceleration@"("@VSize(Acceleration)@")";
}

defaultproperties
{
     bHidden=True
}
