// ====================================================================
//  Class:  UTPureRC1b.UTPureSetupClient
//  Parent: UTMenu.UTPlayerSetupClient
//
//  <Enter a description here>
// ====================================================================

class UTPureSetupClient extends UTPlayerSetupClient;

function LoadCurrent()
{
	local string Voice, OverrideClassName;
	local class<PlayerPawn> OverrideClass;
	local string SN, FN;

	Voice = "";
	NameEdit.SetValue(GetPlayerOwner().PlayerReplicationInfo.PlayerName);
	TeamCombo.SetSelectedIndex(Max(TeamCombo.FindItemIndex2(string(GetPlayerOwner().PlayerReplicationInfo.Team)), 0));
	if(GetLevel().Game != None && GetLevel().Game.IsA('UTIntro') || GetPlayerOwner().IsA('Commander') || GetPlayerOwner().IsA('Spectator'))
	{
		SN = GetPlayerOwner().GetDefaultURL("Skin");
		FN = GetPlayerOwner().GetDefaultURL("Face");
		ClassCombo.SetSelectedIndex(Max(ClassCombo.FindItemIndex2(GetPlayerOwner().GetDefaultURL("Class"), True), 0));
		Voice = GetPlayerOwner().GetDefaultURL("Voice");
	}
	else
	{
		if (bbPlayer(GetPlayerOwner()) != None)
			ClassCombo.SetSelectedIndex(Max(ClassCombo.FindItemIndex2(bbPlayer(GetPlayerOwner()).FakeClass, True), 0));
		else
			ClassCombo.SetSelectedIndex(Max(ClassCombo.FindItemIndex2(string(GetPlayerOwner().Class), True), 0));
		GetPlayerOwner().static.GetMultiSkin(GetPlayerOwner(), SN, FN);
	}
	SkinCombo.SetSelectedIndex(Max(SkinCombo.FindItemIndex2(SN, True), 0));
	FaceCombo.SetSelectedIndex(Max(FaceCombo.FindItemIndex2(FN, True), 0));

	if(Voice == "")
		Voice = string(GetPlayerOwner().PlayerReplicationInfo.VoiceType);

	IterateVoices();
	VoicePackCombo.SetSelectedIndex(Max(VoicePackCombo.FindItemIndex2(Voice, True), 0));

	OverrideClassName = GetPlayerOwner().GetDefaultURL("OverrideClass");
	if(OverrideClassName != "")
		OverrideClass = class<PlayerPawn>(DynamicLoadObject(OverrideClassName, class'Class'));

	SpectatorCheck.bChecked = (OverrideClass != None && ClassIsChildOf(OverrideClass, class'CHSpectator'));
/*	CommanderCheck.bChecked = (OverrideClass != None && ClassIsChildOf(OverrideClass, class'Commander'));*/
}

defaultproperties
{
}
