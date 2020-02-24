//=============================================================================
// TBoss.
//=============================================================================
class bbTBoss extends bbTournamentMale;


static function SetMultiSkin(Actor SkinActor, string SkinName, string FaceName, byte TeamNum)
{
	local string MeshName, SkinItem, SkinPackage;

	MeshName = SkinActor.GetItemName(string(SkinActor.Mesh));

	SkinItem = SkinActor.GetItemName(SkinName);
	SkinPackage = Left(SkinName, Len(SkinName) - Len(SkinItem));

	if(SkinPackage == "")
	{
		SkinPackage="BossSkins.";
		SkinName=SkinPackage$SkinName;
	}

	if( TeamNum != 255 )
	{
		if(!SetSkinElement(SkinActor, 0, SkinName$"1T_"$String(TeamNum), default.DefaultSkinName$"1T_"$String(TeamNum)))
		{
			if(!SetSkinElement(SkinActor, 0, SkinName$"1", default.DefaultSkinName$"1"))
			{
				SetSkinElement(SkinActor, 0, default.DefaultSkinName$"1T_"$String(TeamNum), default.DefaultSkinName$"1T_"$String(TeamNum));
				SkinName=default.DefaultSkinName;
			}
		}
		SetSkinElement(SkinActor, 1, SkinName$"2T_"$String(TeamNum), SkinName$"2T_"$String(TeamNum));
		SetSkinElement(SkinActor, 2, SkinName$"3T_"$String(TeamNum), SkinName$"3T_"$String(TeamNum));
		SetSkinElement(SkinActor, 3, SkinName$"4T_"$String(TeamNum), SkinName$"4T_"$String(TeamNum));
	}
	else
	{
		if(!SetSkinElement(SkinActor, 0, SkinName$"1", default.DefaultSkinName))
			SkinName=default.DefaultSkinName;

		SetSkinElement(SkinActor, 1, SkinName$"2", SkinName$"2");
		SetSkinElement(SkinActor, 2, SkinName$"3", SkinName$"3");
		SetSkinElement(SkinActor, 3, SkinName$"4", SkinName$"4");
	}

	if( Pawn(SkinActor) != None ) 
		Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject(SkinName$"5Xan", class'Texture'));
}

defaultproperties
{
     FakeClass="Botpack.TBoss"
     Deaths(0)=Sound'Botpack.BDeath1'
     Deaths(1)=Sound'Botpack.BDeath1'
     Deaths(2)=Sound'Botpack.BDeath3'
     Deaths(3)=Sound'Botpack.BDeath4'
     Deaths(4)=Sound'Botpack.BDeath3'
     Deaths(5)=Sound'Botpack.BDeath4'
     FaceSkin=1
     DefaultSkinName="BossSkins.Boss"
     HitSound3=Sound'Botpack.BInjur3'
     HitSound4=Sound'Botpack.BInjur4'
     LandGrunt=Sound'Botpack.Bland01'
     StatusDoll=Texture'Botpack.BossDoll'
     StatusBelt=Texture'Botpack.BossBelt'
     VoicePackMetaClass="BotPack.VoiceBoss"
     CarcassType=Class'Botpack.TBossCarcass'
     JumpSound=Sound'Botpack.BJump1'
     SelectionMesh="Botpack.SelectionBoss"
     SpecialMesh="Botpack.TrophyBoss"
     HitSound1=Sound'Botpack.BInjur1'
     HitSound2=Sound'Botpack.BInjur2'
     Die=Sound'Botpack.BDeath1'
     MenuName="Boss"
     VoiceType="BotPack.VoiceBoss"
     Mesh=LodMesh'Botpack.Boss'
}
