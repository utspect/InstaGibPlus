class IGPlus_CrosshairSettingsContent extends UMenuPageWindow;

var IGPlus_CrosshairSettingsDialog ParentDialog;
var ClientSettings Settings;
var bool bUpdatingControls;

var IGPlus_Button Btn_AddLayer;
var IGPlus_Button Btn_RemLayer;

var IGPlus_CrosshairLayersListBox LB_Layers;
var UWindowList LastSelected;

var IGPlus_Label Lbl_Scale;
var localized string ScaleText;
var IGPlus_BtnUp Btn_ScaleUp;
var IGPlus_BtnDown Btn_ScaleDown;
var IGPlus_BtnLeft Btn_ScaleLeft;
var IGPlus_BtnRight Btn_ScaleRight;

var IGPlus_Label Lbl_Offset;
var localized string OffsetText;
var IGPlus_BtnUp Btn_OffsetUp;
var IGPlus_BtnDown Btn_OffsetDown;
var IGPlus_BtnLeft Btn_OffsetLeft;
var IGPlus_BtnRight Btn_OffsetRight;

var IGPlus_EditControl Edit_Texture;
var localized string TextureText;

var IGPlus_EditControl Edit_OffsetX;
var localized string OffsetXText;
var IGPlus_EditControl Edit_OffsetY;
var localized string OffsetYText;

var IGPlus_EditControl Edit_ScaleX;
var localized string ScaleXText;
var IGPlus_EditControl Edit_ScaleY;
var localized string ScaleYText;

var IGPlus_EditControl Edit_ColorRed;
var localized string ColorRedText;
var IGPlus_EditControl Edit_ColorGreen;
var localized string ColorGreenText;
var IGPlus_EditControl Edit_ColorBlue;
var localized string ColorBlueText;
var IGPlus_EditControl Edit_ColorAlpha;
var localized string ColorAlphaText;

var IGPlus_ComboBox Cmb_Style;
var localized string StyleText;
var localized string StyleNormal;
var localized string StyleMasked;
var localized string StyleTranslucent;
var localized string StyleModulated;

var IGPlus_Checkbox Chk_Smooth;
var localized string SmoothText;

var UWindowSmallCloseButton Btn_Close;
var UwindowSmallButton Btn_Save;

function CopyCrosshairLayers() {
	local bbPlayer P;
	local bbCHSpectator Spec;
	local int i;
	local IGPlus_CrosshairLayersListItem Item;

	P = bbPlayer(GetPlayerOwner());
	if (P == none) {
		Spec = bbCHSpectator(GetPlayerOwner());
		if (Spec == none)
			return;
		Settings = Spec.Settings;
	} else {
		Settings = P.Settings;
	}
	if (Settings == none)
		return;

	for (i = 0; i < 10; ++i) {
		if (Settings.GetCrosshairLayer(i).bUse == false)
			continue;

		Item = IGPlus_CrosshairLayersListItem(LB_Layers.Items.CreateItem(LB_Layers.ListClass));
		if (Item == none)
			continue;

		Item.Index   = i;
		Item.Texture = Settings.GetCrosshairLayer(i).Texture;
		Item.ScaleX  = Settings.GetCrosshairLayer(i).ScaleX;
		Item.ScaleY  = Settings.GetCrosshairLayer(i).ScaleY;
		Item.OffsetX = Settings.GetCrosshairLayer(i).OffsetX;
		Item.OffsetY = Settings.GetCrosshairLayer(i).OffsetY;
		Item.Color   = Settings.GetCrosshairLayer(i).Color;
		Item.Style   = Settings.GetCrosshairLayer(i).Style;
		Item.bSmooth = Settings.GetCrosshairLayer(i).bSmooth;

		if (Item.Style == 0)
			Item.Style = 1;

		LB_Layers.Items.AppendItem(Item);
	}
}

