class IGPlus_SettingsScroll extends UWindowScrollingDialogClient;

function Load() {
	IGPlus_SettingsContent(ClientArea).Load();
}

defaultproperties
{
	ClientClass=class'IGPlus_SettingsContent'
	FixedAreaClass=None
}