class IGPlus_HitFeedback extends Mutator;
// Description="<Internal>"

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

	if (Victim != none)
		Tracker = FindTracker(Victim);
	if (Tracker != none)
		TotalDamage = Tracker.LastDamage;

	InstigatedBy.ReceiveLocalizedMessage(Class'IGPlus_HitFeedbackMessage', TotalDamage, Victim.PlayerReplicationInfo, InstigatedBy.PlayerReplicationInfo);
	for (P = Level.PawnList; P != none; P = P.NextPawn)
		if (P.IsA('PlayerPawn') && PlayerPawn(P).ViewTarget == InstigatedBy)
			P.ReceiveLocalizedMessage(Class'IGPlus_HitFeedbackMessage', TotalDamage, Victim.PlayerReplicationInfo, InstigatedBy.PlayerReplicationInfo);

	super.MutatorTakeDamage(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType);
}
