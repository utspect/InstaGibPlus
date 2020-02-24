// ===============================================================
// Stats.ST_TBossBot: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_TBossBot extends ST_MaleBotPlus;

var float RealSkill, RealAccuracy;
var bool bRatedGame;

function ForceMeshToExist()
{
	Spawn(class'TBoss');
}

function MaybeTaunt(Pawn Other)
{
	if ( !bRatedGame )
		Super.MaybeTaunt(Other);
}

function ReSetSkill()
{
	local float ScaledSkill;
	if ( bRatedGame )
	{
		if ( DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Score > PlayerReplicationInfo.Score + 1 )
		{
			Skill += 1;
			if ( Skill > 3 )
			{
				if ( bNovice )
				{
					bNovice = false;
					Skill = FClamp(Skill - 4, 0, 3);
				}
				else
				{
					Skill = 3;
					Accuracy += 0.3;
				}
			}
		}
		else if ( DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Score < PlayerReplicationInfo.Score )
		{
			ScaledSkill = Skill;
			if ( !bNovice )
				ScaledSkill += 4;
			if ( ScaledSkill > RealSkill )
			{
				Accuracy = RealAccuracy;
				ScaledSkill = FMax(RealSkill, ScaledSkill - 0.5);
				bNovice = ( ScaledSkill < 4 );
				if ( !bNovice )
					ScaledSkill -= 4;
				Skill = FClamp(ScaledSkill, 0, 3);
			}
		}
	}

	Super.ReSetSkill();
}

function StartMatch()
{
	local int R;

	RealSkill = Skill;
	RealAccuracy = Accuracy;
	if ( !bNovice )
		RealSkill += 4;
	bRatedGame = ( Level.Game.IsA('DeathMatchPlus') && DeathMatchPlus(Level.Game).bRatedGame );
	if ( bRatedGame )
	{
		R = Rand(7) + 6;
		if ( R == 10 )
			R = 8;
		SendGlobalMessage(None, 'TAUNT', R, 5);
	}
}

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
		if(!SetSkinElement(SkinActor, 0, SkinName$"1T_"$String(TeamNum), ""))
		{
			if(!SetSkinElement(SkinActor, 0, SkinName$"1", ""))
			{
				SetSkinElement(SkinActor, 0, "BossSkins.boss1T_"$String(TeamNum), "BossSkins.boss1");
				SkinName="BossSkins.boss";
			}
		}
		SetSkinElement(SkinActor, 1, SkinName$"2T_"$String(TeamNum), SkinName$"2");
		SetSkinElement(SkinActor, 2, SkinName$"3T_"$String(TeamNum), SkinName$"3");
		SetSkinElement(SkinActor, 3, SkinName$"4T_"$String(TeamNum), SkinName$"4");
	}
	else
	{
		if(!SetSkinElement(SkinActor, 0, SkinName$"1", "BossSkins.boss1"))
			SkinName="BossSkins.boss";

		SetSkinElement(SkinActor, 1, SkinName$"2", "");
		SetSkinElement(SkinActor, 2, SkinName$"3", "");
		SetSkinElement(SkinActor, 3, SkinName$"4", "");
	}

	if( Pawn(SkinActor) != None ) 
		Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject(SkinName$"5Xan", class'Texture'));
}

defaultproperties
{
     CarcassType=Class'Botpack.TBossCarcass'
     HitSound3=Sound'Botpack.BInjur3'
     HitSound4=Sound'Botpack.BInjur4'
     Deaths(0)=Sound'Botpack.BDeath1'
     Deaths(1)=Sound'Botpack.BDeath1'
     Deaths(2)=Sound'Botpack.BDeath3'
     Deaths(3)=Sound'Botpack.BDeath4'
     Deaths(4)=Sound'Botpack.BDeath3'
     Deaths(5)=Sound'Botpack.BDeath4'
     LandGrunt=Sound'Botpack.Bland01'
     JumpSound=Sound'Botpack.BJump1'
     DefaultSkinName="BossSkins.Boss"
     StatusDoll=Texture'Botpack.BossDoll'
     StatusBelt=Texture'Botpack.BossBelt'
     VoicePackMetaClass="BotPack.VoiceBoss"
     SelectionMesh="Botpack.SelectionBoss"
     HitSound1=Sound'Botpack.BInjur1'
     HitSound2=Sound'Botpack.BInjur2'
     Die=Sound'Botpack.BDeath1'
     MenuName="Boss"
     VoiceType="BotPack.VoiceBotBoss"
     Mesh=LodMesh'Botpack.Boss'
}
