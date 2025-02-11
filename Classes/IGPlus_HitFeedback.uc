class IGPlus_HitFeedback extends Mutator;
// Description="<Internal>"

var bool bCheckVisibility;

event PostBeginPlay() {
	if (Level == none || Level.Game == none) {
		Destroy(); // spawned client-side? wtf?
		return;
	}

	if (Level.Game.BaseMutator == none)
		Level.Game.BaseMutator = self;
	else
		Level.Game.BaseMutator.AddMutator(self);

	Level.Game.RegisterDamageMutator(self);
}

function AddMutator(Mutator M) {
	if (M.Class != Class)
		super.AddMutator(M);
}

function IGPlus_HitFeedbackTracker FindTracker(Pawn P) {
	local Inventory I;

	for (I = P.Inventory; I != none; I = I.Inventory)
		if (I.IsA('IGPlus_HitFeedbackTracker'))
			return IGPlus_HitFeedbackTracker(I);

	return none;
}

function CreateTracker(Pawn P) {
	local IGPlus_HitFeedbackTracker T;
	T = Spawn(class'IGPlus_HitFeedbackTracker');
	T.GiveTo(P);
}

function ModifyPlayer(Pawn P) {
	super.ModifyPlayer(P);

	if (FindTracker(P) == none)
		CreateTracker(P);
}

function bool CheckVisibility(Pawn Orig, Pawn Dest) {
	local rotator DirYaw;
	local vector X,Y,Z;
	local vector Start;
	local vector End[7];
	local int i;

	if (bCheckVisibility == false)
		return true;

	DirYaw = rotator(Dest.Location - Orig.Location);
	DirYaw.Pitch = 0;
	DirYaw.Roll = 0;

	GetAxes(DirYaw,X,Y,Z);

	Start = Orig.Location + vect(0,0,1)*Orig.BaseEyeHeight;

	End[0] = Dest.Location;                                            // center
	End[1] = End[0] + Y*Dest.CollisionRadius + Z*Dest.CollisionHeight; // top left
	End[2] = End[0] - Y*Dest.CollisionRadius + Z*Dest.CollisionHeight; // top right
	End[3] = End[0] + Y*Dest.CollisionRadius;                          // center left
	End[4] = End[0] - Y*Dest.CollisionRadius;                          // center right
	End[5] = End[0] + Y*Dest.CollisionRadius - Z*Dest.CollisionHeight; // bottom left
	End[6] = End[0] - Y*Dest.CollisionRadius - Z*Dest.CollisionHeight; // bottom right

	for (i = 0; i < arraycount(End); ++i)
		if (FastTrace(End[i], Start))
			return true;

	return false;
}

function MutatorTakeDamage(
	out int ActualDamage,
	Pawn Victim,
	Pawn InstigatedBy,
	out Vector HitLocation,
	out Vector Momentum,
	name DamageType
) {
	local Pawn P;
	local int TotalDamage;
	local IGPlus_HitFeedbackTracker Tracker;

	if (InstigatedBy != none && Victim != none) {
		if (CheckVisibility(InstigatedBy, Victim) == false)
			return;

		Tracker = FindTracker(Victim);
		if (Tracker != none)
			TotalDamage = Tracker.LastDamage;

		InstigatedBy.ReceiveLocalizedMessage(
			Class'IGPlus_HitFeedbackMessage',
			TotalDamage,
			Victim.PlayerReplicationInfo,
			InstigatedBy.PlayerReplicationInfo
		);
		for (P = Level.PawnList; P != none; P = P.NextPawn)
			if (P.IsA('PlayerPawn') && PlayerPawn(P).ViewTarget == InstigatedBy)
				P.ReceiveLocalizedMessage(
					Class'IGPlus_HitFeedbackMessage',
					TotalDamage,
					Victim.PlayerReplicationInfo,
					InstigatedBy.PlayerReplicationInfo
				);
	}

	super.MutatorTakeDamage(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType);
}
