class CrosshairLayer extends Object;

// 1x1 white texture as base for painting crosshairs
#exec Texture Import File=Textures\CrossHairBase.pcx Name=CrossHairBase Mips=Off


var Texture Texture;
var int OffsetX;
var int OffsetY;
var float ScaleX;
var float ScaleY;
var color Color;
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
	bSmooth=false
}