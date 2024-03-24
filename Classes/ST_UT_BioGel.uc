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
	Destroy();	
}

state OnSurface
{
	function ProcessTouch (Actor Other, vector HitLocation)
	{
		GotoState('Exploding');
	}


	function Timer()
	{
		if ( Mover(Base) != None )
		{
			WallTime -= 0.2;
			if ( WallTime < 0.15 )
				Global.Timer();
			else if ( VSize(Location - Base.Location) > BaseOffset + 4 )
				Global.Timer();
		}
		else
			Global.Timer();
	}
	
	function BeginState()
	{
		wallTime = 3.8;
		
		MyFear = Spawn(class'BioFear');
		if ( Mover(Base) != None )
		{
			BaseOffset = VSize(Location - Base.Location);
			SetTimer(0.2, true);
		}
		else
		{
			if (STM.WeaponSettings.BioPrimaryInstantExplosion)
				Timer();
			else
				SetTimer(wallTime, false);
		}
	}

}

state Exploding
{
	ignores Touch, TakeDamage;

	function BeginState()
	{
		SetTimer(0.2, False); // Make explosions after touch not random
	}
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
