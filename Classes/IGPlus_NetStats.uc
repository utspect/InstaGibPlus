class IGPlus_NetStats extends Actor;

#EXEC LOAD FILE="Textures/IGPlusNetStats.utx" PACKAGE=InstaGibPlus.NetStats

var ScriptedTexture Tex[2];

var float LocationError;
var float UnconfirmedTime;
var bool bInstantRelocation;

var int IndexNew;
var int IndexOld;

function PostBeginPlay() {
	Tex[0].NotifyActor = self;
	Tex[1].NotifyActor = self;
}

function RenderTexture(ScriptedTexture T) {
	if (T != Tex[IndexNew])
		return;

	T.DrawTile(0,0, 511, 128, 1,0, 511, 128, Tex[IndexOld], false);
	T.DrawTile(511,0, 1, 128, 8+6*IndexNew,0, 1, 128, Texture'NetStatsBase', false);

	Log("NetStats RenderTexture"@T@IndexNew);
}

function PostRender(Canvas C) {
	local int Temp;

	class'CanvasUtils'.static.SaveCanvas(C);
	
	C.Style = ERenderStyle.STY_Masked;
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	C.DrawColor.A = 255;

	C.SetPos((C.SizeX - Tex[IndexNew].USize) * 0.5, 0);
	C.DrawIcon(Tex[IndexNew], 1.0);

	class'CanvasUtils'.static.RestoreCanvas(C);

	Temp = IndexOld;
	IndexOld = IndexNew;
	IndexNew = Temp;
}

defaultproperties {
	Tex(0)=ScriptedTexture'NetStats0';
	Tex(1)=ScriptedTexture'NetStats1';
	IndexNew=0
	IndexOld=1
}
