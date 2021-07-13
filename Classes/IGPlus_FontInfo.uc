class IGPlus_FontInfo extends FontInfo;

var Font FontMap[60];
var Font LargestFont;

function Font GetHugeFont(float Width)
{
	return GetFont(Width/100 + 11);
}

function Font GetBigFont(float Width)
{
	return GetFont(Width/100 + 5);
}

function Font GetMediumFont(float Width)
{
	return GetFont(Width/100 + 1);
}

function Font GetSmallFont(float Width)
{
	return GetFont(Width/100 - 1);
}

function Font GetSmallestFont(float Width)
{
	return GetFont(Width/100 - 5);
}

function Font GetAReallySmallFont(float Width)
{
	return GetFont(Width/100 - 9);
}

function Font GetACompletelyUnreadableFont(float Width)
{
	return GetFont(Width/100 - 13);
}

function Font GetFont(int Size) {
	if (Size >= 60) {
		return LargestFont;
	}
	return FontMap[Max(Size, 0)];
}

event PostBeginPlay() {
	LargestFont = Font(DynamicLoadObject("LadderFonts.UTLadder60", class'Font'));
	FontMap[0] = Font'SmallFont';
	FontMap[1] = Font'SmallFont';
	FontMap[2] = Font'SmallFont';
	FontMap[3] = Font'SmallFont';
	FontMap[4] = Font'SmallFont';
	FontMap[5] = Font'SmallFont';
	FontMap[6] = Font'SmallFont';
	FontMap[7] = Font'SmallFont';
	FontMap[8] = Font(DynamicLoadObject("LadderFonts.UTLadder8", class'Font'));
	FontMap[9] = FontMap[8];
	FontMap[10] = Font(DynamicLoadObject("LadderFonts.UTLadder10", class'Font'));
	FontMap[11] = FontMap[10];
	FontMap[12] = Font(DynamicLoadObject("LadderFonts.UTLadder12", class'Font'));
	FontMap[13] = FontMap[12];
	FontMap[14] = Font(DynamicLoadObject("LadderFonts.UTLadder14", class'Font'));
	FontMap[15] = FontMap[14];
	FontMap[16] = Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font'));
	FontMap[17] = FontMap[16];
	FontMap[18] = Font(DynamicLoadObject("LadderFonts.UTLadder18", class'Font'));
	FontMap[19] = FontMap[18];
	FontMap[20] = Font(DynamicLoadObject("LadderFonts.UTLadder20", class'Font'));
	FontMap[21] = FontMap[20];
	FontMap[22] = Font(DynamicLoadObject("LadderFonts.UTLadder22", class'Font'));
	FontMap[23] = FontMap[22];
	FontMap[24] = Font(DynamicLoadObject("LadderFonts.UTLadder24", class'Font'));
	FontMap[25] = FontMap[24];
	FontMap[26] = FontMap[24];
	FontMap[27] = FontMap[24];
	FontMap[28] = FontMap[24];
	FontMap[29] = FontMap[24];
	FontMap[30] = Font(DynamicLoadObject("LadderFonts.UTLadder30", class'Font'));
	FontMap[31] = FontMap[30];
	FontMap[32] = FontMap[30];
	FontMap[33] = FontMap[30];
	FontMap[34] = FontMap[30];
	FontMap[35] = FontMap[30];
	FontMap[36] = Font(DynamicLoadObject("LadderFonts.UTLadder36", class'Font'));
	FontMap[37] = FontMap[36];
	FontMap[38] = FontMap[36];
	FontMap[39] = FontMap[36];
	FontMap[40] = FontMap[36];
	FontMap[41] = FontMap[36];
	FontMap[42] = Font(DynamicLoadObject("LadderFonts.UTLadder42", class'Font'));
	FontMap[43] = FontMap[42];
	FontMap[44] = FontMap[42];
	FontMap[45] = FontMap[42];
	FontMap[46] = FontMap[42];
	FontMap[47] = FontMap[42];
	FontMap[48] = Font(DynamicLoadObject("LadderFonts.UTLadder48", class'Font'));
	FontMap[49] = FontMap[48];
	FontMap[50] = FontMap[48];
	FontMap[51] = FontMap[48];
	FontMap[52] = FontMap[48];
	FontMap[53] = FontMap[48];
	FontMap[54] = Font(DynamicLoadObject("LadderFonts.UTLadder54", class'Font'));
	FontMap[55] = FontMap[54];
	FontMap[56] = FontMap[54];
	FontMap[57] = FontMap[54];
	FontMap[58] = FontMap[54];
	FontMap[59] = FontMap[54];
}

