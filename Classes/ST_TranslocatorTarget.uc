class ST_TranslocatorTarget extends TranslocatorTarget;

auto state Pickup {
	event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType) {
		local float OldDisruption;

		OldDisruption = Disruption;

		super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);

		if (Disruption == OldDisruption)
			return;

		if (Master != none && Master.Owner != none && Master.Owner.IsA('PlayerPawn'))
			PlayerPawn(Master.Owner).ClientMessage("TTarget took"@Damage@"damage (Total"@int(Disruption)$")");
	}
}
