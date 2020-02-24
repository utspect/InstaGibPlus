class SpecSpreeMessage expands KillingSpreeMessage;

static simulated function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	if (RelatedPRI_2 != None)
		return;
	
	if (RelatedPRI_1 != TournamentPlayer(P.ViewTarget).PlayerReplicationInfo)
	{
		P.PlaySound(sound'SpreeSound',, 4.0);
		return;
	}
	P.ClientPlaySound(Default.SpreeSound[Switch],, true);

}

defaultproperties
{
}