function Save() {
	local int i;
	local IGPlus_CrosshairLayersListItem L;
	local color White;

	White.R = 255;
	White.G = 255;
	White.B = 255;
	White.A = 255;

	i = 0;
	for (L = IGPlus_CrosshairLayersListItem(LB_Layers.Items.Next); L != none && i < 10; L = IGPlus_CrosshairLayersListItem(L.Next)) {
		Settings.SetCrosshairLayerUse(i, true);

		Settings.SetCrosshairLayerTexture(i, L.Texture);
		Settings.SetCrosshairLayerOffsetX(i, L.OffsetX);
		Settings.SetCrosshairLayerOffsetY(i, L.OffsetY);
		Settings.SetCrosshairLayerScaleX(i, L.ScaleX);
		Settings.SetCrosshairLayerScaleY(i, L.ScaleY);
		Settings.SetCrosshairLayerColor(i, L.Color);
		Settings.SetCrosshairLayerStyle(i, L.Style);
		Settings.SetCrosshairLayerSmooth(i, L.bSmooth);

		i++;
	}

	while(i < 10) {
		Settings.SetCrosshairLayerUse(i, false);

		Settings.SetCrosshairLayerTexture(i, "");
		Settings.SetCrosshairLayerOffsetX(i, 0);
		Settings.SetCrosshairLayerOffsetY(i, 0);
		Settings.SetCrosshairLayerScaleX(i, 1);
		Settings.SetCrosshairLayerScaleY(i, 1);
		Settings.SetCrosshairLayerColor(i, White);
		Settings.SetCrosshairLayerStyle(i, 0);
		Settings.SetCrosshairLayerSmooth(i, false);

		i++;
	}

	Settings.BottomLayer = none;
	Settings.TopLayer = none;
	Settings.CreateCrosshairLayers();
}

function Load() {
	LB_Layers.Items.Clear();
	CopyCrosshairLayers();
}

