class IGPlus_ScreenLocationControl extends UWindowDialogControl;

var UWindowDialogControl NextSettingControl;

var Region ActiveRegion;

var float LocationX; // [0..1]
var float LocationY; // [0..1]

var float TextMargin;
var float TextWidth;
var float TextHeight;

function SetLocation(float X, float Y) {
	LocationX = FClamp(X, 0, 1);
	LocationY = FClamp(Y, 0, 1);
}

function GetLocation(out float X, out float Y) {
	X = LocationX;
	Y = LocationY;
}

function float GetLocationX() {
	return LocationX;
}

function float GetLocationY() {
	return LocationY;
}

function BeforePaint(Canvas C, float X, float Y) {
	local float ScreenAspectRatio;
	local float WindowAspectRatio;
	local float FreeWidth;

	super.BeforePaint(C, X, Y);

	TextSize(C, Text, TextWidth, TextHeight);
	TextWidth += TextMargin;
	FreeWidth = (WinWidth-TextWidth);
	ScreenAspectRatio = float(C.SizeX) / float(C.SizeY);
	WindowAspectRatio = FreeWidth / WinHeight;

	switch(Align) {
		case TA_Left:
			if (WindowAspectRatio < ScreenAspectRatio) {
				ActiveRegion.W = FreeWidth;
				ActiveRegion.H = FreeWidth / ScreenAspectRatio;
				ActiveRegion.X = TextWidth;
				ActiveRegion.Y = (WinHeight - ActiveRegion.H) / 2;
			} else {
				ActiveRegion.W = WinHeight * ScreenAspectRatio;
				ActiveRegion.H = WinHeight;
				ActiveRegion.X = (WinWidth - ActiveRegion.W);
				ActiveRegion.Y = 0.0;
			}
			TextX = 0.0;
			TextY = ActiveRegion.Y;
			break;

		case TA_Center:
			if (WindowAspectRatio < ScreenAspectRatio) {
				ActiveRegion.W = FreeWidth;
				ActiveRegion.H = FreeWidth / ScreenAspectRatio;
				ActiveRegion.X = WinWidth - TextWidth + TextMargin;
				ActiveRegion.Y = (WinHeight - ActiveRegion.H) / 2;
			} else {
				ActiveRegion.W = WinHeight * ScreenAspectRatio;
				ActiveRegion.H = WinHeight;
				ActiveRegion.X = (FreeWidth - ActiveRegion.W) / 2;
				ActiveRegion.Y = 0.0;
			}

			TextX = ActiveRegion.X + ActiveRegion.W + TextMargin;
			TextY = ActiveRegion.Y;
			break;

		case TA_Right:
			ActiveRegion.X = 0.0;

			if (WindowAspectRatio < ScreenAspectRatio) {
				ActiveRegion.W = FreeWidth;
				ActiveRegion.H = FreeWidth / ScreenAspectRatio;
				ActiveRegion.Y = (WinHeight - ActiveRegion.H) / 2;
			} else {
				ActiveRegion.Y = 0.0;
				ActiveRegion.W = WinHeight * ScreenAspectRatio;
				ActiveRegion.H = WinHeight;
			}
			TextX = WinWidth-TextWidth+TextMargin;
			TextY = ActiveRegion.Y;
			break;
	}
}

function Paint(Canvas C, float X, float Y) {
	local string TempText;
	class'CanvasUtils'.static.SaveCanvas(C);

	C.Style = 1; // STY_Normal

	C.DrawColor = TextColor;
	switch(Align) {
		case TA_Left:
		case TA_Center:
			ClipText(C, TextX, TextY, Text);
			ClipText(C, TextX, TextY+TextHeight+TextMargin, "X:"@LocationX);
			ClipText(C, TextX, TextY+2*(TextHeight+TextMargin), "Y:"@LocationY);
			break;

		case TA_Right:
			ClipText(C, TextX, TextY, Text);

			TempText = "X:"@LocationX;
			TextSize(C, TempText, TextWidth, TextHeight);
			ClipText(C, WinWidth-TextWidth, TextY+TextHeight+TextMargin, TempText);

			TempText = "Y:"@LocationY;
			TextSize(C, TempText, TextWidth, TextHeight);
			ClipText(C, WinWidth-TextWidth, TextY+2*(TextHeight+TextMargin), TempText);
			break;

	}

	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;
	DrawStretchedTexture(C, ActiveRegion.X, ActiveRegion.Y, ActiveRegion.W, ActiveRegion.H, Texture'CrossHairBase');

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	DrawStretchedTexture(
		C,
		ActiveRegion.X+LocationX*(ActiveRegion.W-2),
		ActiveRegion.Y+LocationY*(ActiveRegion.H-2),
		2,
		2,
		Texture'CrossHairBase'
	);

	class'CanvasUtils'.static.RestoreCanvas(C);
}

function UpdateLocation(float X, float Y) {
	if (bMouseDown == false) {
		return;
	}

	LocationX = FMin(FClamp(X-ActiveRegion.X, 0, ActiveRegion.W) / (ActiveRegion.W-1), 1.0);
	LocationY = FMin(FClamp(Y-ActiveRegion.Y, 0, ActiveRegion.H) / (ActiveRegion.H-1), 1.0);

	Notify(DE_Change);
}

function LMouseDown(float X, float Y) {
	super.LMouseDown(X, Y);
	Root.CaptureMouse(Self);
	UpdateLocation(X, Y);
}

function MouseMove(float X, float Y) {
	UpdateLocation(X, Y);
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

defaultproperties {
	TextMargin=4
}
