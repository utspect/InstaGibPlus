// ====================================================================
//  Class:  UTPureRC1b.UTPureSetupScrollClient
//  Parent: UTMenu.UTPlayerSetupScrollClient
//
//  <Enter a description here>
// ====================================================================

class UTPureSetupScrollClient extends UTPlayerSetupScrollClient;

function Created()
{
	ClientClass = class'UTPureSetupClient';
	FixedAreaClass = None;

	Super(UWindowScrollingDialogClient).Created();
}

defaultproperties
{
}
