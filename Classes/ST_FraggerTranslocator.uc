class ST_FraggerTranslocator extends ST_Translocator;

#exec AUDIO IMPORT FILE="Sounds/Fragger/XlocRespawn.wav"

function Translocate()
{
	local vector Dest, Start;
	local Bot B;
	local Pawn P;

	if (STM != none)
		STM.PlayerHit(Pawn(Owner), 2, False);			// 2 = Translocator
	if (Owner.IsA('bbPlayer'))
		bbPlayer(Owner).IGPlus_BeforeTranslocate();

	bBotMoveFire = false;
	PlayAnim('Thrown', 1.2,0.1);
	Dest = TTarget.Location;
	if ( TTarget.Physics == PHYS_None )
		Dest += vect(0,0,55);

	if ( Level.Game.IsA('DeathMatchPlus')
		&& !DeathMatchPlus(Level.Game).AllowTranslocation(Pawn(Owner), Dest) )
		return;

	Start = Pawn(Owner).Location;
	TTarget.SetCollision(false,false,false);
	if ( Pawn(Owner).SetLocation(Dest) )
	{
		if ( !Owner.Region.Zone.bWaterZone )
			Owner.SetPhysics(PHYS_Falling);
		if ( TTarget.Disrupted() )
		{
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogSpecialEvent("translocate_gib", Pawn(Owner).PlayerReplicationInfo.PlayerID);
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogSpecialEvent("translocate_gib", Pawn(Owner).PlayerReplicationInfo.PlayerID);

			SpawnEffect(Start, Dest);
			Pawn(Owner).gibbedBy(TTarget.disruptor);
			return;
		}

		if ( !FastTrace(Pawn(Owner).Location, TTarget.Location) )
		{
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogSpecialEvent("translocate_fail", Pawn(Owner).PlayerReplicationInfo.PlayerID);
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogSpecialEvent("translocate_fail", Pawn(Owner).PlayerReplicationInfo.PlayerID);

			Pawn(Owner).SetLocation(Start);
			Owner.PlaySound(AltFireSound, SLOT_Misc, 4 * Pawn(Owner).SoundDampening);
		}
		else
		{
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogSpecialEvent("translocate", Pawn(Owner).PlayerReplicationInfo.PlayerID);
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogSpecialEvent("translocate", Pawn(Owner).PlayerReplicationInfo.PlayerID);

			Owner.Velocity.X = 0;
			Owner.Velocity.Y = 0;
			B = Bot(Owner);
			if ( B != None )
			{
				if ( TTarget.DesiredTarget.IsA('NavigationPoint') )
					B.MoveTarget = TTarget.DesiredTarget;
				B.bJumpOffPawn = true;
				if ( !Owner.Region.Zone.bWaterZone )
					B.SetFall();
			}
			else
			{
				// bots must re-acquire this player
				for ( P=Level.PawnList; P!=None; P=P.NextPawn )
					if ( (P.Enemy == Owner) && P.IsA('Bot') )
						Bot(P).LastAcquireTime = Level.TimeSeconds;
			}

			//SpawnEffect(Start, Dest);
			//Level.Game.PlayTeleportEffect(Owner, true, true);
			//SpawnEffect(Start, Dest);
			if ( PlayerPawn(Owner) != None )
			Owner.PlaySound(Sound'XlocRespawn', SLOT_Misc, 4 * Pawn(Owner).SoundDampening);
		}
	}
	else
	{
		Owner.PlaySound(AltFireSound, SLOT_Misc, 4 * Pawn(Owner).SoundDampening);
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogSpecialEvent("translocate_fail", Pawn(Owner).PlayerReplicationInfo.PlayerID);
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogSpecialEvent("translocate_fail", Pawn(Owner).PlayerReplicationInfo.PlayerID);
	}

	if ( TTarget != None )
	{
		bTTargetOut = false;
		TTarget.Destroy();
		TTarget = None;
	}
	bPointing=True;

	if (Owner.IsA('bbPlayer'))
		bbPlayer(Owner).IGPlus_AfterTranslocate();
	if (STM != none)
		STM.PlayerClear();
}

defaultproperties
{
      WeaponDescription="Classification:FraggerXLoc"
      DeathMessage="%k just got telefragged %o"
      PickupMessage="You got the Fragger Translocator."
      ItemName="FraggerXLoc"
}
