// ===============================================================
// UTPureRC7A.bbCHCoach: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

// Todo
// Fix: Say -> To all -- done
// Fix: TeamSay -> To team -- done
// Fix: Make behindview behave like players (If pure disallows, disallow for coach) -- done

class bbCHCoach extends bbCHSpectator;

// Load the "static" texture.
#exec OBJ LOAD FILE=..\Textures\LadrStatic.utx PACKAGE=Botpack.LadrStatic

// Coaching variables.
var TeamInfo CoachTeam;

// The text you get when joining as Coach
var string CoachHelpText, CoachHelpText2, CoachHelpText3;

replication
{
	// Client -> Server
	reliable if (ROLE < ROLE_Authority)
		Coach, Hold, Go;
	
	// Server -> Client
	reliable if (bNetOwner && ROLE == ROLE_Authority)
		CoachTeam;
}

exec function Coach(string Team)
{
	local TeamGamePlus TGP;
	local int x;

	TGP = TeamGamePlus(Level.Game);
	if (TGP == None)	// Coaches should never be allowed unless bTournament TeamGamePlus+!!!
		return;
	
	if (CoachTeam != None)
	{
		ClientMessage("You are already coaching"@CoachTeam.TeamName$"!");
		return;
	}

	x = -1;
	if (Team ~= "Red" || Team ~= "0")
		x = 0;
	else if (Team ~= "Blue" || Team ~= "1")
		x = 1;
	
	if (x < 0 || TGP.Teams[x].Size <= 0)
	{
		ClientMessage(Team@"is not a valid/recognized team or has no players!");
	}
	else
	{
		CoachTeam = TGP.Teams[x];
		PlayerReplicationInfo.Team = CoachTeam.TeamIndex;
		BroadcastMessage(PlayerReplicationInfo.PlayerName@"is now coaching"@CoachTeam.TeamName@"Team!", True);
		GotoState('Coaching');
	}
}

// Hold & Go for Admins
exec function Hold()
{
	if (PlayerReplicationInfo.bAdmin && zzUTPure.zzAutoPauser != None)
		zzUTPure.zzAutoPauser.PlayerHold(PlayerReplicationInfo);
}

exec function Go()
{
	if (PlayerReplicationInfo.bAdmin && zzUTPure.zzAutoPauser != None)
		zzUTPure.zzAutoPauser.PlayerGo(PlayerReplicationInfo);
}

simulated function RenderStatic(Canvas Canvas, int ShowHint)
{
	local float X,Y;

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor = ChallengeHUD(myHUD).BlueColor;
	Canvas.DrawTile(texture'LadrStatic.Static_a00', Canvas.ClipX, Canvas.ClipY, 0, 0, texture'LadrStatic.Static_a00'.USize, texture'LadrStatic.Static_a00'.VSize);
	Canvas.Font = ChallengeHUD(myHUD).MyFonts.GetBigFont(Canvas.ClipX);
	Canvas.DrawColor = ChallengeHUD(myHUD).WhiteColor;
	if (ShowHint == 1)
	{
		Canvas.StrLen(CoachHelpText, X, Y);
		Canvas.SetPos((Canvas.ClipX - X) * 0.5, Canvas.ClipY * 0.85 - Y);
		Canvas.DrawText(CoachHelpText);
		Canvas.StrLen(CoachHelpText2, X, Y);
		Canvas.SetPos((Canvas.ClipX - X) * 0.5, Canvas.ClipY * 0.85);
		Canvas.DrawText(CoachHelpText2);
	}
	else if (ShowHint == 2)
	{
		Canvas.StrLen(CoachHelpText3, X, Y);
		Canvas.SetPos((Canvas.ClipX - X) * 0.5, Canvas.ClipY * 0.85);
		Canvas.DrawText(CoachHelpText3);
	}
}

auto state CheatFlying
{
	event PostRender(Canvas Canvas)
	{
		if (PlayerReplicationInfo == None || !PlayerReplicationInfo.bAdmin)
			RenderStatic(Canvas, 1);	// Hide action from non-admin coach until he selects a team darnit.
		Global.PostRender(Canvas);
	}
}

