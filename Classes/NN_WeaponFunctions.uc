class NN_WeaponFunctions extends Object;

static simulated function SetSwitchPriority(pawn Other, weapon Weap, name CustomName)
{
	local int i;
	local name temp, carried;

	if ( PlayerPawn(Other) != None )
	{
		for ( i=0; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++)
			if ( PlayerPawn(Other).WeaponPriority[i] == CustomName )
			{
				Weap.AutoSwitchPriority = i;
				return;
			}
		carried = CustomName;
		for ( i=Weap.AutoSwitchPriority; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++ )
		{
			if ( PlayerPawn(Other).WeaponPriority[i] == '' )
			{
				PlayerPawn(Other).WeaponPriority[i] = carried;
				return;
			}
			else if ( i<ArrayCount(PlayerPawn(Other).WeaponPriority)-1 )
			{
				temp = PlayerPawn(Other).WeaponPriority[i];
				PlayerPawn(Other).WeaponPriority[i] = carried;
				carried = temp;
			}
		}
	}
}

static simulated function PlaySelect (TournamentWeapon W)
{
 	local float PScale;

	W.bForceFire = False;
	W.bForceAltFire = False;
	W.bCanClientFire = False;

	if ( (Pawn(W.Owner) != None) && (Pawn(W.Owner).PlayerReplicationInfo != None) )
		PScale = Pawn(W.Owner).PlayerReplicationInfo.Ping;

	PScale = FMax(PScale,1.0);
	PScale /= 1000.0;

	if ( W.Mesh == W.PickupViewMesh )
		return;

	if ( W.HasAnim('Select') && !W.IsAnimating() || (W.AnimSequence != 'Select') )
		W.PlayAnim('Select',1.35 + PScale,0.05);

	if ( W.Owner != None )
		W.AmbientSound = None;
		W.Owner.PlaySound(W.SelectSound, SLOT_Misc, Pawn(W.Owner).SoundDampening);
}

static simulated function TweenDown (TournamentWeapon W)
{
 	local float PScale;

	PScale = Pawn(W.Owner).PlayerReplicationInfo.Ping;
	PScale = FMax(PScale,1.0);
	PScale /= 1000.0;

	if ( W.Mesh == W.PickupViewMesh )
		return;

	if ( W.IsAnimating() && (W.AnimSequence != '') && (W.GetAnimGroup(W.AnimSequence) == 'Select') )
		W.TweenAnim( W.AnimSequence, W.AnimFrame * 0.4 );
	else
		W.PlayAnim('Down', 1.35 + PScale,0.05);

	if ( W.Owner != None )
		W.AmbientSound = None;
}

static simulated function AnimEnd (TournamentWeapon W)
{
	//local TournamentPlayer T;

	//T = TournamentPlayer(W.Owner);

	if ( (W.Level.NetMode == NM_Client) && (W.Mesh != W.PickupViewMesh) )
		W.PlayIdleAnim();
/*
	if ( T != None && T.Weapon != None )
	{
		if ( (T.ClientPending != None) && (T.ClientPending.Owner == W.Owner) )
		{
			T.Weapon = T.ClientPending;
			if ( T.Weapon.IsA('TournamentWeapon') )
				T.Weapon.GotoState('ClientActive');
			T.ClientPending = None;
			W.GotoState('');
		}
		else
		{
			W.Enable('Tick');
		}
	} */
}

static function vector IGPlus_CalcDrawOffset(PlayerPawn P, Weapon W) {
	local LevelInfo Level;

	if (P == none) return vect(0,0,0);
	if (W == none) return vect(0,0,0);

	Level = P.Level;
	if (Level == none) return vect(0,0,0);

	if ((Level.NetMode == NM_DedicatedServer) ||
		(P.RemoteRole == ROLE_AutonomousProxy)
	) {
		return (P.BaseEyeHeight * vect(0,0,1));
	} else {
		return (P.EyeHeight * vect(0,0,1)) + P.WalkBob;
	}
}

static final function IGPlus_BeforeClientFire(TournamentWeapon W) {
	local bbPlayer P;
	if (W.Owner != none && W.Owner.IsA('bbPlayer')) {
		P = bbPlayer(W.Owner);
		P.IGPlus_LocationOffsetFix_RestoreAll();
	}
}

static final function IGPlus_AfterClientFire(TournamentWeapon W) {
	local bbPlayer P;
	if (W.Owner != none && W.Owner.IsA('bbPlayer')) {
		P = bbPlayer(W.Owner);
		P.IGPlus_LocationOffsetFix_UndoRestoreAll();
	}
}

static final function IGPlus_BeforeClientAltFire(TournamentWeapon W) {
	local bbPlayer P;
	if (W.Owner != none && W.Owner.IsA('bbPlayer')) {
		P = bbPlayer(W.Owner);
		P.IGPlus_LocationOffsetFix_RestoreAll();
	}
}

static final function IGPlus_AfterClientAltFire(TournamentWeapon W) {
	local bbPlayer P;
	if (W.Owner != none && W.Owner.IsA('bbPlayer')) {
		P = bbPlayer(W.Owner);
		P.IGPlus_LocationOffsetFix_UndoRestoreAll();
	}
}
