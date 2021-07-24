class IGPlus_HSlider extends UWindowHSliderControl;

var UWindowDialogControl NextSettingControl;

function float CheckValue(float Test) {
	local float TempF;
	local float NewValue;

	NewValue = Test;

	if(Step != 0)
	{
		TempF = NewValue / Step;
		if (TempF >= 0)
			NewValue = Int(TempF + 0.5) * Step;
		else
			NewValue = Int(TempF - 0.5) * Step;
	}

	if(NewValue < MinValue) NewValue = MinValue;
	if(NewValue > MaxValue) NewValue = MaxValue;

	return NewValue;
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

function RClick(float X, float Y)
{
	local UWindowMessageBox W;
	if (HelpText == "") return;
	W = MessageBox(Text, HelpText, MB_OK, MR_OK);
	W.bLeaveOnscreen = true;
}
