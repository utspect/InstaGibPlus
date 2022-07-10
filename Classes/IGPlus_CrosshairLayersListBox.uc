class IGPlus_CrosshairLayersListBox extends UWindowListBox;

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local IGPlus_CrosshairLayersListItem L;
	local string Descr;

	if(SelectedItem == Item) {
		C.DrawColor.r = 160;
		C.DrawColor.g = 160;
		C.DrawColor.b = 160;
		DrawStretchedTexture(C, X, Y, W, H, Texture'WhiteTexture');
	}

	L = IGPlus_CrosshairLayersListItem(Item);
	if (L == none)
		return;

	Descr = L.Index $ ": ";

	if (L.Texture != "")
		Descr = Descr $ L.Texture $ " ";

	if (L.ScaleX != 1.0 || L.ScaleY != 1.0)
		Descr = Descr $ class'StringUtils'.static.FormatFloat(L.ScaleX, 2)$"x"$class'StringUtils'.static.FormatFloat(L.ScaleY, 2) $ " ";

	if (L.OffsetX != 0 || L.OffsetY != 0)
		Descr = Descr $ "@ "$L.OffsetX$","$L.OffsetY $ " ";

	C.DrawColor = L.Color;
	DrawStretchedTexture(C, X+1, Y+1, 14, H-2, Texture'WhiteTexture');

	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;
	C.Font = Root.Fonts[F_Normal];
	ClipText(C, X+18, Y, Descr);
}

defaultproperties {
	ListClass=class'IGPlus_CrosshairLayersListItem'
	bCanDrag=True
	ItemHeight=13
}
