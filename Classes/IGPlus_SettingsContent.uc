class IGPlus_SettingsContent extends UMenuPageWindow;

var ClientSettings Settings;

var UWindowLabelControl Lbl_MoreInformation;
var localized string MoreInformationText;

var UWindowLabelControl Lbl_General;
var localized string GeneralText;

var UWindowCheckbox Chk_ShootDead;
var localized string ShootDeadText;
var localized string ShootDeadHelp;

var UWindowCheckbox Chk_DoEndShot;
var localized string DoEndShotText;
var localized string DoEndShotHelp;

var UWindowCheckbox Chk_UnlitSkins;
var localized string UnlitSkinsText;
var localized string UnlitSkinsHelp;

var UWindowCheckbox Chk_NoOwnFootsteps;
var localized string NoOwnFootstepsText;
var localized string NoOwnFootstepsHelp;

var UWindowCheckbox Chk_ReduceEyeHeightInAir;
var localized string ReduceEyeHeightInAirText;
var localized string ReduceEyeHeightInAirHelp;

var UWindowCheckbox Chk_AllowWeaponShake;
var localized string AllowWeaponShakeText;
var localized string AllowWeaponShakeHelp;

var UWindowCheckbox Chk_AutoReady;
var localized string AutoReadyText;
var localized string AutoReadyHelp;

var UWindowCheckbox Chk_ShowDeathReport;
var localized string ShowDeathReportText;
var localized string ShowDeathReportHelp;

var UWindowCheckbox Chk_SmoothFOVChanges;
var localized string SmoothFOVChangesText;
var localized string SmoothFOVChangesHelp;

var UWindowCheckbox Chk_NoSmoothing;
var localized string NoSmoothingText;
var localized string NoSmoothingHelp;

var UWindowCheckbox Chk_UseOldMouseInput;
var localized string UseOldMouseInputText;
var localized string UseOldMouseInputHelp;

var IGPlus_EditControl Edit_MinDodgeClickTime;
var localized string MinDodgeClickTimeText;
var localized string MinDodgeClickTimeHelp;

var IGPlus_EditControl Edit_DesiredNetUpdateRate;
var localized string DesiredNetUpdateRateText;
var localized string DesiredNetUpdateRateHelp;

var IGPlus_EditControl Edit_DesiredNetspeed;
var localized string DesiredNetspeedText;
var localized string DesiredNetspeedHelp;

var IGPlus_EditControl Edit_FakeCAPInterval;
var localized string FakeCAPIntervalText;
var localized string FakeCAPIntervalHelp;

var UWindowLabelControl Lbl_AutoDemo;
var localized string AutoDemoLblText;

var UWindowCheckbox Chk_AutoDemo;
var localized string AutoDemoText;
var localized string AutoDemoHelp;

var IGPlus_EditControl Edit_DemoMask;
var localized string DemoMaskText;
var localized string DemoMaskHelp;

var IGPlus_EditControl Edit_DemoPath;
var localized string DemoPathText;
var localized string DemoPathHelp;

var IGPlus_EditControl Edit_DemoChar;
var localized string DemoCharText;
var localized string DemoCharHelp;

var UWindowLabelControl Lbl_ForceModels;
var localized string ForceModelsLblText;

var UWindowCheckbox Chk_ForceModels;
var localized string ForceModelsText;
var localized string ForceModelsHelp;

var IGPlus_ComboBox Cmb_DesiredSkin;
var localized string DesiredSkinText;
var localized string DesiredSkinHelp;

var IGPlus_ComboBox Cmb_DesiredSkinFemale;
var localized string DesiredSkinFemaleText;
var localized string DesiredSkinFemaleHelp;

var IGPlus_ComboBox Cmb_DesiredTeamSkin;
var localized string DesiredTeamSkinText;
var localized string DesiredTeamSkinHelp;

var IGPlus_ComboBox Cmb_DesiredTeamSkinFemale;
var localized string DesiredTeamSkinFemaleText;
var localized string DesiredTeamSkinFemaleHelp;

var localized string ForcedModelDefault;
var localized string ForcedModelAphex;
var localized string ForcedModelFemaleCommando;
var localized string ForcedModelFemaleMercenary;
var localized string ForcedModelFemaleNecris;
var localized string ForcedModelFemaleMarine;
var localized string ForcedModelFemaleMetalGuard;
var localized string ForcedModelFemaleSoldier;
var localized string ForcedModelVenom;
var localized string ForcedModelFemaleWarMachine;
var localized string ForcedModelMaleCommando;
var localized string ForcedModelMaleMercenary;
var localized string ForcedModelMaleNecris;
var localized string ForcedModelMaleMarine;
var localized string ForcedModelMaleMetalGuard;
var localized string ForcedModelRawSteel;
var localized string ForcedModelMaleSoldier;
var localized string ForcedModelMaleWarMachine;
var localized string ForcedModelXan;

var UWindowLabelControl Lbl_SuperShockRifle;
var localized string SuperShockRifleText;

var IGPlus_ComboBox Cmb_cShockBeam;
var localized string cShockBeamText;
var localized string cShockBeamHelp;

var localized string cShockBeamDefault;
var localized string cShockBeamTeamColored;
var localized string cShockBeamHidden;
var localized string cShockBeamInstant;

var UWindowCheckbox Chk_HideOwnBeam;
var localized string HideOwnBeamText;
var localized string HideOwnBeamHelp;

var IGPlus_EditControl Edit_BeamScale;
var localized string BeamScaleText;
var localized string BeamScaleHelp;

var IGPlus_EditControl Edit_BeamFadeCurve;
var localized string BeamFadeCurveText;
var localized string BeamFadeCurveHelp;

var IGPlus_EditControl Edit_BeamDuration;
var localized string BeamDurationText;
var localized string BeamDurationHelp;

var IGPlus_ComboBox Cmb_BeamOriginMode;
var localized string BeamOriginModeText;
var localized string BeamOriginModeHelp;

var IGPlus_ComboBox Cmb_BeamDestinationMode;
var localized string BeamDestinationModeText;
var localized string BeamDestinationModeHelp;

var localized string BeamModePrecise;
var localized string BeamModeAttached;

var IGPlus_ComboBox Cmb_SSRRingType;
var localized string SSRRingTypeText;
var localized string SSRRingTypeHelp;

