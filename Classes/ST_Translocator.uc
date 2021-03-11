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
	if (bbPlayer(Owner).bNoRevert)
		return;
	Super.ReturnToPreviousWeapon();
}

function Translocate()
{
	STM.PlayerHit(Pawn(Owner), 2, False);			// 2 = Translocator
	Super.Translocate();
	STM.PlayerClear();
}

function ThrowTarget()
{
	STM.PlayerFire(Pawn(Owner), 2);		// 2 = Translocator
	Super.ThrowTarget();
}

simulated function TweenDown()
{
	PlayAnim('Down', 100.0, 0.0);
}

defaultproperties {
}
