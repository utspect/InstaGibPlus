class IGPlus_SettingsDialog extends UWindowFramedWindow;

var float MaxWinWidth;
var float MaxWinHeight;

function Created() {
	super.Created();

	MinWinWidth = default.MinWinWidth;
	MinWinHeight = default.MinWinHeight;
}

function Resized()
{
	WinWidth = FClamp(WinWidth, MinWinWidth, MaxWinWidth);
	WinHeight = FClamp(WinHeight, MinWinHeight, MaxWinHeight);

	super.Resized();
}

function BeforePaint(Canvas C, float X, float Y) {
	super.BeforePaint(C, X, Y);

	if (WaitModal() && ModalWindow.IsA('UWindowMessageBox') && UWindowMessageBox(ModalWindow).bSetupSize == false) {
		ModalWindow.BeforePaint(C, X, Y);
		ModalWindow.WinLeft = FClamp(WinLeft+(WinWidth-ModalWindow.WinWidth)/2, 0, C.SizeX-ModalWindow.WinWidth);
		ModalWindow.WinTop = FClamp(WinTop+(WinHeight-ModalWindow.WinHeight)/2, 0, C.SizeY-ModalWindow.WinHeight);
	}
}

function Load() {
	IGPlus_SettingsScroll(ClientArea).Load();
}

function Close(optional bool bByParent) {
	super.Close(bByParent);

	if (Root.Console.IsInState('UWindow') && Root.Console.bShowConsole == false)
		Root.Console.CloseUWindow();
}

defaultproperties
{
	ClientClass=class'IGPlus_SettingsScroll'
	WindowTitle="IG+ Settings"
	bSizable=True
	bStatusBar=True
	MinWinWidth=240
	MaxWinWidth=99999
	MinWinHeight=400
	MaxWinHeight=99999
}