function Created() {
	super.Created();

	ParentDialog = IGPlus_CrosshairSettingsDialog(ParentWindow);

	LB_Layers = IGPlus_CrosshairLayersListBox(CreateControl(class'IGPlus_CrosshairLayersListBox', 10, 30, 256, 150));

	Btn_AddLayer = IGPlus_Button(CreateControl(class'IGPlus_Button', 10, 10, 16, 16));
	Btn_AddLayer.SetText("+");
	Btn_RemLayer = IGPlus_Button(CreateControl(class'IGPlus_Button', 30, 10, 16, 16));
	Btn_RemLayer.SetText("-");

	Lbl_Scale = IGPlus_Label(CreateControl(class'IGPlus_Label', 276, 10, 64, 16));
	Lbl_Scale.SetText(ScaleText);
	Lbl_Scale.SetHelpText("");
	Lbl_Scale.SetFont(F_Normal);
	Lbl_Scale.Align = TA_Center;

	Btn_ScaleUp = IGPlus_BtnUp(CreateControl(class'IGPlus_BtnUp', 302, 30, 12, 10));
	Btn_ScaleDown = IGPlus_BtnDown(CreateControl(class'IGPlus_BtnDown', 302, 60, 12, 10));
	Btn_ScaleLeft = IGPlus_BtnLeft(CreateControl(class'IGPlus_BtnLeft', 288, 44, 10, 12));
	Btn_ScaleRight = IGPlus_BtnRight(CreateControl(class'IGPlus_BtnRight', 318, 44, 10, 12));

	Lbl_Offset = IGPlus_Label(CreateControl(class'IGPlus_Label', 344, 10, 64, 16));
	Lbl_Offset.SetText(OffsetText);
	Lbl_Offset.SetHelpText("");
	Lbl_Offset.SetFont(F_Normal);
	Lbl_Offset.Align = TA_Center;

	Btn_OffsetUp = IGPlus_BtnUp(CreateControl(class'IGPlus_BtnUp', 370, 30, 12, 10));
	Btn_OffsetDown = IGPlus_BtnDown(CreateControl(class'IGPlus_BtnDown', 370, 60, 12, 10));
	Btn_OffsetLeft = IGPlus_BtnLeft(CreateControl(class'IGPlus_BtnLeft', 356, 44, 10, 12));
	Btn_OffsetRight = IGPlus_BtnRight(CreateControl(class'IGPlus_BtnRight', 386, 44, 10, 12));

	Edit_Texture = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 80, 150, 16));
	Edit_Texture.SetText(TextureText);
	Edit_Texture.SetFont(F_Normal);
	Edit_Texture.Align = TA_Left;
	Edit_Texture.SetHistory(true);
	Edit_Texture.SetDelayedNotify(true);
	Edit_Texture.SetNumericOnly(false);
	Edit_Texture.SetNumericFloat(false);
	Edit_Texture.EditBoxWidthFraction = (2.0/3.0);
	Edit_Texture.EditBoxWidth = 100;

	Edit_OffsetX = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 100, 150, 16));
	Edit_OffsetX.SetText(OffsetXText);
	Edit_OffsetX.SetFont(F_Normal);
	Edit_OffsetX.Align = TA_Left;
	Edit_OffsetX.SetHistory(true);
	Edit_OffsetX.SetDelayedNotify(true);
	Edit_OffsetX.SetNumericOnly(true);
	Edit_OffsetX.SetNumericFloat(false);
	Edit_OffsetX.SetNumericNegative(true);
	Edit_OffsetX.EditBoxWidthFraction = (1.0/3.0);
	Edit_OffsetX.EditBoxWidth = 50;

	Edit_OffsetY = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 120, 150, 16));
	Edit_OffsetY.SetText(OffsetYText);
	Edit_OffsetY.SetFont(F_Normal);
	Edit_OffsetY.Align = TA_Left;
	Edit_OffsetY.SetHistory(true);
	Edit_OffsetY.SetDelayedNotify(true);
	Edit_OffsetY.SetNumericOnly(true);
	Edit_OffsetY.SetNumericFloat(false);
	Edit_OffsetY.SetNumericNegative(true);
	Edit_OffsetY.EditBoxWidthFraction = (1.0/3.0);
	Edit_OffsetY.EditBoxWidth = 50;

	Edit_ScaleX = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 140, 150, 16));
	Edit_ScaleX.SetText(ScaleXText);
	Edit_ScaleX.SetFont(F_Normal);
	Edit_ScaleX.Align = TA_Left;
	Edit_ScaleX.SetHistory(true);
	Edit_ScaleX.SetDelayedNotify(true);
	Edit_ScaleX.SetNumericOnly(true);
	Edit_ScaleX.SetNumericFloat(true);
	Edit_ScaleX.EditBoxWidthFraction = (1.0/3.0);
	Edit_ScaleX.EditBoxWidth = 50;

	Edit_ScaleY = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 160, 150, 16));
	Edit_ScaleY.SetText(ScaleYText);
	Edit_ScaleY.SetFont(F_Normal);
	Edit_ScaleY.Align = TA_Left;
	Edit_ScaleY.SetHistory(true);
	Edit_ScaleY.SetDelayedNotify(true);
	Edit_ScaleY.SetNumericOnly(true);
	Edit_ScaleY.SetNumericFloat(true);
	Edit_ScaleY.EditBoxWidthFraction = (1.0/3.0);
	Edit_ScaleY.EditBoxWidth = 50;

	Edit_ColorRed = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 180, 150, 16));
	Edit_ColorRed.SetText(ColorRedText);
	Edit_ColorRed.SetFont(F_Normal);
	Edit_ColorRed.Align = TA_Left;
	Edit_ColorRed.SetHistory(true);
	Edit_ColorRed.SetDelayedNotify(true);
	Edit_ColorRed.SetNumericOnly(true);
	Edit_ColorRed.SetNumericFloat(false);
	Edit_ColorRed.EditBoxWidthFraction = (1.0/6.0);
	Edit_ColorRed.EditBoxWidth = 25;

	Edit_ColorGreen = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 200, 150, 16));
	Edit_ColorGreen.SetText(ColorGreenText);
	Edit_ColorGreen.SetFont(F_Normal);
	Edit_ColorGreen.Align = TA_Left;
	Edit_ColorGreen.SetHistory(true);
	Edit_ColorGreen.SetDelayedNotify(true);
	Edit_ColorGreen.SetNumericOnly(true);
	Edit_ColorGreen.SetNumericFloat(false);
	Edit_ColorGreen.EditBoxWidthFraction = (1.0/6.0);
	Edit_ColorGreen.EditBoxWidth = 25;

	Edit_ColorBlue = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 220, 150, 16));
	Edit_ColorBlue.SetText(ColorBlueText);
	Edit_ColorBlue.SetFont(F_Normal);
	Edit_ColorBlue.Align = TA_Left;
	Edit_ColorBlue.SetHistory(true);
	Edit_ColorBlue.SetDelayedNotify(true);
	Edit_ColorBlue.SetNumericOnly(true);
	Edit_ColorBlue.SetNumericFloat(false);
	Edit_ColorBlue.EditBoxWidthFraction = (1.0/6.0);
	Edit_ColorBlue.EditBoxWidth = 25;

	Edit_ColorAlpha = IGPlus_EditControl(CreateControl(class'IGPlus_EditControl', 276, 240, 150, 16));
	Edit_ColorAlpha.SetText(ColorAlphaText);
	Edit_ColorAlpha.SetFont(F_Normal);
	Edit_ColorAlpha.Align = TA_Left;
	Edit_ColorAlpha.SetHistory(true);
	Edit_ColorAlpha.SetDelayedNotify(true);
	Edit_ColorAlpha.SetNumericOnly(true);
	Edit_ColorAlpha.SetNumericFloat(false);
	Edit_ColorAlpha.EditBoxWidthFraction = (1.0/6.0);
	Edit_ColorAlpha.EditBoxWidth = 25;

	Cmb_Style = IGPlus_ComboBox(CreateControl(class'IGPlus_ComboBox', 276, 260, 150, 16));
	Cmb_Style.SetText(StyleText);
	Cmb_Style.SetFont(F_Normal);
	Cmb_Style.Align = TA_Left;
	Cmb_Style.SetEditable(false);
	Cmb_Style.EditBoxWidthFraction = (2.0/3.0);
	Cmb_Style.EditBoxWidth = 100;
	Cmb_Style.AddItem(StyleNormal, "1");
	Cmb_Style.AddItem(StyleMasked, "2");
	Cmb_Style.AddItem(StyleTranslucent, "3");
	Cmb_Style.AddItem(StyleModulated, "4");

	Chk_Smooth = IGPlus_Checkbox(CreateControl(class'IGPlus_Checkbox', 276, 280, 150, 16));
	Chk_Smooth.SetText(SmoothText);
	Chk_Smooth.SetFont(F_Normal);
	Chk_Smooth.Align = TA_Left;

	Btn_Close = UWindowSmallCloseButton(CreateControl(class'UWindowSmallCloseButton', 394, 430, 32, 16));
	Btn_Save = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 358, 430, 32, 16));
	Btn_Save.SetText(class'IGPlus_SettingsScroll'.default.SaveButtonText);
}

