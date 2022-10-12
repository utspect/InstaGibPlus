// ===============================================================
// Stats.ST_Translocator: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_Translocator extends Translocator;

var ST_Mutator STM;

var WeaponSettingsRepl WSettings;

simulated final function WeaponSettingsRepl FindWeaponSettings() {
	local WeaponSettingsRepl S;

	foreach AllActors(class'WeaponSettingsRepl', S)
		return S;

	return none;
}

simulated final function WeaponSettingsRepl GetWeaponSettings() {
	if (WSettings != none)
		return WSettings;

	WSettings = FindWeaponSettings();
	return WSettings;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	ForEach AllActors(Class'ST_Mutator', STM)
		break;		// Find master :D
}

function ReturnToPreviousWeapon()
{
	if (Owner.IsA('bbPlayer') && bbPlayer(Owner).IGPlus_EnableDualButtonSwitch == false)
		return;
	Super.ReturnToPreviousWeapon();
}

function Translocate()
{
	if (STM != none)
		STM.PlayerHit(Pawn(Owner), 2, False);			// 2 = Translocator
	if (Owner.IsA('bbPlayer'))
		bbPlayer(Owner).IGPlus_BeforeTranslocate();
	Super.Translocate();
	if (Owner.IsA('bbPlayer'))
		bbPlayer(Owner).IGPlus_AfterTranslocate();
	if (STM != none)
		STM.PlayerClear();
}

function ThrowTarget()
{
	local Vector Start, X,Y,Z;

	if (STM != none)
		STM.PlayerFire(Pawn(Owner), 2);		// 2 = Translocator

	if (Level.Game.LocalLog != None)
		Level.Game.LocalLog.LogSpecialEvent("throw_translocator", Pawn(Owner).PlayerReplicationInfo.PlayerID);
	if (Level.Game.WorldLog != None)
		Level.Game.WorldLog.LogSpecialEvent("throw_translocator", Pawn(Owner).PlayerReplicationInfo.PlayerID);

	if ( Owner.IsA('Bot') )
		bBotMoveFire = true;
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	Pawn(Owner).ViewRotation = Pawn(Owner).AdjustToss(TossForce, Start, 0, true, true);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	TTarget = Spawn(class'ST_TranslocatorTarget',,, Start);
	if (TTarget!=None)
	{
		bTTargetOut = true;
		TTarget.Master = self;
		TTarget.DisruptionThreshold = GetWeaponSettings().TranslocatorHealth;
		if ( Owner.IsA('Bot') )
			TTarget.SetCollisionSize(0,0);
		TTarget.Throw(Pawn(Owner), MaxTossForce, Start);
	}
	else GotoState('Idle');
}

simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	if ( bTTargetOut )
		TweenAnim('ThrownFrame', GetWeaponSettings().TranslocatorOutSelectTime);
	else
		PlayAnim('Select',GetWeaponSettings().TranslocatorSelectAnimSpeed(), 0.0);
	PlaySound(SelectSound, SLOT_Misc,Pawn(Owner).SoundDampening);		
}

simulated function TweenDown() {
	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * GetWeaponSettings().TranslocatorDownTime );
	else if ( bTTargetOut )
		PlayAnim('Down2', GetWeaponSettings().TranslocatorDownAnimSpeed(), 0.05);
	else
		PlayAnim('Down', GetWeaponSettings().TranslocatorDownAnimSpeed(), 0.05);
}

defaultproperties {
}
