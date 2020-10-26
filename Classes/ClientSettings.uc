class ClientSettings extends Object
	config(InstaGibPlus)
	perobjectconfig;

struct PIDControllerSettings {
	var() float p;
	var() float i;
	var() float d;
};

var config bool   bForceModels; // if Client wishes models forced to his own. (default false)
var config bool   bTeamInfo;    // if Client wants extra team info.
var config bool   bShootDead;
var config bool   bDoEndShot;   // if Client wants Screenshot at end of match.
var config bool   bAutoDemo;    // if Client wants demo or not.
var config string DemoMask; // The options for creating demo filename.
var config string DemoPath; // The path for creating the demo.
var config string DemoChar; // Character to use instead of illegal ones.
var config int    DesiredSkin;
var config int    DesiredSkinFemale;
var config int    DesiredTeamSkin;
var config int    DesiredTeamSkinFemale;
var config int    HitSound;     // if Client wishes hitsounds (default 2, must be enabled on server)
var config int    TeamHitSound; // if Client wishes team hitsounds (default 3, must be enabled on server)
var config bool   bDisableForceHitSounds;
var config bool   bEnableHitSounds;
var config int    selectedHitSound;
var config string sHitSound[16];
var config int    cShockBeam;
var config float  BeamScale;
var config float  BeamFadeCurve;
var config float  BeamDuration;
var config int    BeamOriginMode;
var config float  DesiredNetUpdateRate;
var config bool   bNoSmoothing;
var config bool   bNoOwnFootsteps;
var config bool   bLogClientMessages;
var config bool   bEnableKillCam;
var config float  FakeCAPInterval; // Send a FakeCAP after no CAP has been sent for this amount of time
var config float  MinDodgeClickTime; // Minimum time between two presses of the same direction for them to count as a dodge
var config bool   bUseOldMouseInput;
var config PIDControllerSettings SmoothVRController;
var config bool   bShowFPS;

struct CrosshairLayerDescr {
	var() config string Texture;
	var() config int    OffsetX, OffsetY;
	var() config float  ScaleX, ScaleY;
	var() config color  Color;
	var() config bool   bSmooth;
	var() config bool   bUse;
};
var config bool bUseCrosshairFactory;
var config CrosshairLayerDescr CrosshairLayers[10];
var CrosshairLayer BottomLayer;
var CrosshairLayer TopLayer;

simulated function AppendLayer(CrosshairLayer L) {
	if (BottomLayer == none) {
		BottomLayer = L;
		TopLayer = L;
	} else {
		TopLayer.Next = L;
		TopLayer = L;
	}
}

simulated function CheckConfig() {
	local int i;
	local string PackageName;
	local CrosshairLayer L;

	PackageName = class'StringUtils'.static.GetPackage();

	for (i = 0; i < arraycount(sHitSound); i += 1)
		if (Left(sHitSound[i], 12) ~= "InstaGibPlus")
			sHitSound[i] = PackageName$Mid(sHitSound[i], InStr(sHitSound[i], "."));

	for (i = 0; i < arraycount(CrosshairLayers); i++) {
		if (CrosshairLayers[i].bUse) {
			L = new(none) class'CrosshairLayer';
			if (CrosshairLayers[i].Texture != "")
				L.Texture = Texture(DynamicLoadObject(CrosshairLayers[i].Texture, class'Texture'));
			L.OffsetX = CrosshairLayers[i].OffsetX;
			L.OffsetY = CrosshairLayers[i].OffsetY;
			L.ScaleX = CrosshairLayers[i].ScaleX;
			L.ScaleY = CrosshairLayers[i].ScaleY;
			L.Color = CrosshairLayers[i].Color;
			L.bSmooth = CrosshairLayers[i].bSmooth;
			AppendLayer(L);
		}
	}

	SaveConfig();
}

simulated function string GetSetting(string Name) {
	return Name$":"@GetPropertyText(Name)$Chr(10);
}

