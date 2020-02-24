// ===============================================================
// Stats.ST_TFemale1Bot: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_TFemale1Bot extends ST_FemaleBotPlus;

function ForceMeshToExist()
{
	Spawn(class'TFemale1');
}

defaultproperties
{
     FaceSkin=3
     TeamSkin2=1
     DefaultSkinName="FCommandoSkins.cmdo"
     DefaultPackage="FCommandoSkins."
     SelectionMesh="Botpack.SelectionFemale1"
     MenuName="Female Commando"
     VoiceType="BotPack.VoiceFemaleOne"
     Mesh=LodMesh'Botpack.FCommando'
}