var localized string SSRRingTypeNone;
var localized string SSRRingTypeDefault;
var localized string SSRRingTypeTeamColored;

var UWindowLabelControl Lbl_FPS;
var localized string FPSLblText;

var UWindowHSliderControl HSld_FPSDetail;
var localized string FPSDetailText;
var localized string FPSDetailHelp;

var localized string FPSDetailDisabled;
var localized string FPSDetailFPSOnly;
var localized string FPSDetailRenTime;
var localized string FPSDetailStdDev;
var localized string FPSDetailMinMax;

var IGPlus_EditControl Edit_FPSCounterSmoothingStrength;
var localized string FPSCounterSmoothingStrengthText;
var localized string FPSCounterSmoothingStrengthHelp;

var IGPlus_ScreenLocationControl SLoc_FPSLocation;
var localized string FPSLocationText;
var localized string FPSLocationHelp;

var UWindowLabelControl Lbl_HitSounds;
var localized string HitSoundsLblText;

var IGPlus_ComboBox Cmb_HitSoundSource;
var localized string HitSoundSourceText;
var localized string HitSoundSourceHelp;

var localized string HitSourceServer;
var localized string HitSourceClient;

var UWindowLabelControl Lbl_EnemyHitSounds;
var localized string EnemyHitSoundsLblText;

var UWindowCheckbox Chk_EnableHitSounds;
var localized string EnableHitSoundsText;
var localized string EnableHitSoundsHelp;

var UWindowCheckbox Chk_HitSoundPitchShift;
var localized string HitSoundPitchShiftText;
var localized string HitSoundPitchShiftHelp;

var IGPlus_EditControl Edit_HitSoundVolume;
var localized string HitSoundVolumeText;
var localized string HitSoundVolumeHelp;

var IGPlus_ComboBox Cmb_SelectedHitSound;
var localized string SelectedHitSoundText;
var localized string SelectedHitSoundHelp;

var UWindowLabelControl Lbl_TeamHitSounds;
var localized string TeamHitSoundsLblText;

var UWindowCheckbox Chk_EnableTeamHitSounds;
var localized string EnableTeamHitSoundsText;
var localized string EnableTeamHitSoundsHelp;

var UWindowCheckbox Chk_HitSoundTeamPitchShift;
var localized string HitSoundTeamPitchShiftText;
var localized string HitSoundTeamPitchShiftHelp;

var IGPlus_EditControl Edit_HitSoundTeamVolume;
var localized string HitSoundTeamVolumeText;
var localized string HitSoundTeamVolumeHelp;

var IGPlus_ComboBox Cmb_SelectedTeamHitSound;
var localized string SelectedTeamHitSoundText;
var localized string SelectedTeamHitSoundHelp;

var UWindowLabelControl Lbl_KillCam;
var localized string KillCamLblText;

var UWindowCheckbox Chk_EnableKillCam;
var localized string EnableKillCamText;
var localized string EnableKillCamHelp;

var IGPlus_EditControl Edit_KillCamMinDelay;
var localized string KillCamMinDelayText;
var localized string KillCamMinDelayHelp;

var float PaddingX;
var float PaddingY;
var float LineSpacing;
var float SeparatorSpacing;
var float ControlOffset;
var bool bLoadSucceeded;

var UWindowDialogControl SettingControls;
var UWindowDialogControl TemporaryControl;

enum EEditControlType {
	ECT_Text,
	ECT_Integer,
	ECT_Real
};

function ClientSettings FindSettingsObject() {
	local bbPlayer P;
	local bbCHSpectator S;

	if (GetPlayerOwner().IsA('bbPlayer') && bbPlayer(GetPlayerOwner()).Settings != none)
		return bbPlayer(GetPlayerOwner()).Settings;

	if (GetPlayerOwner().IsA('bbCHSpectator') && bbCHSpectator(GetPlayerOwner()).Settings != none)
		return bbCHSpectator(GetPlayerOwner()).Settings;

	foreach GetPlayerOwner().AllActors(class'bbPlayer', P)
		if (P.Settings != none)
			return P.Settings;

	foreach GetPlayerOwner().AllActors(class'bbCHSpectator', S)
		if (S.Settings != none)
			return S.Settings;

	return none;
}

function InsertControl(UWindowDialogControl C) {
	if (SettingControls != none)
		C.SetPropertyText("NextSettingControl", string(SettingControls));
	SettingControls = C;
}

function UWindowDialogControl NextControl(UWindowDialogControl C) {
	if (C == none)
		return none;

	SetPropertyText("TemporaryControl", C.GetPropertyText("NextSettingControl"));
	return TemporaryControl;
}

function UWindowCheckbox CreateCheckbox(string T, optional string HT) {
	local UWindowCheckbox Chk;

	Chk = UWindowCheckbox(CreateControl(class'IGPlus_Checkbox', PaddingX, ControlOffset, 200, 1));
	Chk.SetText(T);
	Chk.SetHelpText(HT);
	Chk.ToolTipString = HT;
	Chk.SetFont(F_Normal);
	Chk.Align = TA_Left;
	ControlOffset += LineSpacing;

	InsertControl(Chk);

	return Chk;
}

function IGPlus_EditControl CreateEditResizable(
	EEditControlType ECT,
	string T,
	float EditBoxWidthFraction,
	float EditBoxMinWidth,
	float EditBoxMaxWidth,
	optional string HT,
	optional int MaxLength // 255 is default
) {
	local IGPlus_EditControl Edit;

	Edit = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', PaddingX, ControlOffset, 200, 1));
	Edit.SetText(T);
	Edit.SetHelpText(HT);
	Edit.SetFont(F_Normal);
	Edit.Align = TA_Left;
	if (MaxLength > 0)
		Edit.SetMaxLength(MaxLength);

	Edit.EditBoxWidthFraction = EditBoxWidthFraction;
	Edit.EditBoxMinWidth = EditBoxMinWidth;
	Edit.EditBoxMaxWidth = EditBoxMaxWidth;
	ControlOffset += LineSpacing;

	switch(ECT) {
		case ECT_Text:
			Edit.SetNumericOnly(false);
			Edit.SetNumericOnly(false);
			break;
		case ECT_Integer:
			Edit.SetNumericOnly(true);
			Edit.SetNumericOnly(false);
			break;
		case ECT_Real:
			Edit.SetNumericOnly(true);
			Edit.SetNumericFloat(true);
			break;
	}

	InsertControl(Edit);

	return Edit;
}

