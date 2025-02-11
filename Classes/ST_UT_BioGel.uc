class ST_UT_BioGel extends UT_BioGel;

var IGPlus_WeaponImplementation WImp;

function PostBeginPlay()
{
	ForEach AllActors(Class'IGPlus_WeaponImplementation', WImp)
		break;
	Super.PostBeginPlay();
	Damage = WImp.WeaponSettings.BioDamage;
	MomentumTransfer = default.MomentumTransfer * WImp.WeaponSettings.BioMomentum;
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

	if (WImp.WeaponSettings.bEnableEnhancedSplashBio) {
		WImp.EnhancedHurtRadius(
			self,
			Damage * DrawScale,
			FMin(WImp.WeaponSettings.BioHurtRadiusMax, DrawScale * WImp.WeaponSettings.BioHurtRadiusBase),
			MyDamageType,
			MomentumTransfer * DrawScale,
			Location);
	} else {
		HurtRadius(
			Damage * DrawScale,
			FMin(WImp.WeaponSettings.BioHurtRadiusMax, DrawScale * WImp.WeaponSettings.BioHurtRadiusBase),
			MyDamageType,
			MomentumTransfer * DrawScale,
			Location);
	}
	Destroy();	
}

state OnSurface
{
	function BeginState()
	{
		if (WImp.WeaponSettings.BioPrimaryInstantExplosion)
			global.Timer();
		else
			super.BeginState();
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
			Global.Timer(); 
		}
	}
}
