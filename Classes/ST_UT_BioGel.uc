// ===============================================================
// UTPureStats7A.ST_UT_BioGel: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UT_BioGel extends UT_BioGel;

var ST_Mutator STM;
var bool bDirect;

function PostBeginPlay()
{
	ForEach AllActors(Class'ST_Mutator', STM)
		break;
	STM.PlayerFire(Instigator, 4);			// 4 = Bio. (Each Potential Damage giver is 1 shot! Not ammo!)
	Super.PostBeginPlay();
	Damage = STM.WeaponSettings.BioDamage;
	MomentumTransfer = default.MomentumTransfer * STM.WeaponSettings.BioMomentum;
}


function Timer()
{
	local ut_GreenGelPuff f;

	f = spawn(class'ut_GreenGelPuff',,,Location + SurfaceNormal*8); 
	f.numBlobs = numBio;
	if ( numBio > 0 )
		f.SurfaceNormal = SurfaceNormal;	
	PlaySound (MiscSound,,3.0*DrawScale);	
	if ( (Mover(Base) != None) && Mover(Base).bDamageTriggered )	// A Base ain't a pawn, so don't worry.
		Base.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);

	STM.PlayerHit(Instigator, 4, bDirect);		// 4 = Bio.
	if (STM.WeaponSettings.bEnableEnhancedSplashBio) {
		STM.EnhancedHurtRadius(
			self,
			Damage * DrawScale,
			FMin(STM.WeaponSettings.BioHurtRadiusMax, DrawScale * STM.WeaponSettings.BioHurtRadiusBase),
			MyDamageType,
			MomentumTransfer * DrawScale,
			Location);
	} else {
		HurtRadius(
			Damage * DrawScale,
			FMin(STM.WeaponSettings.BioHurtRadiusMax, DrawScale * STM.WeaponSettings.BioHurtRadiusBase),
			MyDamageType,
			MomentumTransfer * DrawScale,
			Location);
	}
	STM.PlayerClear();
	Destroy();	
}

auto state Flying
{
	function ProcessTouch (Actor Other, vector HitLocation) 
	{ 
		if ( Pawn(Other)!=Instigator || bOnGround) 
		{
			bDirect = Other.IsA('Pawn') && !bOnGround;
			Global.Timer(); 
		}
	}
}

defaultproperties {
}
