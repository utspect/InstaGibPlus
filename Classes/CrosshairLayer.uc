class CrosshairLayer extends Object;

var Texture Texture;
var int OffsetX;
var int OffsetY;
var float ScaleX;
var float ScaleY;
var color Color;
var byte Style;
var bool bSmooth;

var CrosshairLayer Next;

DefaultProperties
{
	Texture=Texture'CrossHairBase'
	OffsetX=0
	OffsetY=0
	ScaleX=1
	ScaleY=1
	Color=(R=255,G=255,B=255,A=255)
	Style=1
	bSmooth=false
}