function IGPlus_EditControl CreateEdit(
	EEditControlType ECT,
	string T,
	optional string HT,
	optional int MaxLength, // 255 is default
	optional float EditBoxWidth // 100 is default
) {
	if (EditBoxWidth <= 0)
		return CreateEditResizable(ECT, T, 0.5, 0, MaxInt, HT, MaxLength);

	return CreateEditResizable(ECT, T, 0.5, EditBoxWidth, EditBoxWidth, HT, MaxLength);
}

function UWindowLabelControl CreateLabel(string T, optional string HT) {
	local UWindowLabelControl Lbl;

	Lbl = UWindowLabelControl(CreateControl(class'IGPlus_Label', PaddingX, ControlOffset, 200, 1));
	Lbl.SetText(T);
	Lbl.SetHelpText(HT);
	Lbl.SetFont(F_Normal);
	Lbl.Align = TA_Left;
	ControlOffset += LineSpacing;

	InsertControl(Lbl);

	return Lbl;
}

function UWindowLabelControl CreateSeparator(string T, optional string HT) {
	local UWindowLabelControl Lbl;

	if (ControlOffset > PaddingY)
		ControlOffset += (SeparatorSpacing - LineSpacing);

	Lbl = UWindowLabelControl(CreateControl(class'IGPlus_Separator', PaddingX, ControlOffset, 200, 1));
	Lbl.SetText(T);
	Lbl.SetHelpText(HT);
	Lbl.SetFont(F_Normal);
	Lbl.Align = TA_Left;
	ControlOffset += LineSpacing;

	InsertControl(Lbl);

	return Lbl;
}

function IGPlus_ComboBox CreateComboBoxResizable(
	string T,
	float EditBoxWidthFraction,
	float EditBoxMinWidth,
	float EditBoxMaxWidth,
	optional string HT,
	optional bool bCanEdit
) {
	local IGPlus_ComboBox Cmb;

	EditBoxWidthFraction = FClamp(EditBoxWidthFraction, 0.0, 1.0);

	Cmb = IGPlus_ComboBox(CreateControl(class'IGPlus_ComboBox', PaddingX, ControlOffset, 200, 1));
	Cmb.SetText(T);
	Cmb.SetHelpText(HT);
	Cmb.SetFont(F_Normal);
	Cmb.Align = TA_Left;
	Cmb.SetEditable(bCanEdit);
	Cmb.EditBoxMinWidth = EditBoxMinWidth;
	Cmb.EditBoxMaxWidth = EditBoxMaxWidth;
	Cmb.EditBoxWidthFraction = EditBoxWidthFraction;
	ControlOffset += LineSpacing;

	InsertControl(Cmb);

	return Cmb;
}

function IGPlus_ComboBox CreateComboBox(
	string T,
	optional string HT,
	optional bool bCanEdit,
	optional float EditBoxWidth
) {
	if (EditBoxWidth <= 0)
		return CreateComboBoxResizable(T, 0.5, 0, MaxInt, HT, bCanEdit);

	return CreateComboBoxResizable(T, 0.5, EditBoxWidth, EditBoxWidth, HT, bCanEdit);
}

function UWindowHSliderControl CreateSlider(
	float Min,
	float Max,
	int Step,
	string T,
	optional string HT,
	optional float SliderWidth
) {
	local UWindowHSliderControl HSld;

	HSld = UWindowHSliderControl(CreateControl(class'IGPlus_HSlider', PaddingX, ControlOffset, 200, 1));
	HSld.SetText(T);
	HSld.SetHelpText(HT);
	HSld.SetFont(F_Normal);
	HSld.Align = TA_Left;
	HSld.SetRange(Min, Max, Step);
	HSld.SliderWidth = SliderWidth;
	ControlOffset += LineSpacing;

	InsertControl(HSld);

	return HSld;
}

function IGPlus_ScreenLocationControl CreateScreenLocation(
	float Height,
	string T,
	optional string HT
) {
	local IGPlus_ScreenLocationControl SLoc;

	SLoc = IGPlus_ScreenLocationControl(CreateControl(class'IGPlus_ScreenLocationControl', PaddingX, ControlOffset, 200, Height));
	SLoc.SetText(T);
	SLoc.SetHelpText(HT);
	SLoc.Align = TA_Left;
	ControlOffset += Height+4;

	InsertControl(Sloc);

	return Sloc;
}

function SetUpForcedModelComboBox(IGPlus_ComboBox Cmb) {
	Cmb.AddItem(ForcedModelDefault);
	Cmb.AddItem(ForcedModelAphex);
	Cmb.AddItem(ForcedModelFemaleCommando);
	Cmb.AddItem(ForcedModelFemaleMercenary);
	Cmb.AddItem(ForcedModelFemaleNecris);
	Cmb.AddItem(ForcedModelFemaleMarine);
	Cmb.AddItem(ForcedModelFemaleMetalGuard);
	Cmb.AddItem(ForcedModelFemaleSoldier);
	Cmb.AddItem(ForcedModelVenom);
	Cmb.AddItem(ForcedModelFemaleWarMachine);
	Cmb.AddItem(ForcedModelMaleCommando);
	Cmb.AddItem(ForcedModelMaleMercenary);
	Cmb.AddItem(ForcedModelMaleNecris);
	Cmb.AddItem(ForcedModelMaleMarine);
	Cmb.AddItem(ForcedModelMaleMetalGuard);
	Cmb.AddItem(ForcedModelRawSteel);
	Cmb.AddItem(ForcedModelMaleSoldier);
	Cmb.AddItem(ForcedModelMaleWarMachine);
	Cmb.AddItem(ForcedModelXan);
}

function SetUpBeamModeComboBox(IGPlus_ComboBox Cmb) {
	Cmb.AddItem(BeamModePrecise);
	Cmb.AddItem(BeamModeAttached);
}

function SetUpHitSoundComboBox(IGPlus_ComboBox Cmb) {
	local int i;

	Cmb.EditBox.bDelayedNotify = true;
	Cmb.Clear();
	for (i = 0; i < arraycount(Settings.sHitSound); ++i)
		Cmb.AddItem(Settings.sHitSound[i], string(i));
}