function int FindHighestIndex() {
	local int i;
	local IGPlus_CrosshairLayersListItem Item;

	i = -1;
	for (Item = IGPlus_CrosshairLayersListItem(LB_Layers.Items.Next); Item != none; Item = IGPlus_CrosshairLayersListItem(Item.Next))
		i = Max(i, Item.Index);

	return i;
}

function AddLayer() {
	local IGPlus_CrosshairLayersListItem Item;

	Item = IGPlus_CrosshairLayersListItem(LB_Layers.Items.CreateItem(LB_Layers.ListClass));
	if (Item == none)
		return;

	Item.Index   = FindHighestIndex()+1;
	Item.Texture = "";
	Item.ScaleX  = 1;
	Item.ScaleY  = 1;
	Item.OffsetX = 0;
	Item.OffsetY = 0;
	Item.Color.R = 255;
	Item.Color.G = 255;
	Item.Color.B = 255;
	Item.Color.A = 255;
	Item.Style   = 1;
	Item.bSmooth = false;

	LB_Layers.Items.AppendItem(Item);
}

function RemLayer() {
	LB_Layers.SelectedItem.Remove();
	LB_Layers.SelectedItem = none;
}

function FillControlsFor(IGPlus_CrosshairLayersListItem L) {
	if (L == none) {
		Edit_Texture.Clear();

		Edit_OffsetX.Clear();
		Edit_OffsetY.Clear();
		Edit_ScaleX.Clear();
		Edit_ScaleY.Clear();

		Edit_ColorRed.Clear();
		Edit_ColorGreen.Clear();
		Edit_ColorBlue.Clear();
		Edit_ColorAlpha.Clear();

		Cmb_Style.ClearValue();
	} else {
		Edit_Texture.SetValue(L.Texture);

		Edit_OffsetX.SetValue(string(L.OffsetX));
		Edit_OffsetY.SetValue(string(L.OffsetY));
		Edit_ScaleX.SetValue(string(L.ScaleX));
		Edit_ScaleY.SetValue(string(L.ScaleY));

		Edit_ColorRed.SetValue(string(L.Color.R));
		Edit_ColorGreen.SetValue(string(L.Color.G));
		Edit_ColorBlue.SetValue(string(L.Color.B));
		Edit_ColorAlpha.SetValue(string(L.Color.A));

		Cmb_Style.SetSelectedIndex(L.Style - 1);
		Chk_Smooth.bChecked = L.bSmooth;
	}
}

