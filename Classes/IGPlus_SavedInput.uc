class IGPlus_SavedInput extends Actor;

var IGPlus_SavedInput Next;
var IGPlus_SavedInput Prev;

var float TimeStamp;
var float Delta;
var vector SavedLocation;
var vector SavedVelocity;
var rotator SavedViewRotation;

var bool SavedDodging;
var EDodgeDir SavedDodgeDir;
var float SavedDodgeClickTimer;
var float SavedLastTimeForward;
var float SavedLastTimeBack;
var float SavedLastTimeLeft;
var float SavedLastTimeRight;

var bool bLive;
var bool bForw;
var bool bBack;
var bool bLeft;
var bool bRigh;
var bool bWalk;
var bool bDuck;
var bool bJump;
var bool bDodg;
var bool bFire;
var bool bAFir;
var bool bFFir;
var bool bFAFr;

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
	SavedLastTimeForward = P.LastTimeForward;
	SavedLastTimeBack = P.LastTimeBack;
	SavedLastTimeLeft = P.LastTimeLeft;
	SavedLastTimeRight = P.LastTimeRight;

	bLive = P.IsInState('Dying') == false;
	if (P.IsInState('Dying') || P.IsInState('GameEnded') || P.IsInState('PlayerWaking')) {
		bForw = false;
		bBack = false;
		bLeft = false;
		bRigh = false;
		bWalk = false;
		bDuck = false;
	} else {
		bForw = P.bWasForward;
		bBack = P.bWasBack;
		bLeft = P.bWasLeft;
		bRigh = P.bWasRight;
		bWalk = P.bRun != 0;
		bDuck = P.bDuck != 0;
	}
	bJump = (P.aUp > 1.0) || P.IGPlus_PressedJumpSave;
	bDodg = P.bPressedDodge;
	bFire = (P.bFire != 0) || P.bJustFired;
	bAFir = (P.bAltFire != 0) || P.bJustAltFired;
	bFFir = P.bJustFired;
	bFAFr = P.bJustAltFired;

	P.bJustFired = false;
	P.bJustAltFired = false;
}

function SerializeTo(IGPlus_DataBuffer B, out float DeltaError) {
	local int Temp;
	// store delta with 20 bits precision between 0.0 and 0.4
	// 2621437.5 = ((1 << 20) - 1) / 0.4
	// int(x + 0.5) is appropriate rounding here because were only dealing with positive numbers
	Temp = int(FClamp(Delta+DeltaError, 0.0, 0.4) * 2621437.5 + 0.5); 
	DeltaError += (Delta - Temp * 0.00000038147009);
	B.AddBits(20, Temp);
	B.AddBit(bLive);
	B.AddBit(bForw);
	B.AddBit(bBack);
	B.AddBit(bLeft);
	B.AddBit(bRigh);
	B.AddBit(bWalk);
	B.AddBit(bDuck);
	B.AddBit(bJump);
	B.AddBit(bDodg);
	B.AddBit(bFire);
	B.AddBit(bAFir);
	B.AddBit(bFFir);
	B.AddBit(bFAFr);
	Temp = SavedViewRotation.Pitch << 16 >> 16;
	Temp = Clamp(Temp, -16384, 16383);
	B.AddBits(15, Temp);
	B.AddBits(16, SavedViewRotation.Yaw);
}

function DeserializeFrom(IGPlus_DataBuffer B) {
	local int Temp;
	// 0.00000038147009 = 0.4 / ((1 << 20) - 1)
	B.ConsumeBits(20, Temp); Delta = Temp * 0.00000038147009;
	B.ConsumeBit(Temp); bLive = Temp != 0;
	B.ConsumeBit(Temp); bForw = Temp != 0;
	B.ConsumeBit(Temp); bBack = Temp != 0;
	B.ConsumeBit(Temp); bLeft = Temp != 0;
	B.ConsumeBit(Temp); bRigh = Temp != 0;
	B.ConsumeBit(Temp); bWalk = Temp != 0;
	B.ConsumeBit(Temp); bDuck = Temp != 0;
	B.ConsumeBit(Temp); bJump = Temp != 0;
	B.ConsumeBit(Temp); bDodg = Temp != 0;
	B.ConsumeBit(Temp); bFire = Temp != 0;
	B.ConsumeBit(Temp); bAFir = Temp != 0;
	B.ConsumeBit(Temp); bFFir = Temp != 0;
	B.ConsumeBit(Temp); bFAFr = Temp != 0;
	B.ConsumeBits(15, SavedViewRotation.Pitch); SavedViewRotation.Pitch = SavedViewRotation.Pitch << 17 >> 17;
	B.ConsumeBits(16, SavedViewRotation.Yaw);
	SavedViewRotation.Roll = 0;
}

function bool IsSimilarTo(IGPlus_SavedInput Other) {
	return
		bLive == Other.bLive &&
		bForw == Other.bForw &&
		bBack == Other.bBack &&
		bLeft == Other.bLeft &&
		bRigh == Other.bRigh &&
		bWalk == Other.bWalk &&
		bDuck == Other.bDuck &&
		bJump == Other.bJump &&
		bDodg == Other.bDodg &&
		bFire == Other.bFire &&
		bAFir == Other.bAFir &&
		bFFir == Other.bFFir &&
		bFAFr == Other.bFAFr &&
		SavedViewRotation.Pitch == Other.SavedViewRotation.Pitch &&
		SavedViewRotation.Yaw == Other.SavedViewRotation.Yaw;
}

defaultproperties {
	bHidden=True
	DrawType=DT_None
	RemoteRole=ROLE_None
	SerializedBits=64
}
