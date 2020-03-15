class NN_Teleporter extends Teleporter;

var rotator zzRotation;
var name    zzTag;
var name    zzEvent;
var name    zzAttachTag;

var bool	zzbEnabled;			// Teleporter is turned on;
var string  zzURL;
var name    zzProductRequired;
var bool    zzbChangesVelocity; // Set velocity to TargetVelocity.
var bool    zzbChangesYaw;      // Sets yaw to teleporter's Rotation.Yaw
var bool    zzbReversesX;       // Reverses X-component of velocity.
var bool    zzbReversesY;       // Reverses Y-component of velocity.
var bool    zzbReversesZ;       // Reverses Z-component of velocity.
var vector  zzTargetVelocity;   // If bChangesVelocity, set target's velocity to this.

replication
{
	reliable if( Role==ROLE_Authority )
		zzRotation, zzTag, zzEvent, zzAttachTag,
		zzbEnabled, zzURL, zzProductRequired, zzbChangesVelocity, zzbChangesYaw, zzbReversesX, zzbReversesY, zzbReversesZ, zzTargetVelocity;
}

simulated function Touch( actor Other )
{
}

defaultProperties {
	bStatic=false
	bAlwaysRelevant=true
}