function SetUpHitSourceComboBox(IGPlus_ComboBox Cmb) {
	Cmb.AddItem(HitSourceServer);
	Cmb.AddItem(HitSourceClient);
}

function UpdateFPSSlider() {
	local string Text;
	switch(HSld_FPSDetail.GetValue()) {
		case -1:
			Text = FPSDetailDisabled;
			break;
		case 0:
			Text = FPSDetailFPSOnly;
			break;
		case 1:
			Text = FPSDetailRenTime;
			break;
		case 2:
			Text = FPSDetailStdDev;
			break;
		case 3:
			Text = FPSDetailMinMax;
			break;
	}
	HSld_FPSDetail.SetText(FPSDetailText$":"@Text);
}

function UpdateHitSoundComboBox(UWindowComboControl C) {
	local string Value;
	local int Index;
	local UWindowComboListItem Item;
	local UWindowDialogClientWindow NotifyWindow;

	Value = C.GetValue();
	Index = int(C.GetValue2());

	Item = Cmb_SelectedHitSound.FindEntry(Index);
	if (Item != none) {
		Item.Value = Value;
	}

	Item = Cmb_SelectedTeamHitSound.FindEntry(Index);
	if (Item != none) {
		Item.Value = Value;
	}

	if (C == Cmb_SelectedHitSound) {
		if (Cmb_SelectedTeamHitSound.GetValue2() == C.GetValue2()) {
			NotifyWindow = Cmb_SelectedTeamHitSound.NotifyWindow;
			Cmb_SelectedTeamHitSound.NotifyWindow = none;
			Cmb_SelectedTeamHitSound.SetValue(C.GetValue(), C.GetValue2());
			Cmb_SelectedTeamHitSound.NotifyWindow = NotifyWindow;
		}
	} else if (C == Cmb_SelectedTeamHitSound) {
		if (Cmb_SelectedHitSound.GetValue2() == C.GetValue2()) {
			NotifyWindow = Cmb_SelectedHitSound.NotifyWindow;
			Cmb_SelectedHitSound.NotifyWindow = none;
			Cmb_SelectedHitSound.SetValue(C.GetValue(), C.GetValue2());
			Cmb_SelectedHitSound.NotifyWindow = NotifyWindow;
		}
	}
}

function SaveHitSounds() {
	local int i;
	local UWindowComboListItem Item;

	Item = UWindowComboListItem(Cmb_SelectedHitSound.List.Items.Next);
	while (i < arraycount(Settings.sHitSound) && Item != None) {
		Settings.sHitSound[i++] = Item.Value;
		Item = UWindowComboListItem(Item.Next);
	}
}