simulated function string DumpHitSounds() {
	local int i;
	local string Result;

	Result = "";
	for (i = 0; i < arraycount(sHitSound); i++)
		if (sHitSound[i] != "")
			Result = Result$"sHitSound["$i$"]:"@sHitSound[i]$Chr(10);

	return Result;
}

simulated function string DumpColor(out Color C) {
	return "(R="$C.R$",G="$C.G$",B="$C.B$",A="$C.A$")";
}

simulated function string DumpCrosshairLayer(out CrosshairLayerDescr L) {
	return "(Texture="$L.Texture$",OffsetX="$L.OffsetX$",OffsetY="$L.OffsetY$",ScaleX="$L.ScaleX$",ScaleY="$L.ScaleY$",Color="$DumpColor(L.Color)$",bSmooth="$L.bSmooth$",bUse="$L.bUse$")";
}

simulated function string DumpCrosshairLayers() {
	local int i;
	local string Result;

	Result = "";
	for (i = 0; i < arraycount(CrosshairLayers); i++)
		if (CrosshairLayers[i].bUse)
			Result = Result$"CrosshairLayers["$i$"]:"@DumpCrosshairLayer(CrosshairLayers[i])$Chr(10);

	return Result;
}

simulated function string DumpSettings() {
	return "IG+ Client Settings:"$Chr(10)$
		GetSetting("bForceModels")$
		GetSetting("bTeamInfo")$
		GetSetting("bShootDead")$
		GetSetting("bDoEndShot")$
		GetSetting("bAutoDemo")$
		GetSetting("DemoMask")$
		GetSetting("DemoPath")$
		GetSetting("DemoChar")$
		GetSetting("DesiredSkin")$
		GetSetting("DesiredSkinFemale")$
		GetSetting("DesiredTeamSkin")$
		GetSetting("DesiredTeamSkinFemale")$
		GetSetting("HitSound")$
		GetSetting("TeamHitSound")$
		GetSetting("bDisableForceHitSounds")$
		GetSetting("bEnableHitSounds")$
		GetSetting("selectedHitSound")$
		DumpHitSounds()$
		GetSetting("cShockBeam")$
		GetSetting("BeamScale")$
		GetSetting("BeamFadeCurve")$
		GetSetting("BeamDuration")$
		GetSetting("BeamOriginMode")$
		GetSetting("DesiredNetUpdateRate")$
		GetSetting("bNoSmoothing")$
		GetSetting("bNoOwnFootsteps")$
		GetSetting("bLogClientMessages")$
		GetSetting("bEnableKillCam")$
		GetSetting("FakeCAPInterval")$
		GetSetting("MinDodgeClickTime")$
		GetSetting("bUseOldMouseInput")$
		GetSetting("SmoothVRController")$
		GetSetting("bShowFPS")$
		GetSetting("bUseCrosshairFactory")$
		DumpCrosshairLayers();
}

defaultproperties
{
	bForceModels=False
	HitSound=2
	TeamHitSound=3
	bDisableForceHitSounds=False
	bTeamInfo=True
	bDoEndShot=False
	bAutoDemo=False
	bShootDead=False
	DemoMask="%l_[%y_%m_%d_%t]_[%c]_%e"
	DemoPath=""
	DemoChar=""
	DesiredSkin=9
	DesiredSkinFemale=0
	DesiredTeamSkin=9
	DesiredTeamSkinFemale=0
	bEnableHitSounds=True
	selectedHitSound=0
	sHitSound(0)="InstaGibPlus6.HitSound"
	sHitSound(1)="UnrealShare.StingerFire"
	cShockBeam=1
	BeamScale=0.45
	BeamFadeCurve=4
	BeamDuration=0.75
	BeamOriginMode=0
	DesiredNetUpdateRate=250.0
	bNoSmoothing=False
	bNoOwnFootsteps=False
	bLogClientMessages=True
	bEnableKillCam=False
	FakeCAPInterval=0.1
	MinDodgeClickTime=0
	bUseOldMouseInput=False
	SmoothVRController=(p=0.09,i=0.05,d=0.00)
	bShowFPS=False;
	bUseCrosshairFactory=False
}