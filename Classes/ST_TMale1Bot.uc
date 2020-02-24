// ===============================================================
// Stats.ST_TMale1Bot: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_TMale1Bot extends ST_MaleBotPlus;

function ForceMeshToExist()
{
	Spawn(class'TMale1');
}

defaultproperties
{
     LandGrunt=Sound'UnrealShare.MLand3'
     JumpSound=Sound'Botpack.TMJump3'
     FaceSkin=1
     TeamSkin1=2
     TeamSkin2=3
     DefaultSkinName="CommandoSkins.cmdo"
     DefaultPackage="CommandoSkins."
     SelectionMesh="Botpack.SelectionMale1"
     MenuName="Male Commando"
     VoiceType="BotPack.VoiceMaleOne"
     Mesh=LodMesh'Botpack.Commando'
}