function Created() {
	local float ControlWidth;

	super.Created();

	ControlOffset = PaddingY;
	ControlWidth = WinWidth - 2*PaddingX;

	Lbl_MoreInformation = CreateLabel(MoreInformationText);
	Lbl_MoreInformation.Align = TA_Center;
	Lbl_MoreInformation.SetFont(F_Bold);

	Lbl_General = CreateSeparator(GeneralText);
	Chk_ShootDead = CreateCheckbox(ShootDeadText, ShootDeadHelp);
	Chk_DoEndShot = CreateCheckbox(DoEndShotText, DoEndShotHelp);
	Chk_UnlitSkins = CreateCheckbox(UnlitSkinsText, UnlitSkinsHelp);
	Chk_NoOwnFootsteps = CreateCheckbox(NoOwnFootstepsText, NoOwnFootstepsHelp);
	Chk_ReduceEyeHeightInAir = CreateCheckbox(ReduceEyeHeightInAirText, ReduceEyeHeightInAirHelp);
	Chk_AllowWeaponShake = CreateCheckbox(AllowWeaponShakeText, AllowWeaponShakeHelp);
	Chk_AutoReady = CreateCheckbox(AutoReadyText, AutoReadyHelp);
	Chk_ShowDeathReport = CreateCheckbox(ShowDeathReportText, ShowDeathReportHelp);
	Chk_SmoothFOVChanges = CreateCheckbox(SmoothFOVChangesText, SmoothFOVChangesHelp);
	Chk_NoSmoothing = CreateCheckbox(NoSmoothingText, NoSmoothingHelp);
	Chk_UseOldMouseInput = CreateCheckbox(UseOldMouseInputText, UseOldMouseInputHelp);
	Edit_MinDodgeClickTime = CreateEdit(ECT_Real, MinDodgeClickTimeText, MinDodgeClickTimeHelp, , 64);
	Edit_DesiredNetUpdateRate = CreateEdit(ECT_Integer, DesiredNetUpdateRateText, DesiredNetUpdateRateHelp, 4, 32);
	Edit_DesiredNetspeed = CreateEdit(ECT_Integer, DesiredNetspeedText, DesiredNetspeedHelp, , 64);
	Edit_FakeCAPInterval = CreateEdit(ECT_Real, FakeCAPIntervalText, FakeCAPIntervalHelp, , 64);

	Lbl_AutoDemo = CreateSeparator(AutoDemoLblText);
	Chk_AutoDemo = CreateCheckbox(AutoDemoText, AutoDemoHelp);
	Edit_DemoMask = CreateEditResizable(ECT_Text, DemoMaskText, 0.7, 100, MaxInt, DemoMaskHelp);
	Edit_DemoPath = CreateEditResizable(ECT_Text, DemoPathText, 0.7, 100, MaxInt, DemoPathHelp);
	Edit_DemoChar = CreateEdit(ECT_Text, DemoCharText, DemoCharHelp, 1, 14);

	Lbl_ForceModels = CreateSeparator(ForceModelsLblText);
	Chk_ForceModels = CreateCheckbox(ForceModelsText, ForceModelsHelp);
	Cmb_DesiredSkin = CreateComboBox(DesiredSkinText, DesiredSkinHelp, false, 150);
	Cmb_DesiredSkinFemale = CreateComboBox(DesiredSkinFemaleText, DesiredSkinFemaleHelp, false, 150);
	Cmb_DesiredTeamSkin = CreateComboBox(DesiredTeamSkinText, DesiredTeamSkinHelp, false, 150);
	Cmb_DesiredTeamSkinFemale = CreateComboBox(DesiredTeamSkinFemaleText, DesiredTeamSkinFemaleHelp, false, 150);
	SetUpForcedModelComboBox(Cmb_DesiredSkin);
	SetUpForcedModelComboBox(Cmb_DesiredSkinFemale);
	SetUpForcedModelComboBox(Cmb_DesiredTeamSkin);
	SetUpForcedModelComboBox(Cmb_DesiredTeamSkinFemale);

	Lbl_SuperShockRifle = CreateSeparator(SuperShockRifleText);
	Cmb_cShockBeam = CreateComboBox(cShockBeamText, cShockBeamHelp, false, 150);
	Cmb_cShockBeam.AddItem(cShockBeamDefault);
	Cmb_cShockBeam.AddItem(cShockBeamTeamColored);
	Cmb_cShockBeam.AddItem(cShockBeamHidden);
	Cmb_cShockBeam.AddItem(cShockBeamInstant);
	Chk_HideOwnBeam = CreateCheckbox(HideOwnBeamText, HideOwnBeamHelp);
	Edit_BeamScale = CreateEdit(ECT_Real, BeamScaleText, BeamScaleHelp, , 64);
	Edit_BeamFadeCurve = CreateEdit(ECT_Integer, BeamFadeCurveText, BeamFadeCurveHelp, , 64);
	Edit_BeamDuration = CreateEdit(ECT_Real, BeamDurationText, BeamDurationHelp, , 64);
	Cmb_BeamOriginMode = CreateComboBox(BeamOriginModeText, BeamOriginModeHelp, false, 150);
	Cmb_BeamDestinationMode = CreateComboBox(BeamDestinationModeText, BeamDestinationModeHelp, false, 150);
	SetUpBeamModeComboBox(Cmb_BeamOriginMode);
	SetUpBeamModeComboBox(Cmb_BeamDestinationMode);
	Cmb_SSRRingType = CreateComboBox(SSRRingTypeText, SSRRingTypeHelp, false, 150);
	Cmb_SSRRingType.AddItem(SSRRingTypeNone);
	Cmb_SSRRingType.AddItem(SSRRingTypeDefault);
	Cmb_SSRRingType.AddItem(SSRRingTypeTeamColored);

	Lbl_FPS = CreateSeparator(FPSLblText);
	HSld_FPSDetail = CreateSlider(-1, 3, 1, FPSDetailText, FPSDetailHelp, 150);
	Edit_FPSCounterSmoothingStrength = CreateEdit(ECT_Integer, FPSCounterSmoothingStrengthText, FPSCounterSmoothingStrengthHelp, , 64);
	SLoc_FPSLocation = CreateScreenLocation(100, FPSLocationText, FPSLocationHelp);

	Lbl_HitSounds = CreateSeparator(HitSoundsLblText);
	Cmb_HitSoundSource = CreateComboBox(HitSoundSourceText, HitSoundSourceHelp, false, 150);
	SetUpHitSourceComboBox(Cmb_HitSoundSource);

	Lbl_EnemyHitSounds = CreateSeparator(EnemyHitSoundsLblText);
	Chk_EnableHitSounds = CreateCheckbox(EnableHitSoundsText, EnableHitSoundsHelp);
	Chk_HitSoundPitchShift = CreateCheckbox(HitSoundPitchShiftText, HitSoundPitchShiftHelp);
	Edit_HitSoundVolume = CreateEdit(ECT_Real, HitSoundVolumeText, HitSoundVolumeHelp, , 64);
	Cmb_SelectedHitSound = CreateComboBox(SelectedHitSoundText, SelectedHitSoundHelp, true, 150);

	Lbl_TeamHitSounds = CreateSeparator(TeamHitSoundsLblText);
	Chk_EnableTeamHitSounds = CreateCheckbox(EnableTeamHitSoundsText, EnableTeamHitSoundsHelp);
	Chk_HitSoundTeamPitchShift = CreateCheckbox(HitSoundTeamPitchShiftText, HitSoundTeamPitchShiftHelp);
	Edit_HitSoundTeamVolume = CreateEdit(ECT_Real, HitSoundTeamVolumeText, HitSoundTeamVolumeHelp, , 64);
	Cmb_SelectedTeamHitSound = CreateComboBox(SelectedTeamHitSoundText, SelectedTeamHitSoundHelp, true, 150);

	Lbl_KillCam = CreateSeparator(KillCamLblText);
	Chk_EnableKillCam = CreateCheckbox(EnableKillCamText, EnableKillCamHelp);
	Edit_KillCamMinDelay = CreateEdit(ECT_Real, KillCamMinDelayText, KillCamMinDelayHelp, , 64);

	ControlOffset += PaddingY-4;

	Load();
}

function AfterCreate() {
	super.AfterCreate();

	DesiredWidth = 180;
	DesiredHeight = ControlOffset;
}

function BeforePaint(Canvas C, float X, float Y) {
	local float WndWidth;
	local UWindowDialogControl DC;

	super.BeforePaint(C, X, Y);

	WndWidth = WinWidth - 2*PaddingX;

	for (DC = SettingControls; DC != none; DC = NextControl(DC)) {
		switch(DC.Class.Name) {
			case 'IGPlus_Checkbox': DC.SetSize(WndWidth, 1); break;
			default:
				DC.SetSize(WndWidth, DC.WinHeight);
				break;
		}
	}
}

function Notify(UWindowDialogControl C, byte E) {
	super.Notify(C, E);

	if (E == DE_Change && C == HSld_FPSDetail)
		UpdateFPSSlider();

	if (E == DE_Change && (C == Cmb_SelectedHitSound || C == Cmb_SelectedTeamHitSound))
		UpdateHitSoundComboBox(UWindowComboControl(C));
}

