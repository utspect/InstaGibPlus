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
	if (GetPropertyText("bEnableDualButtonSwitch") ~= "false")
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
	STM.PlayerFire(Pawn(Owner), 2);		// 2 = Translocator
	Super.ThrowTarget();
	if (TTarget != none) {
		TTarget.DisruptionThreshold = STM.WeaponSettings.TranslocatorHealth;
	}
}

simulated function TweenDown()
{
	PlayAnim('Down', 100.0, 0.0);
}

defaultproperties {
}
