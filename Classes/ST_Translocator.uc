// ===============================================================
// Stats.ST_Translocator: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_Translocator extends Translocator;

var ST_Mutator STM;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	ForEach AllActors(Class'ST_Mutator', STM)
		break;		// Find master :D
}

function ReturnToPreviousWeapon()
{	// This fixes the "both buttons goes back to old weapon" annoyance.
	if (GetPropertyText("bClientDualButtonSwitch") ~= "false")
		return;
	Super.ReturnToPreviousWeapon();
}

function Translocate()
{
	STM.PlayerHit(Pawn(Owner), 2, False);			// 2 = Translocator
	if (Owner.IsA('bbPlayer'))
		bbPlayer(Owner).IGPlus_BeforeTranslocate();
	Super.Translocate();
	if (Owner.IsA('bbPlayer'))
		bbPlayer(Owner).IGPlus_AfterTranslocate();
	STM.PlayerClear();
}

function ThrowTarget()
{
	local Vector Start, X,Y,Z;

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
		TTarget.DisruptionThreshold = STM.WeaponSettings.TranslocatorHealth;
		if ( Owner.IsA('Bot') )
			TTarget.SetCollisionSize(0,0);
		TTarget.Throw(Pawn(Owner), MaxTossForce, Start);
	}
	else GotoState('Idle');
}

simulated function TweenDown()
{
	PlayAnim('Down', 100.0, 0.0);
}

defaultproperties {
}