function Load() {
	if (Settings == none)
		Settings = FindSettingsObject();
	if (Settings == none)
		return;

	Chk_ShootDead.bChecked = Settings.bShootDead;
	Chk_DoEndShot.bChecked = Settings.bDoEndShot;
	Chk_UnlitSkins.bChecked = Settings.bUnlitSkins;
	Chk_NoOwnFootsteps.bChecked = Settings.bNoOwnFootsteps;
	Chk_ReduceEyeHeightInAir.bChecked = Settings.bReduceEyeHeightInAir;
	Chk_AllowWeaponShake.bChecked = Settings.bAllowWeaponShake;
	Chk_AutoReady.bChecked = Settings.bAutoReady;
	Chk_ShowDeathReport.bChecked = Settings.bShowDeathReport;
	Chk_SmoothFOVChanges.bChecked = Settings.bSmoothFOVChanges;
	Chk_NoSmoothing.bChecked = Settings.bNoSmoothing;
	Chk_UseOldMouseInput.bChecked = Settings.bUseOldMouseInput;
	Edit_MinDodgeClickTime.SetValue(string(Settings.MinDodgeClickTime));
	Edit_DesiredNetUpdateRate.SetValue(string(int(Settings.DesiredNetUpdateRate)));
	Edit_DesiredNetspeed.SetValue(string(Settings.DesiredNetspeed));
	Edit_FakeCAPInterval.SetValue(string(Settings.FakeCAPInterval));

	Chk_AutoDemo.bChecked = Settings.bAutoDemo;
	Edit_DemoMask.SetValue(Settings.DemoMask);
	Edit_DemoPath.SetValue(Settings.DemoPath);
	Edit_DemoChar.SetValue(Settings.DemoChar);

	Chk_ForceModels.bChecked = Settings.bForceModels;
	Cmb_DesiredSkin.SetSelectedIndex(Clamp(Settings.DesiredSkin + 1, 0, 18));
	Cmb_DesiredSkinFemale.SetSelectedIndex(Clamp(Settings.DesiredSkinFemale + 1, 0, 18));
	Cmb_DesiredTeamSkin.SetSelectedIndex(Clamp(Settings.DesiredTeamSkin + 1, 0, 18));
	Cmb_DesiredTeamSkinFemale.SetSelectedIndex(Clamp(Settings.DesiredTeamSkinFemale + 1, 0, 18));

	Cmb_cShockBeam.SetSelectedIndex(Clamp(Settings.cShockBeam - 1, 0, 3));
	Chk_HideOwnBeam.bChecked = Settings.bHideOwnBeam;
	Edit_BeamScale.SetValue(string(Settings.BeamScale));
	Edit_BeamFadeCurve.SetValue(string(int(Settings.BeamFadeCurve)));
	Edit_BeamDuration.SetValue(string(Settings.BeamDuration));
	Cmb_BeamOriginMode.SetSelectedIndex(Clamp(Settings.BeamOriginMode, 0, 1));
	Cmb_BeamDestinationMode.SetSelectedIndex(Clamp(Settings.BeamDestinationMode, 0, 1));
	Cmb_SSRRingType.SetSelectedIndex(Clamp(Settings.SSRRingType, 0, 2));

	if (Settings.bShowFPS)
		HSld_FPSDetail.SetValue(Settings.FPSDetail);
	else
		HSld_FPSDetail.SetValue(-1);
	UpdateFPSSlider();
	Edit_FPSCounterSmoothingStrength.SetValue(string(Settings.FPSCounterSmoothingStrength));
	SLoc_FPSLocation.SetLocation(Settings.FPSLocationX, Settings.FPSLocationY);

	Cmb_HitSoundSource.SetSelectedIndex(Clamp(Settings.HitSoundSource, 0, 1));

	Chk_EnableHitSounds.bChecked = Settings.bEnableHitSounds;
	Chk_HitSoundPitchShift.bChecked = Settings.bHitSoundPitchShift;
	Edit_HitSoundVolume.SetValue(string(Settings.HitSoundVolume));
	SetUpHitSoundComboBox(Cmb_SelectedHitSound);
	Cmb_SelectedHitSound.SetSelectedIndex(Settings.SelectedHitSound);

	Chk_EnableTeamHitSounds.bChecked = Settings.bEnableTeamHitSounds;
	Chk_HitSoundTeamPitchShift.bChecked = Settings.bHitSoundTeamPitchShift;
	Edit_HitSoundTeamVolume.SetValue(string(Settings.HitSoundTeamVolume));
	SetUpHitSoundComboBox(Cmb_SelectedTeamHitSound);
	Cmb_SelectedTeamHitSound.SetSelectedIndex(Settings.SelectedTeamHitSound);

	Chk_EnableKillCam.bChecked = Settings.bEnableKillCam;
	Edit_KillCamMinDelay.SetValue(string(Settings.KillCamMinDelay));

	bLoadSucceeded = true;
}