function Notify(UWindowDialogControl C, byte E) {
	if (bUpdatingControls)
		return;

	if (E == DE_Click) {
		if (C == Btn_AddLayer && Btn_AddLayer.bDisabled == false) {
			AddLayer();
		} else if (C == Btn_RemLayer && Btn_RemLayer.bDisabled == false) {
			RemLayer();
		} else if (C == Btn_ScaleUp && Btn_ScaleUp.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleY += 1;
			bUpdatingControls = true;
			Edit_ScaleY.SetValue(string(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleY));
			bUpdatingControls = false;
		} else if (C == Btn_ScaleDown && Btn_ScaleDown.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleY -= 1;
			bUpdatingControls = true;
			Edit_ScaleY.SetValue(string(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleY));
			bUpdatingControls = false;
		} else if (C == Btn_ScaleLeft && Btn_ScaleLeft.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleX -= 1;
			bUpdatingControls = true;
			Edit_ScaleX.SetValue(string(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleX));
			bUpdatingControls = false;
		} else if (C == Btn_ScaleRight && Btn_ScaleRight.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleX += 1;
			bUpdatingControls = true;
			Edit_ScaleX.SetValue(string(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleX));
			bUpdatingControls = false;
		} else if (C == Btn_OffsetUp && Btn_OffsetUp.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetY -= 1;
			bUpdatingControls = true;
			Edit_OffsetY.SetValue(string(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetY));
			bUpdatingControls = false;
		} else if (C == Btn_OffsetDown && Btn_OffsetDown.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetY += 1;
			bUpdatingControls = true;
			Edit_OffsetY.SetValue(string(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetY));
			bUpdatingControls = false;
		} else if (C == Btn_OffsetLeft && Btn_OffsetLeft.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetX -= 1;
			bUpdatingControls = true;
			Edit_OffsetX.SetValue(string(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetX));
			bUpdatingControls = false;
		} else if (C == Btn_OffsetRight && Btn_OffsetRight.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetX += 1;
			bUpdatingControls = true;
			Edit_OffsetX.SetValue(string(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetX));
			bUpdatingControls = false;
		} else if (C == LB_Layers && LastSelected != LB_Layers.SelectedItem) {
			bUpdatingControls = true;
			FillControlsFor(IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem));
			LastSelected = LB_Layers.SelectedItem;
			bUpdatingControls = false;
		} else if (C == Btn_Save) {
			Save();
			Load();
		}
	} else if (E == DE_Change) {
		if (C == Edit_Texture && Edit_Texture.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).Texture = Edit_Texture.GetValue();
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).Tex = none;
		} else if (C == Edit_OffsetX && Edit_OffsetX.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetX = int(Edit_OffsetX.GetValue());
		} else if (C == Edit_OffsetY && Edit_OffsetY.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).OffsetY = int(Edit_OffsetY.GetValue());
		} else if (C == Edit_ScaleX && Edit_ScaleX.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleX = int(Edit_ScaleX.GetValue());
		} else if (C == Edit_ScaleY && Edit_ScaleY.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).ScaleY = int(Edit_ScaleY.GetValue());
		} else if (C == Edit_ColorRed && Edit_ColorRed.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).Color.R = byte(Edit_ColorRed.GetValue());
		} else if (C == Edit_ColorGreen && Edit_ColorGreen.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).Color.G = byte(Edit_ColorGreen.GetValue());
		} else if (C == Edit_ColorBlue && Edit_ColorBlue.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).Color.B = byte(Edit_ColorBlue.GetValue());
		} else if (C == Edit_ColorAlpha && Edit_ColorAlpha.EditBox.bCanEdit) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).Color.A = byte(Edit_ColorAlpha.GetValue());
		} else if (C == Cmb_Style && LB_Layers.SelectedItem != none) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).Style = int(Cmb_Style.GetValue2()) + 1;
		} else if (C == Chk_Smooth && Chk_Smooth.bDisabled == false) {
			IGPlus_CrosshairLayersListItem(LB_Layers.SelectedItem).bSmooth = Chk_Smooth.bChecked;
		}
	}
}

