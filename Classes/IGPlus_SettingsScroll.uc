class IGPlus_SettingsScroll extends UWindowScrollingDialogClient;

var UWindowSmallButton Btn_Close;
var UWindowSmallButton Btn_Save;
var localized string SaveButtonText;
var localized string SaveButtonToolTip;

var float FixedPaddingX;
var float FixedPaddingY;

function Created() {
	super.Created();

	Btn_Save = UWindowSmallButton(FixedArea.CreateControl(
		class'UWindowSmallButton',
		FixedArea.WinWidth-FixedPaddingX-72,
		FixedPaddingY,
		32,
		16
	));
	Btn_Save.SetText(SaveButtonText);
	Btn_Save.ToolTipString = SaveButtonToolTip;
	Btn_Save.Register(self);

	Btn_Close = UWindowSmallButton(FixedArea.CreateControl(
		class'UWindowSmallCloseButton',
		FixedArea.WinWidth-FixedPaddingX-32,
		FixedPaddingY,
		32,
		16
	));

	FixedArea.WinHeight = 2*FixedPaddingY + 16;
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	if (E == DE_Click && C == Btn_Save) {
		Save();
		Load();
	}
}

function BeforePaint(Canvas C, float X, float Y) {
	super.BeforePaint(C, X, Y);

	Btn_Close.AutoWidth(C);
	Btn_Close.WinLeft = FixedArea.WinWidth-FixedPaddingX-Btn_Close.WinWidth;

	Btn_Save.AutoWidth(C);
	Btn_Save.WinLeft = FixedArea.WinWidth-FixedPaddingX-Btn_Close.WinWidth-5-Btn_Save.WinWidth;
}

function Load() {
	IGPlus_SettingsContent(ClientArea).Load();
}

function Save() {
	IGPlus_SettingsContent(ClientArea).Save();
}

defaultproperties
{
	ClientClass=class'IGPlus_SettingsContent'
	FixedAreaClass=class'UWindowDialogClientWindow'

	SaveButtonText="Save"
	SaveButtonToolTip="Saves the current settings to InstaGibPlus.ini"

	FixedPaddingX=20
	FixedPaddingY=5
}