function Save() {
	if (Settings == none)
		Settings = FindSettingsObject();
	if (Settings == none)
		return;

	if (bLoadSucceeded == false)
		return;

	Settings.bShootDead = Chk_ShootDead.bChecked;
	Settings.bDoEndShot = Chk_DoEndShot.bChecked;
	Settings.bUnlitSkins = Chk_UnlitSkins.bChecked;
	Settings.bNoOwnFootsteps = Chk_NoOwnFootsteps.bChecked;
	Settings.bReduceEyeHeightInAir = Chk_ReduceEyeHeightInAir.bChecked;
	Settings.bAllowWeaponShake = Chk_AllowWeaponShake.bChecked;
	Settings.bAutoReady = Chk_AutoReady.bChecked;
	Settings.bShowDeathReport = Chk_ShowDeathReport.bChecked;
	Settings.bSmoothFOVChanges = Chk_SmoothFOVChanges.bChecked;
	Settings.bNoSmoothing = Chk_NoSmoothing.bChecked;
	Settings.bUseOldMouseInput = Chk_UseOldMouseInput.bChecked;
	Settings.MinDodgeClickTime = float(Edit_MinDodgeClickTime.GetValue());
	Settings.DesiredNetUpdateRate = int(Edit_DesiredNetUpdateRate.GetValue());
	Settings.DesiredNetspeed = int(Edit_DesiredNetspeed.GetValue());
	Settings.FakeCAPInterval = float(Edit_FakeCAPInterval.GetValue());

	Settings.bAutoDemo = Chk_AutoDemo.bChecked;
	Settings.DemoMask = Edit_DemoMask.GetValue();
	Settings.DemoPath = Edit_DemoPath.GetValue();
	Settings.DemoChar = Edit_DemoChar.GetValue();

	Settings.bForceModels = Chk_ForceModels.bChecked;
	Settings.DesiredSkin = Cmb_DesiredSkin.GetSelectedIndex() - 1;
	Settings.DesiredSkinFemale = Cmb_DesiredSkinFemale.GetSelectedIndex() - 1;
	Settings.DesiredTeamSkin = Cmb_DesiredTeamSkin.GetSelectedIndex() - 1;
	Settings.DesiredTeamSkinFemale = Cmb_DesiredTeamSkinFemale.GetSelectedIndex() - 1;

	Settings.cShockBeam = Cmb_cShockBeam.GetSelectedIndex() + 1;
	Settings.bHideOwnBeam = Chk_HideOwnBeam.bChecked;
	Settings.BeamScale = float(Edit_BeamScale.GetValue());
	Settings.BeamFadeCurve = int(Edit_BeamFadeCurve.GetValue());
	Settings.BeamDuration = float(Edit_BeamDuration.GetValue());
	Settings.BeamOriginMode = Cmb_BeamOriginMode.GetSelectedIndex();
	Settings.BeamDestinationMode = Cmb_BeamDestinationMode.GetSelectedIndex();
	Settings.SSRRingType = Cmb_SSRRingType.GetSelectedIndex();

	if (HSld_FPSDetail.GetValue() == -1)
		Settings.bShowFPS = false;
	else {
		Settings.bShowFPS = true;
		Settings.FPSDetail = HSld_FPSDetail.GetValue();
	}
	Settings.FPSCounterSmoothingStrength = Max(int(Edit_FPSCounterSmoothingStrength.GetValue()), 1);
	SLoc_FPSLocation.GetLocation(Settings.FPSLocationX, Settings.FPSLocationY);

	Settings.HitSoundSource = Settings.IntToHitSoundSource(Cmb_HitSoundSource.GetSelectedIndex());

	Settings.bEnableHitSounds = Chk_EnableHitSounds.bChecked;
	Settings.bHitSoundPitchShift = Chk_HitSoundPitchShift.bChecked;
	Settings.HitSoundVolume = FMax(float(Edit_HitSoundVolume.GetValue()), 1);
	Settings.SelectedHitSound = Cmb_SelectedHitSound.GetSelectedIndex2();

	Settings.bEnableTeamHitSounds = Chk_EnableTeamHitSounds.bChecked;
	Settings.bHitSoundTeamPitchShift = Chk_HitSoundTeamPitchShift.bChecked;
	Settings.HitSoundTeamVolume = FMax(float(Edit_HitSoundTeamVolume.GetValue()), 1);
	Settings.SelectedTeamHitSound = Cmb_SelectedTeamHitSound.GetSelectedIndex2();

	SaveHitSounds();

	Settings.bEnableKillCam = Chk_EnableKillCam.bChecked;
	Settings.KillCamMinDelay = Max(float(Edit_KillCamMinDelay.GetValue()), 1);

	Settings.SaveConfig();
}

function SaveConfigs() {
	local UWindowWindow Dialog;

	super.SaveConfigs();

	Dialog = GetParent(class'UWindowFramedWindow');

	Settings.MenuX = Dialog.WinLeft;
	Settings.MenuY = Dialog.WinTop;
	Settings.MenuWidth = Dialog.WinWidth;
	Settings.MenuHeight = Dialog.WinHeight;

	Settings.SaveConfig();
}

