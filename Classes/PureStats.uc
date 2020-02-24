// ===============================================================
// UTPureRC7A.PureStats: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class PureStats extends Info;

var byte WhichStat;
var bool bShowStats;			// True when wanting to show

replication
{
	reliable if (bNetOwner && ROLE == ROLE_Authority)
		bShowStats, WhichStat;
}

function SetState(byte Type)
{
	if (WhichStat == Type && bShowStats)
		bShowStats = False;		// Hide if already showing same stats.
	else
		bShowSTats = True;		// Otherwise show
	WhichStat = Type;
}

simulated function PostRender( Canvas Canvas );

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=0.500000
}
