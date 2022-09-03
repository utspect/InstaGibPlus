class IGPlus_CrosshairLayersListItem extends UWindowListBoxItem;

var() int    Index;
var() string Texture;
var() int    OffsetX, OffsetY;
var() float  ScaleX, ScaleY;
var() color  Color;
var() byte   Style;
var() bool   bSmooth;
var() bool   bUse;

var Texture Tex;

function int Compare(UWindowList T, UWindowList B) {
	local IGPlus_CrosshairLayersListItem Lhs, Rhs;
	Lhs = IGPlus_CrosshairLayersListItem(T);
	Rhs = IGPlus_CrosshairLayersListItem(B);

	return Lhs.Index - Rhs.Index;
}
