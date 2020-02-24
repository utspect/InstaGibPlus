// ====================================================================
//  Class:  ClickBoard.ClickCTFScoreBoard
//  Parent: Botpack.UnrealCTFScoreBoard
//
//  <Enter a description here>
// ====================================================================

class PureCTFScoreBoard extends UnrealCTFScoreBoard;

var Texture PureFlagIcon;

function DrawNameAndPing(Canvas Canvas, PlayerReplicationInfo PRI, float XOffset, float YOffset, bool bCompressed)
{
	if (PRI.HasFlag != None && PRI.HasFlag.IsA('PureFlag') )
	{
		// Flag icon
		Super(TeamScoreBoard).DrawNameAndPing(Canvas, PRI, XOffset, YOffset, bCompressed);
		Canvas.DrawColor = WhiteColor;
		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.SetPos(XOffset - 32, YOffset);
		Canvas.DrawIcon(PureFlagIcon, 1.0);
	}
	else
		Super.DrawNameAndPing(Canvas, PRI, XOffset, YOffset, bCompressed);
}

defaultproperties
{
     PureFlagIcon=Texture'Botpack.Icons.GreenFlag'
}