function BeforePaint(Canvas C, float X, float Y) {
	local bool HaveSelectedItem;
	local bool HaveNoSelectedItem;

	super.BeforePaint(C, X, Y);

	HaveSelectedItem = LB_Layers.SelectedItem != none;
	HaveNoSelectedItem = LB_Layers.SelectedItem == none;

	Btn_AddLayer.bDisabled = LB_Layers.Items.Count() >= 10;
	Btn_RemLayer.bDisabled = (LB_Layers.Items.Count() <= 0 || HaveNoSelectedItem);

	Btn_ScaleUp.bDisabled = HaveNoSelectedItem;
	Btn_ScaleDown.bDisabled = HaveNoSelectedItem;
	Btn_ScaleLeft.bDisabled = HaveNoSelectedItem;
	Btn_ScaleRight.bDisabled = HaveNoSelectedItem;

	Btn_OffsetUp.bDisabled = HaveNoSelectedItem;
	Btn_OffsetDown.bDisabled = HaveNoSelectedItem;
	Btn_OffsetLeft.bDisabled = HaveNoSelectedItem;
	Btn_OffsetRight.bDisabled = HaveNoSelectedItem;

	Edit_Texture.EditBox.bCanEdit = HaveSelectedItem;

	Edit_OffsetX.EditBox.bCanEdit = HaveSelectedItem;
	Edit_OffsetY.EditBox.bCanEdit = HaveSelectedItem;
	Edit_ScaleX.EditBox.bCanEdit = HaveSelectedItem;
	Edit_ScaleY.EditBox.bCanEdit = HaveSelectedItem;

	Edit_ColorRed.EditBox.bCanEdit = HaveSelectedItem;
	Edit_ColorGreen.EditBox.bCanEdit = HaveSelectedItem;
	Edit_ColorBlue.EditBox.bCanEdit = HaveSelectedItem;
	Edit_ColorAlpha.EditBox.bCanEdit = HaveSelectedItem;

	if (Edit_Texture.EditBox.bCanEdit == false)
		Edit_Texture.Clear();

	if (Edit_OffsetX.EditBox.bCanEdit == false)
		Edit_OffsetX.Clear();
	if (Edit_OffsetY.EditBox.bCanEdit == false)
		Edit_OffsetY.Clear();
	if (Edit_ScaleX.EditBox.bCanEdit == false)
		Edit_ScaleX.Clear();
	if (Edit_ScaleY.EditBox.bCanEdit == false)
		Edit_ScaleY.Clear();

	if (Edit_ColorRed.EditBox.bCanEdit == false)
		Edit_ColorRed.Clear();
	if (Edit_ColorGreen.EditBox.bCanEdit == false)
		Edit_ColorGreen.Clear();
	if (Edit_ColorBlue.EditBox.bCanEdit == false)
		Edit_ColorBlue.Clear();
	if (Edit_ColorAlpha.EditBox.bCanEdit == false)
		Edit_ColorAlpha.Clear();

	Chk_Smooth.bDisabled = HaveNoSelectedItem;
}

