class SpecMessagePlus extends IGPlus_DeathMessagePlus;

static function ClientReceive(
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_1 == TournamentPlayer(P.ViewTarget).PlayerReplicationInfo)
	{
		// Interdict and send the child message instead.
		if ( CHSpectator(P).myHUD != None )
		{
			CHSpectator(P).myHUD.LocalizedMessage( Default.ChildMessage, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
			//CHSpectator(P).myHUD.LocalizedMessage( Default.Class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
		}
		/*
		if ( Default.bIsConsoleMessage )
		{
			CHSpectator(P).Player.Console.AddString(Static.GetString( Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject ));
		}
		*/
		if (( RelatedPRI_1 != RelatedPRI_2 ) && ( RelatedPRI_2 != None ))
		{
			if ( (CHSpectator(P).Level.TimeSeconds - TournamentPlayer(P.ViewTarget).LastKillTime < 3) && (Switch != 1) )
			{
				TournamentPlayer(P.ViewTarget).MultiLevel++;
				//CHSpectator(P).ReceiveLocalizedMessage( class'MMultiKillMessage', TournamentPlayer(P.ViewTarget).MultiLevel );
				CHSpectator(P).ReceiveLocalizedMessage( class'MultiKillMessage', TournamentPlayer(P.ViewTarget).MultiLevel );
			}
			else
				TournamentPlayer(P.ViewTarget).MultiLevel = 0;
			TournamentPlayer(P.ViewTarget).LastKillTime = CHSpectator(P).Level.TimeSeconds;
		}
		else
			TournamentPlayer(P.ViewTarget).MultiLevel = 0;
		if ( ChallengeHUD(P.MyHUD) != None )
			ChallengeHUD(P.MyHUD).ScoreTime = CHSpectator(P).Level.TimeSeconds;
	}
	else if (RelatedPRI_2 == TournamentPlayer(P.ViewTarget).PlayerReplicationInfo)
	{
		CHSpectator(P).ReceiveLocalizedMessage( class'VictimMessage', 0, RelatedPRI_1 );
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	else
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}