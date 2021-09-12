class IGPlus_Label extends UWindowLabelControl;

var UWindowDialogControl NextSettingControl;

function MouseLeave()
{
	Super.MouseLeave();
	if(HelpText != "") ToolTip("");
}

function MouseEnter()
{
	Super.MouseEnter();
	if(HelpText != "") ToolTip(HelpText);
}

function RClick(float X, float Y)
{
	local UWindowMessageBox W;
	if (HelpText == "") return;
	W = MessageBox(Text, HelpText, MB_OK, MR_OK);
	W.bLeaveOnscreen = true;
}