function DrawCrosshairLayer(Canvas C, IGPlus_CrosshairLayersListItem L) {
	local float Scal;
	local float LenX, LenY;

	Scal = 4;

	if (L.Tex == none) {
		if (L.Texture == "")
			L.Tex = Texture'CrossHairBase';
		else
			L.Tex = Texture(DynamicLoadObject(L.Texture, class'Texture'));
	}

	if (L.Style == 0)
		L.Style = 1;

	C.Style = L.Style;
	C.DrawColor = L.Color;
	C.bNoSmooth = (L.bSmooth == false);

	LenX = L.ScaleX * L.Tex.USize * Scal;
	LenY = L.ScaleY * L.Tex.VSize * Scal;

	if (L == LB_Layers.SelectedItem) {
		C.DrawColor = L.Color;
		C.DrawColor.R = C.DrawColor.R ^ 0xFF;
		C.DrawColor.G = C.DrawColor.G ^ 0xFF;
		C.DrawColor.B = C.DrawColor.B ^ 0xFF;
		C.DrawColor.A = C.DrawColor.A ^ 0xFF;
		DrawStretchedTexture(C, 128 - 0.5*LenX + (L.OffsetX*Scal), 128 - 0.5*LenY + (L.OffsetY*Scal), LenX, LenY, L.Tex);

		C.DrawColor = L.Color;
		DrawStretchedTexture(C, 128 - 0.5*LenX + (L.OffsetX*Scal) + 1, 128 - 0.5*LenY + (L.OffsetY*Scal) + 1, LenX-2, LenY-2, L.Tex);
	} else {
		DrawStretchedTexture(C, 128 - 0.5*LenX + (L.OffsetX*Scal), 128 - 0.5*LenY + (L.OffsetY*Scal), LenX, LenY, L.Tex);
	}
}

function DrawCrosshair(Canvas C) {
	local IGPlus_CrosshairLayersListItem L;

	for (L = IGPlus_CrosshairLayersListItem(LB_Layers.Items.Next); L != none; L = IGPlus_CrosshairLayersListItem(L.Next))
		DrawCrosshairLayer(C, L);
}

function Paint(Canvas C, float X, float Y) {
	super.Paint(C, X, Y);

	class'CanvasUtils'.static.SaveCanvas(C);

	C.OrgX += int(10 * Root.GUIScale);
	C.OrgY += int(190 * Root.GUIScale);

	C.ClipX = 256 * Root.GUIScale;
	C.ClipY = 256 * Root.GUIScale;

	C.DrawColor.R = ParentDialog.BackgroundBrightness;
	C.DrawColor.G = ParentDialog.BackgroundBrightness;
	C.DrawColor.B = ParentDialog.BackgroundBrightness;
	C.DrawColor.A = 255;
	DrawStretchedTexture(C, 0, 0, 256, 256, Texture'WhiteTexture');

	C.DrawColor.R = C.DrawColor.R ^ 0xFF;
	C.DrawColor.G = C.DrawColor.G ^ 0xFF;
	C.DrawColor.B = C.DrawColor.B ^ 0xFF;
	C.DrawColor.A = 255;
	DrawStretchedTexture(C, 127, 0, 2, 256, Texture'CrossHairBase');
	DrawStretchedTexture(C, 0, 127, 256, 2, Texture'CrossHairBase');

	DrawCrosshair(C);

	class'CanvasUtils'.static.RestoreCanvas(C);
}

defaultproperties {
	ScaleText="Scale"
	OffsetText="Offset"
	TextureText="Texture"

	OffsetXText="Offset X"
	OffsetYText="Offset Y"
	ScaleXText="Scale X"
	ScaleYText="Scale Y"

	ColorRedText="Red"
	ColorGreenText="Green"
	ColorBlueText="Blue"
	ColorAlphaText="Alpha"

	StyleText="Style"
	StyleNormal="Normal"
	StyleMasked="Masked"
	StyleTranslucent="Translucent"
	StyleModulated="Modulated"

	SmoothText="Smooth"
}
