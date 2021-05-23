class IGPlus_DamageEvent extends Actor;

var IGPlus_DamageEvent Next;

var PlayerReplicationInfo Enemy;
var int Damage;
var name DamageType;
var float TimeStamp;

defaultproperties {
	bHidden=True
	RemoteRole=ROLE_None
}
