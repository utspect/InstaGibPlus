// ===============================================================
// UTPureRC7A.PureStatMutator: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class PureStatMutator extends Mutator;

// The original MutatorTakeDamage is broken (called after handling armor)
function PlayerTakeDamage(Pawn Victim, Pawn Instigator, int Damage, name DamageType);

// ScoreKill doesn't register teamkills.
function PlayerKill(Pawn Killer, Pawn Victim);

defaultproperties
{
}
