//=============================================================================
// ST_Ammos.
//=============================================================================
class ST_Ammos expands TournamentAmmo;

#exec Audio Import FILE=Sounds\ASnd.wav

defaultproperties
{
    bCollideActors=True
	bClientAnim=False
	PickupSound=Sound'ASnd'
}