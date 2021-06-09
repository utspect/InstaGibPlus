class CanvasUtils extends Object;

struct CanvasState {
	var Font Font;
	var float SpaceX, SpaceY;
	var float OrgX, OrgY;
	var float CurX, CurY;
	var float Z;
	var byte Style;
	var float CurYL;
	var color DrawColor;
	var bool bCenter;
	var bool bNoSmooth;
};

const MaxCanvasCallDepth = 10;
var CanvasState CanvasCallStates[MaxCanvasCallDepth];
var int CanvasCallDepth;

static final function bool SaveCanvas(Canvas C) {
	if (default.CanvasCallDepth >= MaxCanvasCallDepth) {
		Log("Exceeded Maximum Canvas Call Depth!", 'IGPlus');
		return false;
	}

	SaveCanvasState(C, default.CanvasCallStates[default.CanvasCallDepth++]);
	return true;
}

static final function RestoreCanvas(Canvas C) {
	if (default.CanvasCallDepth <= 0) {
		Log("Exceeded Minimum Canvas Call Depth!", 'IGPlus');
		return;
	}

	RestoreCanvasState(C, default.CanvasCallStates[--default.CanvasCallDepth]);
}

static final function SaveCanvasState(Canvas C, out CanvasState S) {
	S.Font = C.Font;
	S.SpaceX = C.SpaceX;
	S.SpaceY = C.SpaceY;
	S.OrgX = C.OrgX;
	S.OrgY = C.OrgY;
	S.CurX = C.CurX;
	S.CurY = C.CurY;
	S.Z = C.Z;
	S.Style = C.Style;
	S.CurYL = C.CurYL;
	S.DrawColor = C.DrawColor;
	S.bCenter = C.bCenter;
	S.bNoSmooth = C.bNoSmooth;
}

static final function RestoreCanvasState(Canvas C, out CanvasState S) {
	C.Font = S.Font;
	C.SpaceX = S.SpaceX;
	C.SpaceY = S.SpaceY;
	C.OrgX = S.OrgX;
	C.OrgY = S.OrgY;
	C.CurX = S.CurX;
	C.CurY = S.CurY;
	C.Z = S.Z;
	C.Style = S.Style;
	C.CurYL = S.CurYL;
	C.DrawColor = S.DrawColor;
	C.bCenter = S.bCenter;
	C.bNoSmooth = S.bNoSmooth;
}