state Coaching extends CheatFlying
{
	event PostRender(Canvas Canvas)
	{
		if (ViewTarget == None || ViewTarget == Self)
			RenderStatic(Canvas, 2);	// If the coach should happen to have nobody to view.
		Global.PostRender(Canvas);
	}

	exec function BehindView( Bool B )
	{	// Limit behindview if pure wishes it so
		if (Class'UTPure'.Default.bAllowBehindView)
			bBehindView = B;
		else
			bBehindView = False;
		bChaseCam = bBehindView;
	}

	exec function CheatView( class<actor> aClass );				// Disable
	exec function ViewSelf();						// Ditto
	exec function ViewClass( class<actor> aClass, optional bool bQuiet );	// This one too.

	// Only allow viewing own team.
	function DoViewPlayerNum(int num)
	{
		local Pawn P;

		if ( num >= 0 )
		{
			P = Pawn(ViewTarget);
			for ( P=Level.PawnList; P!=None; P=P.NextPawn )
				if ( (P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
					&& !P.PlayerReplicationInfo.bIsSpectator
					&& (P.PlayerReplicationInfo.PlayerID == num) )
				{
					if ( P != self )
					{
						ViewTarget = P;
						bBehindView = false;
					}
					return;
				}
			return;
		}
		if ( Role == ROLE_Authority )
		{
			DoViewClass(class'Pawn', true);
			While ( (ViewTarget != None) 
					&& (!Pawn(ViewTarget).bIsPlayer || Pawn(ViewTarget).PlayerReplicationInfo.bIsSpectator) && (Pawn(ViewTarget).PlayerReplicationInfo.Team != PlayerReplicationInfo.Team) )
				DoViewClass(class'Pawn', true);

			if ( ViewTarget != None )
				ClientMessage(ViewingFrom@Pawn(ViewTarget).PlayerReplicationInfo.PlayerName, 'Event', true);
			else
				ClientMessage(ViewingFrom@OwnCamera, 'Event', true);
		}
	}

	exec function FindFlag()
	{
		local PlayerReplicationInfo PRI;
		local Pawn P;
		
		P = Pawn(ViewTarget);

		if (P != None && CTFFlag(P.PlayerReplicationInfo.HasFlag) != None)
			return;					// Already watching flagcarrier.

		ForEach AllActors(Class'PlayerReplicationInfo',PRI)
		{
			if (CTFFlag(PRI.HasFlag) != None && PRI.Team == PlayerReplicationInfo.Team)
			{
				ViewPlayerNum(PRI.TeamID);	// Watch this player.
				return;
			}
		}
		ClientMessage("Nobody on your team has the flag!");
	}


	exec function TeamSay( string Msg )
	{	// Teamsay to own team.
		local Pawn P;

		if ( Level.Game.AllowsBroadcast(self, Len(Msg)) )
			for( P=Level.PawnList; P!=None; P=P.nextPawn )
				if( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
				{
					if ( P.IsA('PlayerPawn') )
					{
						if ( (Level.Game != None) && (Level.Game.MessageMutator != None) )
						{
							if ( Level.Game.MessageMutator.MutatorTeamMessage(Self, P, PlayerReplicationInfo, Msg, 'TeamSay', true) )
								P.TeamMessage( PlayerReplicationInfo, Msg, 'TeamSay', true );
						} else
							P.TeamMessage( PlayerReplicationInfo, Msg, 'TeamSay', true );
					}
				}
	}

	// Hold & Go for Coaches
	exec function Hold()
	{
		if (zzUTPure.zzAutoPauser != None)
			zzUTPure.zzAutoPauser.PlayerHold(PlayerReplicationInfo);
	}

	exec function Go()
	{
		if (zzUTPure.zzAutoPauser != None)
			zzUTPure.zzAutoPauser.PlayerGo(PlayerReplicationInfo);
	}
}

defaultproperties
{
     CoachHelpText="Type 'coach 0' to coach red team, and 'coach 1' to coach blue team."
     CoachHelpText2="Logging in as admin will give you normal spectator abilities."
     CoachHelpText3="Select a player to view from."
     bChaseCam=False
}
