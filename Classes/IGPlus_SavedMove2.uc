class IGPlus_SavedMove2 extends Actor;

var IGPlus_SavedMove2 Next;
var IGPlus_SavedMove2 Prev;

var float TimeStamp;
var float Delta;
var vector SavedLocation;
var vector SavedVelocity;
var rotator SavedViewRotation;

var bool SavedDodging;
var EDodgeDir SavedDodgeDir;
var float SavedDodgeClickTimer;

var bool bForw;
var bool bBack;
var bool bLeft;
var bool bRigh;
var bool bWalk;
var bool bDuck;
var bool bJump;
var bool bFire;
var bool bAFir;

var int SerializedBits;

function Initialize() {
	Next = none;
	Prev = none;
}

function CopyFrom(float Delta, bbPlayer P) {
	TimeStamp = Level.TimeSeconds;
	self.Delta = Delta;
	SavedLocation = P.Location;
	SavedVelocity = P.Velocity;
	SavedViewRotation = P.ViewRotation;

	SavedDodging = P.bDodging;
	SavedDodgeDir = P.DodgeDir;
	SavedDodgeClickTimer = P.DodgeClickTimer;

	bForw = P.bWasForward;
	bBack = P.bWasBack;
	bLeft = P.bWasLeft;
	bRigh = P.bWasRight;
	bWalk = P.bRun != 0;
	bDuck = P.bDuck != 0;
	bJump = P.aUp > 1.0;
	bFire = P.bFire != 0;
	bAFir = P.bAltFire != 0;
}

function SerializeTo(IGPlus_DataBuffer B) {
	B.AddFloat(Delta);
	B.AddBit(bForw);
	B.AddBit(bBack);
	B.AddBit(bLeft);
	B.AddBit(bRigh);
	B.AddBit(bWalk);
	B.AddBit(bDuck);
	B.AddBit(bJump);
	B.AddBit(bFire);
	B.AddBit(bAFir);
	B.AddBits(16, SavedViewRotation.Pitch);
	B.AddBits(16, SavedViewRotation.Yaw);
}

function DeserializeFrom(IGPlus_DataBuffer B) {
	local int Temp;
	B.ConsumeFloat(Delta);
	B.ConsumeBit(Temp); bForw = Temp != 0;
	B.ConsumeBit(Temp); bBack = Temp != 0;
	B.ConsumeBit(Temp); bLeft = Temp != 0;
	B.ConsumeBit(Temp); bRigh = Temp != 0;
	B.ConsumeBit(Temp); bWalk = Temp != 0;
	B.ConsumeBit(Temp); bDuck = Temp != 0;
	B.ConsumeBit(Temp); bJump = Temp != 0;
	B.ConsumeBit(Temp); bFire = Temp != 0;
	B.ConsumeBit(Temp); bAFir = Temp != 0;
	B.ConsumeBits(16, SavedViewRotation.Pitch);
	B.ConsumeBits(16, SavedViewRotation.Yaw);
	SavedViewRotation.Roll = 0;
}

function bool IsSimilarTo(IGPlus_SavedMove2 Other) {
	return
		bForw == Other.bForw &&
		bBack == Other.bBack &&
		bLeft == Other.bLeft &&
		bRigh == Other.bRigh &&
		bWalk == Other.bWalk &&
		bDuck == Other.bDuck &&
		bJump == Other.bJump &&
		bFire == Other.bFire &&
		bAFir == Other.bAFir &&
		SavedViewRotation.Pitch == Other.SavedViewRotation.Pitch &&
		SavedViewRotation.Yaw == Other.SavedViewRotation.Yaw;
}

function IGPlus_SavedMove2 SerializeNodes(int MaxNumNodes, IGPlus_SavedMove2 NextNode, IGPlus_DataBuffer B, int SpaceRequired) {
	local IGPlus_SavedMove2 ReferenceNode;

	if (MaxNumNodes <= 0 || B.IsSpaceSufficient(SpaceRequired + default.SerializedBits) == false || Prev == none)
		return self;

	ReferenceNode = Prev.SerializeNodes(MaxNumNodes - 1, self, B, SpaceRequired + default.SerializedBits);

	//if (NextNode == none || IsSimilarTo(NextNode) == false) // uncomment to compress Input stream
		SerializeTo(B);

	return ReferenceNode;
}


defaultproperties {
	bHidden=True
	DrawType=DT_None
	RemoteRole=ROLE_None
	SerializedBits=73
}
