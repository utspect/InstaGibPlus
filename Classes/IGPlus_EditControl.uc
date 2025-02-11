class IGPlus_EditControl extends UWindowEditControl;

var UWindowDialogControl NextSettingControl;

var float EditBoxMinWidth;
var float EditBoxMaxWidth;
var float EditBoxWidthFraction;

function Created() {
	Super.Created();
	
	EditBox = IGPlus_EditBox(CreateWindow(class'IGPlus_EditBox', 0, 0, WinWidth, WinHeight)); 
	EditBox.NotifyOwner = Self;
	EditBox.bSelectOnFocus = True;

	EditBoxWidth = WinWidth / 2;

	SetEditTextColor(LookAndFeel.EditBoxTextColor);
}

function AfterCreate() {
	EditBoxWidthFraction = FClamp(EditBoxWidth / WinWidth, 0.05, 0.95);
	EditBoxMinWidth = WinWidth * EditBoxWidthFraction;
	EditBoxMaxWidth = WinWidth * EditBoxWidthFraction;
}

function SetNumericNegative(bool bEnable) {
	IGPlus_EditBox(EditBox).bNumericNegative = bEnable;
}

function MouseLeave() {
	Super.MouseLeave();
	if(HelpText != "") ToolTip("");
}

function MouseEnter() {
	local int CutPos;
	local int CutPos2;

	Super.MouseEnter();

	if(HelpText != "") {
		CutPos = InStr(HelpText, "\\n");

		CutPos2 = InStr(HelpText, Chr(13));
		if ((CutPos == -1 && CutPos2 >= 0) || (CutPos >= 0 && CutPos2 >= 0 && CutPos2 < CutPos))
			CutPos = CutPos2;

		CutPos2 = InStr(HelpText, Chr(10));
		if ((CutPos == -1 && CutPos2 >= 0) || (CutPos >= 0 && CutPos2 >= 0 && CutPos2 < CutPos))
			CutPos = CutPos2;

		if (CutPos >= 0)
			ToolTip(Left(HelpText, CutPos));
		else
			ToolTip(HelpText);
	}
}

function Resized() {
	super.Resized();

	EditBoxWidth = FClamp(WinWidth * EditBoxWidthFraction, EditBoxMinWidth, EditBoxMaxWidth);
}

function RClick(float X, float Y)
{
	local UWindowMessageBox W;
	if (HelpText == "") return;
	W = MessageBox(Text, HelpText, MB_OK, MR_OK);
	W.bLeaveOnscreen = true;
}

defaultproperties {
	EditBoxMinWidth=0
	EditBoxMaxWidth=65535
	EditBoxWidthFraction=0.5
}
