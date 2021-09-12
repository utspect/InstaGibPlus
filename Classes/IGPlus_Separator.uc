class IGPlus_Separator extends UWindowLabelControl;

var UWindowDialogControl NextSettingControl;
var string SeparatorChar;
var float TextWidth;
var float SeparatorWidth;
var float SeparatorSpacing;

function BeforePaint(Canvas C, float X, float Y)
{
	local float H;

	super(UWindowDialogControl).BeforePaint(C, X, Y);

	TextSize(C, Text, TextWidth, H);
	WinHeight = H+1;
	//WinWidth = TextWidth+1;
	TextY = (WinHeight - H) / 2;

	TextSize(C, SeparatorChar, SeparatorWidth, H);

	switch (Align) {
		case TA_Left:
			break;
		case TA_Center:
			TextX = (WinWidth - TextWidth)/2;
			break;
		case TA_Right:
			TextX = WinWidth - TextWidth;
			break;
	}

}

function Paint(Canvas C, float X, float Y)
{
	local float W;
	local float PosX;
	local string SeparatorString;

	super.Paint(C, X, Y);

	class'CanvasUtils'.static.SaveCanvas(C);

	C.DrawColor = TextColor;
	C.Font = Root.Fonts[Font];

	switch (Align) {
		case TA_Left:
			W = WinWidth - TextWidth;
			PosX = TextWidth;
			if (Text != "") {
				W -= SeparatorSpacing;
				PosX += SeparatorSpacing;
			}
			SeparatorString = class'StringUtils'.static.RepeatString(W/SeparatorWidth, SeparatorChar);
			ClipText(C, PosX + (W - Len(SeparatorString)*SeparatorWidth), TextY, SeparatorString);
			break;

		case TA_Center:
			W = TextX;
			if (Text != "") {
				W -= SeparatorSpacing;
			}
			SeparatorString = class'StringUtils'.static.RepeatString(W/SeparatorWidth, SeparatorChar);
			ClipText(C, 0, TextY, SeparatorString);
			ClipText(C, WinWidth - Len(SeparatorString)*SeparatorWidth, TextY, SeparatorString);
			break;

		case TA_Right:
			W = TextX;
			if (Text != "")
				W -= SeparatorSpacing;
			ClipText(C, 0, TextY, class'StringUtils'.static.RepeatString(W/SeparatorWidth, SeparatorChar));
			break;
	}

	class'CanvasUtils'.static.RestoreCanvas(C);
}

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

defaultproperties {
	SeparatorChar="-"
	SeparatorSpacing=5
}