defaultproperties
{
	MoreInformationText="Right-click on settings to get more information"

	GeneralText="General"

	ShootDeadText="Enable Shooting Corpses"
	ShootDeadHelp="If checked, corpses can be hit by your lag-compensated shots"

	DoEndShotText="Take Screenshot After Match"
	DoEndShotHelp="If checked, automatically takes a screenshot after the end of a match"

	UnlitSkinsText="Show Player Skins Unlit"
	UnlitSkinsHelp="If checked and allowed by server, skins of players will not be affected by lighting"

	NoOwnFootstepsText="Disable Own Footsteps"
	NoOwnFootstepsHelp="If checked, dont play sounds for your own footsteps"

	ReduceEyeHeightInAirText="Reduce EyeHeight In Air"
	ReduceEyeHeightInAirHelp="If checked, EyeHeight is reduced while player is in the air"

	AllowWeaponShakeText="Allow Weapon Shake"
	AllowWeaponShakeHelp="If checked, weapons can shake the camera when fired"

	AutoReadyText="Auto Ready"
	AutoReadyHelp="If checked, automatically ready up with the first spawn during warmup"

	ShowDeathReportText="Show Death Report"
	ShowDeathReportHelp="If checked, prints a report of damage taken and its source since when you last healed"

	SmoothFOVChangesText="Smooth FOV Changes"
	SmoothFOVChangesHelp="If checked, changes to your FOV are smoothed"

	NoSmoothingText="Disable Mouse Smoothing"
	NoSmoothingHelp="If checked, mouse movement is not smoothed at all"

	UseOldMouseInputText="Use Old Mouse Input"
	UseOldMouseInputHelp="If checked, mouse input is rounded like in v436, otherwise use v469-style mouse input"

	MinDodgeClickTimeText="Min Dodge Click Time"
	MinDodgeClickTimeHelp="Minimum time in seconds between two taps to count as dodge"

	DesiredNetUpdateRateText="Desired Net Update Rate"
	DesiredNetUpdateRateHelp="How often your client wants to send a position update to the server per second"

	DesiredNetspeedText="Desired Netspeed"
	DesiredNetspeedHelp="IG+ will try keeping your netspeed at this value, if the server allows"

	FakeCAPIntervalText="Fake CAP Interval"
	FakeCAPIntervalHelp="Server will acknowledge your movement every this many seconds"

	AutoDemoLblText="Auto Demo"

	AutoDemoText="Enable AutoDemo"
	AutoDemoHelp="If checked, automatically starts recording a demo when the match starts"

	DemoMaskText="Demo Name Mask"
	DemoMaskHelp="Mask for the name of automatically recorded demos; MUST NOT contain spaces\\n%E --> Name of the map file\\n%F --> Title of the map\\n%D --> Day (two digits)\\n%M --> Month (two digits)\\n%Y --> Year\\n%H --> Hour\\n%N --> Minute\\n%T --> Combined Hour and Minute (two digits each)\\n%C --> Clan Tags (detected by determining common prefix of all players on a team, or 'Unknown')\\n%L --> Name of the recording player\\n%% --> Replaced with a single %"

	DemoPathText="Demo Path"
	DemoPathHelp="Path to store automatically recorded demos in; MUST NOT contain spaces"

	DemoCharText="Demo Char"
	DemoCharHelp="Replacement character for those that cannot be used in file-names"

	ForceModelsLblText="Forced Skins"

	ForceModelsText="Enable Forcing Skins"
	ForceModelsHelp="If checked, enables forcing of skins of other players"

	DesiredSkinText="Skin - Male Enemies"
	DesiredSkinHelp="Which skin to use for enemies that use a male skin"

	DesiredSkinFemaleText="Skin - Female Enemies"
	DesiredSkinFemaleHelp="Which skin to use for enemies that use a female skin"

	DesiredTeamSkinText="Skin - Male Friendlies"
	DesiredTeamSkinHelp="Which skin to use for team-mates that use a male skin"

	DesiredTeamSkinFemaleText="Skin - Female Friendlies"
	DesiredTeamSkinFemaleHelp="Which skin to use for team-mates that use a female skin"

	ForcedModelDefault="Do Not Force"
	ForcedModelAphex="Aphex"
	ForcedModelFemaleCommando="Female Commando"
	ForcedModelFemaleMercenary="Female Mercenary"
	ForcedModelFemaleNecris="Female Necris"
	ForcedModelFemaleMarine="Female Marine"
	ForcedModelFemaleMetalGuard="Female Metal Guard"
	ForcedModelFemaleSoldier="Female Soldier"
	ForcedModelVenom="Venom"
	ForcedModelFemaleWarMachine="Female War Machine"
	ForcedModelMaleCommando="Male Commando"
	ForcedModelMaleMercenary="Male Mercenary"
	ForcedModelMaleNecris="Male Necris"
	ForcedModelMaleMarine="Male Marine"
	ForcedModelMaleMetalGuard="Male Metal Guard"
	ForcedModelRawSteel="RawSteel"
	ForcedModelMaleSoldier="Male Soldier"
	ForcedModelMaleWarMachine="Male War Machine"
	ForcedModelXan="Xan"

	SuperShockRifleText="IG+ Super Shock Rifle";

	cShockBeamText="Beam Style"
	cShockBeamHelp="How to render the beams fired by the IG+ SSR"

	cShockBeamDefault="Default"
	cShockBeamTeamColored="Team Colored"
	cShockBeamHidden="Hidden"
	cShockBeamInstant="Instant"

	HideOwnBeamText="Always Hide Own Beams"
	HideOwnBeamHelp="If checked, your own beams will always be hidden"

	BeamScaleText="Beam Scale"
	BeamScaleHelp="Diameter of the beam of the IG+ SSR"

	BeamFadeCurveText="Beam Fade Curve"
	BeamFadeCurveHelp="Brightness fade curve, 1=linear, 2=quadratic, 3=cubic, etc."

	BeamDurationText="Beam Duration"
	BeamDurationHelp="Time in seconds over which the brightness fades"

	BeamOriginModeText="Beam Origin Mode"
	BeamOriginModeHelp="Decides where SSR beams will be shown to originate from"

	BeamDestinationModeText="Beam Destination Mode"
	BeamDestinationModeHelp="Decides where SSR beams will be shown to end at"

	BeamModePrecise="Precise"
	BeamModeAttached="Attached"

	SSRRingTypeText="Impact Effect"
	SSRRingTypeHelp="Decides what effects to play where SSR shots end"

	SSRRingTypeNone="Nothing"
	SSRRingTypeDefault="Default"
	SSRRingTypeTeamColored="Team-Colored"

	FPSLblText="FPS Display"

	FPSDetailText="FPS Detail"
	FPSDetailHelp="How much detail to show for frame rate; this setting is cumulative"

	FPSDetailDisabled="Disabled"
	FPSDetailFPSOnly="FPS"
	FPSDetailRenTime="Render Time"
	FPSDetailStdDev="Std. Dev."
	FPSDetailMinMax="Min/Max"

	FPSCounterSmoothingStrengthText="FPS Smoothing Strength"
	FPSCounterSmoothingStrengthHelp="Higher values mean individual frames influence the stats less"

	FPSLocationText="FPS Location"
	FPSLocationHelp="Where on screen to show the framerate information"

	HitSoundsLblText="Hit Sounds"

	HitSoundSourceText="Hit Source"
	HitSoundSourceHelp="Controls where hit notifications originate from\\nServer --> No notifications for hits that werent, but delayed by ping\\nClient --> Instant notifications, but may not be accurate"

	HitSourceServer="Server"
	HitSourceClient="Client"

	EnemyHitSoundsLblText="Enemy Hit Sounds"

	EnableHitSoundsText="Enable"
	EnableHitSoundsHelp="If checked, play a sound whenever you deal damage to enemies"

	HitSoundPitchShiftText="Pitch Shift"
	HitSoundPitchShiftHelp="If checked, shift the pitch of hit sounds depending on damage"

	HitSoundVolumeText="Volume"
	HitSoundVolumeHelp="Loudness of Hit Sound"

	SelectedHitSoundText="Sound"
	SelectedHitSoundHelp="Which sound to play when you damage enemies"

	TeamHitSoundsLblText="Team Hit Sounds"

	EnableTeamHitSoundsText="Enable"
	EnableTeamHitSoundsHelp="If checked, play a sound whenever you deal damage to team-mates"

	HitSoundTeamPitchShiftText="Pitch Shift"
	HitSoundTeamPitchShiftHelp="If checked, shift the pitch of hit sounds depending on damage"

	HitSoundTeamVolumeText="Volume"
	HitSoundTeamVolumeHelp="Loudness of Hit Sound"

	SelectedTeamHitSoundText="Sound"
	SelectedTeamHitSoundHelp="Which sound to play when you damage team-mates"

	KillCamLblText="Death Camera"

	EnableKillCamText="Enable Death Cam"
	EnableKillCamHelp="If checked, camera follows killer after your death"

	KillCamMinDelayText="Minimum Delay"
	KillCamMinDelayHelp="Minimum delay in seconds before camera starts following killer"

	PaddingX=20
	PaddingY=20
	LineSpacing=20
	SeparatorSpacing=32
}